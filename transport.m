function [x,cost,costV] = transport(s,d,c)
% [x,cost]=transport(s,d,c)
% Input:
%   s = supplies         (m*1)
%   d = demands          (n*1)
%   c = costs            (m*n)
% Output
%   x = optimal solution (m*n)
%   cost = minimal transport cost

costV=[];

[x,b]=northwest(s,d); % initial solution to the problem

while true
    
    [v,w]=multipliers(x,c,b); % find "slack variables"
    
    c_hat=c-v*ones(size(w'))-ones(size(v))*w'; % c_hat = c - v - w
    
    if any(any(c_hat<0)) % if any negative values exists 
        
        index = find(c_hat < 0,1); % find place of first negative value
        [row,col]=find(c_hat == c_hat(index),1); % find row and column of negative value
        
    else % if no negative values exists 
        
        break 
        
    end;
    
    [x,b] = cycle(x,row,col,b); % update x and b 
    
    costV = [costV ; sum(sum(c.*x))]; %#ok<AGROW> % calculate new cost
end

cost = costV(end); % select most recent cost

end