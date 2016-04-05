%% Genetic Knapsack Algorithm
%
%   Solve the knapsack priblem using a genetic algorithm
%

clear 
clc

problemsize = 20;
populationssize = 30;

population = zeros(populationssize,problemsize);
populationSort = zeros(populationssize,problemsize);
populationChild = zeros(populationssize,problemsize);
populationChildSort = zeros(populationssize,problemsize);
zV = zeros(1,populationssize);
mzOld = 0;
mz = 0;

%values = [10 2 1 5 4 6 4 2 7 8]; % How much one values each item
%weights = [8 2 5 1 2 3 1 7 6 5]; % How much the item weighs 

values = [10 2 1 5 4 6 4 2 7 8 12 9 2 1 2 7 5 9 2 4]; % How much one values each item
weights = [8 2 5 1 2 3 1 7 6 5 10 2 7 4 3 9 4 6 1 8]; % How much the item weighs 

%values = [10 2 1 5 4 6 4 2 7 8 12 9 2 1 2 7 5 9 2 4 9 3 8 5 6 2 7 8 9 2]; % How much one values each item
%weights = [8 2 5 1 2 3 1 7 6 5 10 2 7 4 3 9 4 6 1 8 6 5 3 5 7 9 2 8 2 10]; % How much the item weighs 

maxWeight = sum(weights(1:length(weights)/4)); % Total capacity of knapsack
%maxWeight = 10000; % Total capacity of knapsack (Trivial)
    
Iterations = 0;

i = 1;

while(true) % Building of initial chromosomes;
    
    for j = 1:problemsize
        
        r = randn(1); % If a 1 or 0 should be added to place i;
        
        if r < 0
            population(i,j) = 0;
        else
            population(i,j) = 1;
        end
    end
    
    if(weights*population(i,:)' <= maxWeight) % If the chromosome is feasible
       
        i = i + 1;
        
        if i == populationssize % If list is full
           
            break;
           
        end 
    end
end

while(true) % Main loop, genetic algorithm 
     
    zV = values*population' % Calculate how good chormosomes are
    
    mzOld = mz;
    mz = mean(zV); % Calculate mean for break criterion 
    zVTemp = zV; % Save value for later

    for i = 1:populationssize % Sort population
       
       [~,index] = max(zV); % Find index of best chromosome
       
       zV(index) = -inf; % Remove value so it wond be selected again
       
       populationSort(i,:) = population(index,:); % Add chomosome to sorted vector
       
    end
    
    childChooser = [];
    
    for i = 1:populationssize % Create a vector where each child is represented by it's
                              % index the amount of spaces it takes up is determined by 
                              % its fitness. Choosing an element at random will generate
                              % a child, but a more fit one with higher probability.

       childChooser = [childChooser ones(1,zVTemp(i))*i]; 

    end
    
    counter = 1;
    
    while(true) % Crossover 
                
        r1 = randi([1 length(childChooser)],1,1); % Randomize for parent 1
        r2 = randi([1 length(childChooser)],1,1); % Randomize for parent 2
        
        child1 = populationSort(childChooser(r1),:); % Choose parent 1
        child2 = populationSort(childChooser(r2),:); % Choose parent 2

        r3 = randi([1 problemsize],1,1); % Place where parents should mix
        
        populationChild(counter,:) = [child1(1:r3) child2(r3 + 1:problemsize)]; % Create child 1
        populationChild(counter + 1,:) = [child2(1:r3) child1(r3 + 1:problemsize)]; % Create child 2
        
        if(weights*populationChild' <= maxWeight) % If crossovers is feasible
            
            counter = counter + 2;
            
            if counter >= populationssize % If all crossovers are feasible
                
                break;
                
            end
        end
    end
    
    zVChild = values*populationChild'; % Calculate how children are preforming
    zVTempChild = zVChild; % Save the index for later

    for i = 1:populationssize % Sort populationChild
       
       [~,index] = max(zVChild); % Find the child with most potential
       zVChild(index) = -inf; % Remove index so it will not be choosen again
       
       populationChildSort(i,:) = populationChild(index,:); % Add to new sorted vector
       
    end
    
    for i = 5:populationssize % Mutation with Elitism, save the best. 
       
        for j = 1:problemsize
            
            r3 = randi([1 100],1,1); % If there is to be a mutation
            
            if r3 <= 5 %probability 5/100
                
                tempChild = populationChildSort(i,:); % Save child
                
                if populationChildSort(i,j) == 1 % Switch from 0 to 1 or 1 to 0
                    
                    populationChildSort(i,j) = 0; % 1 -> 0
                    
                else
                    
                    populationChildSort(i,j) = 1; % 0 -> 1
                    
                end
                
                if weights*populationChildSort(i,:)' > maxWeight % Check if mutation is feasible, otherwhise restore and redo.
                    
                    populationChildSort(i,:) = tempChild; % Restore chormosome
                    
                    i = i - 1; % Redo iteration

                end
            end
        end
    end
    
    
    zVChild = values*populationChildSort'; % Calculate how children are preforming
    zVTempChild = zVChild; % Save the index for later

    for i = 1:populationssize % Sort populationChild
       
       [~,index] = max(zVChild); % Find the child with most potential
       zVChild(index) = -inf; % Remove index so it will not be choosen again
       
       populationChildSort(i,:) = populationChildSort(index,:); % Add to new sorted vector
       
    end

    mzSave(Iterations+1) = mz; % Save for printing 
    zvSave(Iterations+1) = max(values*populationChildSort'); % Save for printing 

    nbrSaved = 5;
    
    populationChildSort(populationssize - nbrSaved + 1:populationssize,:) = populationSort(1:nbrSaved,:); % Save the best
    
    result =  weights*populationChildSort'; % Check result, if we should break
    
    if( length(mzSave) > 4 && abs(mzSave(end) - mzSave(end-1)) + abs(mzSave(end) - mzSave(end-2))...
        + abs(mzSave(end) - mzSave(end-3)) + abs(mzSave(end) - mzSave(end-4)) < 0.001 && Iterations > 100) % Stoping criterions
        
       disp('FOUND');
       break; 
       
    end
    
    Iterations = Iterations + 1;
    population = populationChildSort; % new population equals old population
    
end

close all
plot(mzSave./max(mzSave));
hold on 
plot(zvSave./max(zvSave));
legend('Mean value','Current optimum')
 

%% USE ONLY IF NUMBER OF LOCI IS LESS THAN 10

i = 0;

while(true) %% Find maximum value by exhaustive search
    
v = [zeros(1,i) ones(1,10-i)]; % Number of zeros in chromosome
P = perms(v); % create permutations
vr = values*P'; % Check resulting values
plot(vr)
wr = weights*P'; % Check resulting weights

I = find(wr > maxWeight); % Find non feasible solutions
    
    vr(I) = []; % Delete non feasible solutions
    
    r = max(vr); % Find largest value

    if length(r) > 0 % If largest value exist, optimum is found
    
        disp('Optimal result is: ');
        disp(r);
        break;
          
    else % Else add a zero to the chormosomes and redo
        i = i + 1
    end
end