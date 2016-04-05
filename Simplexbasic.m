function [tableau,x,basic,feasible,optimal,tempA]=Simplexbasic(A,b,c,basicvars)

    c = c(:);
    b = b(:);
    
    [rowsA, colsA] = size(A);
    tableau = [A b; -c' 0];
    x = zeros(colsA,1);
    x(basicvars) = b;
    
    basic = 1;
    feasible = 0;
    optimal = 0;
    
    % find basic variables
    Ab = A(:,basicvars); 
    
    % check if solution is basic
    if (rank(Ab) ~= length(b))
        basic = 0;
        return;
    end
    
    % find Xb
    Xb = inv(Ab)*b;
    x = zeros(colsA,1);
    x(basicvars) = Xb;
        
    % check if solution is feasible
    if (min(Xb) >= 0)
       feasible = 1;
    else 
        disp('Infeasible');
        return;
    end
    
    tempA = A;
    
% The steps below has been commented out, instead a less effective but more
% robust way is implemented. 
    
%     A = [A b; -c' 0];
%     define A in terms of basicvars    
%     for i = 1:size(basicvars,2);
%         A(i,:) = A(i,:)/A(i,basicvars(i));
%         for j = 1:rowsA+1
%             if j ~= i
%                 A(j,:) = A(j,:) - A(j,basicvars(i))*A(i,:);
%             end
%         end
%     end
%
%     construct tableau
%     tableau = A;
%     tableau(end) = c'*x;
    
    tableau = [[inv(Ab)*tempA ; c(basicvars)'*inv(Ab)*tempA-c'] [Xb ; c'*x]];

    % check if solution is optimal
    if (min(tableau(end,:) >= 0))
        optimal = 1
    end


end