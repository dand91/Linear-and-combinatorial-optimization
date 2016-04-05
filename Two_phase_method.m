%% Two step method
%
%   Demonstrats an example of the two phase method for a linear 
%   optimization problem. One step for finding a baisc solution, and one 
%   step to find an optimal one. 
%

A = [4 2 5 5 ; -4 -2 -5 -5 ; -3 -5 -4 -1 ; 3 5 4 1]; % A matrix
b = [10 -5 -8 15 3 ]; % b matrix
c = [2 1 3 4]; % c matrix
A2 = [A eye(4)]; % Add slack variable to the original problem i.e put on canonical form
A2 = [A2 ; [1 1 1 1 0 0 0 0]]; % Add row without slack variabels
A2([2 3],:) = -A2([2 3],:); % Negate rows to account for inequality 
c2 = [c zeros(1,4)]; % Pad c to accont for slack variables
A3 = [A2 eye(5)]; % Add slack variables for the first step
b([2 3]) = -b([2 3]); % Negate rows to account for inequality
cInit = [0 0 0 0 0 0 0 0 -1 -1 -1 -1 -1 ]; % Add slack variables for the first step
basicvars = [9 10 11 12 13]; % Basic variables to start with (slack variables)

 %%
[tableau, basicvars2, steps] = simp(A3,b,cInit,basicvars);

%%

[tableau, basicvars, steps] = simp(A2,b,c2,basicvars2);