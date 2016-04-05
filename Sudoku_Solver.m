%% Sudoku Solver
%
%   A method for adding constraint to a linear optimizations problem to 
%   solve a 4x4 sudoku. 
%

% Constraint 1: Only one number per cell

A1 = zeros(16,64);
b1 = ones(1,16);
counter = 1;

for i = 1:16
   
    A1(i,counter:counter + 4 - 1 ) = 1;
    disp(counter:counter + 4 - 1);
    counter = counter + 4;
    
end

% Constraint 2: Only one of each digit per row

A2 = zeros(16,64);
b2 = ones(1,16);
counterI = 0;
counterJ = 0;
counterR = 1;

for i = 1:4
   for j = 1:4
       
    A2(counterR, ( ( counterI + counterJ) + [1 (1+4*1) (1+4*2) (1+4*3)] ) ) = 1;
    
    disp( (counterI + counterJ) + [1 (1+4*1) (1+4*2) (1+4*3) ] );

    counterI = counterI + 1;
    counterR  = counterR + 1;
    
   end 
   
   counterI = 0;
   counterJ = counterJ + 16;
   
end

% Constraint 2: Only one of each digit per collumn

A3 = zeros(16,64);
b3 = ones(1,16);
counterI = 0;
counterJ = 0;
counterR = 1;

for i = 1:4
   for j = 1:4
       
    A3(counterR, ( ( counterI + counterJ) + [1 (1+16*1) (1+16*2) (1+16*3)] ) ) = 1;
    
    disp( (counterI + counterJ) + [1 (1+16*1) (1+16*2) (1+16*3) ] );

    counterI = counterI + 1;
    counterR  = counterR + 1;
    
   end
      
   counterI = 0;
   counterJ = counterJ + 4;
   
end

% Constraint 3: Only one of each digit per 2X2 cellgroup

A4 = zeros(16,64);
b4 = ones(1,16);
counterI = 0;
counterJ = 0;
counterJV = [0 4*2 4*8 4*10];
counterR = 1;

for i = 1:4
    
       counterJ = counterJV(i);

   for j = 1:4
       
    A4(counterR, (counterI + counterJ) + [(1) (4+1) (4*4+1) (4*4+4+1)] ) = 1;
    
    disp( (counterI + counterJ) + [(1) (4+1) (4*4+1) (4*4+4+1)] );

    counterI = counterI + 1;
    counterR  = counterR + 1;

   end 
      
   counterI = 0;
   
end

% Constraint 4: Add initial digits 

A5 = zeros(4,64);
b5 = ones(1,4);

A5(1,17) = 1;
A5(2,27) = 1;
A5(3,52) = 1;
A5(4,62) = 1;

%A5(1,6) = 1;
%A5(2,17) = 1;
%A5(3,26) = 1;
%A5(4,34) = 1;

% Rewrite into one problem

Atot = [A1 ; A2 ; A3 ; A4 ; A5]; % A matrix
Atot = [Atot ; -Atot]; % Put on standard form
btot = [b1 b2 b3 b4 b5]; % b matrix
btot = [btot -btot]; % Put on standard form
ctot = zeros(1,64); % c matrix (maximizing a zero vector)

% Turn into it's dual to find a basic solution

Atotslack = [Atot eye(size(Atot,1))]; 
ctotslack = [ctot zeros(1,size(Atot,1))];

[dualA,dualb,dualc] = dualproblem(Atotslack,btot,ctotslack,size(Atotslack,2)-size(Atotslack,1)+1:size(Atotslack,2));

% Solve the problem using the simplex method

[dual, basicvars, steps] = simp(dualA,dualb,dualc,1:64);

primalBasic = setdiff(1:200,basicvars);

[dual,x,dualbasic,dualfeasible,dualoptimal] = checkbasic1(Atotslack,btot,ctotslack, primalBasic);


% Turn the problem into a readable sudoku fomulation.

clc

result = x(1:64);

counter = 1;
numList = [];

for i = 1:16

    num = result(counter : counter + 4 - 1)';
    
        if(isequal(num,[1 0 0 0]))
            numList = [numList 1];
        elseif(isequal(num,[0 1 0 0]))
            numList = [numList 2];
        elseif(isequal(num,[0 0 1 0]))
            numList = [numList 3];
        elseif(isequal(num,[0 0 0 1]))
            numList = [numList 4];
        else
            error('Incorrect x');
        end   
        counter = counter + 4;
end

vec2mat(numList,4)