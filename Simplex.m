function [tableau,basicvars,steps,xb]=Simplex(A,b,c,basicvars)
% [tableau,basicvars,steps,xb] = Simplex(A,b,c,basicvars)
%
% A    m*n-matrix
% b    m*1-matrix, b>=0
% c    n*1-matrix
% basicvars 1*m - matrix with indices for feasible basic variables.
%
% Shows a movie of how the simplex method works
% on the problem 
%                   max(c'x), when Ax=b, x>=0.
% 

[m,n]=size(A);

% Create a tableau with slack variables
[tableau,xb,basic,feasible,optimal]=Simplexbasic(A,b,c,basicvars);

steps = 0;

% Loop until all reduced costs are non-positive
while min(tableau(m+1,1:n)) < 1e-6
    
    steps = steps + 1;
	
	% Choose variable to enter
    
    % Using Bland's rule
    
    %q = find(tableau(end,1:end-1) < -1e-6,1);
    
    % Choosing at random

    qV = find(tableau(end,1:end-1) < 1e-6);
    q = qV(randi([1 length(qV)],1,1));

    % Check if variable is unbounded
    leavecol = tableau(1:end-1,q);
    if max(leavecol)<=0
        disp('Problem is unbounded.');
        leavecol
        return
    end

    % Choose variable to leave
    leavecol(leavecol < 1e-6) = NaN; % makes sure that only positive ratios will be selected
    leavecol = tableau(1:end-1,end)./leavecol;
    [~,p] = min(leavecol);

	% Update basic vars
	basicvars(p) = q;
   
	% Compute new tableau with the new basic variables
	[tableau,xb,basic,feasible,optimal]=Simplexbasic(A,b,c,basicvars);

	if ~feasible
		error('Not feasible');
    end

end

disp(tableau)
disp('Method complete')

end