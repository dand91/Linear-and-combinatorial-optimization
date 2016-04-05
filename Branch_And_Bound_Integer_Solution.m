%% Branch and bound 
%
%   Short demonstration of the branch and bound method to find an integer
%   solution to a linear opimization probelm. 
%

%(root)

clc 
clear

Ar = [2 1 3 1 ; 2 3 0 4 ; 3 1 2 0];
Ar = [Ar eye(3)];
cr = [1 2 1 1];
cr = [cr zeros(1,3)];
br = [8 12 18];

bvr = [5 6 7];
[tableau, bvrn, steps] = simp(Ar,br,cr,bvr);
[tableau,x,basic,feasible,optimal] = checkbasic1(Ar,br,cr,bvrn);

tableau
x(1:4)'

% tableau =
% 
%     0.4444         0    1.0000   -0.1111    0.3333   -0.1111         0    1.3333
%     0.6667    1.0000         0    1.3333         0    0.3333         0    4.0000
%     1.4444         0         0   -1.1111   -0.6667   -0.1111    1.0000   11.3333
%     0.7778         0         0    1.5556    0.3333    0.5556         0    9.3333
% x =
%
%         0    4.0000    1.3333         0
% 
% Choose the branches x3 <= 1 and x3 >= 2

%% LEAF 1 -> x3 <= 1 

Ar1 = [Ar zeros(3,1); [0 0 1 0 0 0 0 1]];
br1 = [br';1];
cr1 = [cr';0];

slackvars = [5 6 7 8];

[dualA,dualb,dualc] = dualproblem(Ar1,br1,cr1,slackvars);

bvr1 = setdiff(1:8,[bvrn 8]);

[dual, bvr1n, steps] = simp(dualA,dualb,dualc,bvr1);

pv1 = setdiff(1:8,bvr1n);

[primal,x,dualbasic,dualfeasible,dualoptimal] = checkbasic1(Ar1,br1,cr1,pv1);
primal
x(1:4)'

% x =
% 
%      0     4     1     0
% 
% Integer solution
 
%% LEAF 2 -> x3 >= 2 

Ar2 = [Ar zeros(3,1); [0 0 -1 0 0 0 0 1]];
br2 = [br';-2];
cr2 = [cr';0];

slackvars = [5 6 7 8];

[dualA,dualb,dualc] = dualproblem(Ar2,br2,cr2,slackvars);

bvr2 = setdiff(1:8,[bvrn 8]);

clc

[dual, bvr2n, steps] = simp(dualA,dualb,dualc,bvr2);

pv2 = setdiff(1:8,bvr2n);

[primal,x,dualbasic,dualfeasible,dualoptimal] = checkbasic1(Ar2,br2,cr2,pv2);
primal
x(1:4)'

% x =
% 
%      0     2     2     0
% 
% Integer solution