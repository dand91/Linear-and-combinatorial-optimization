%% Consultant firm transportation. 

% Consultant firm has 6 consultats, the folowing vecotr are the maximum
% number of days each of these consultants can work.

workSupply = [250 200 170 220 300 110];

% The firm has 10 clients, the following table shows how much they agree 
% to pay for one day of work of the corresponding consultant.

costs = [210 200 350 250 100 300 ; 200 220 320 230 160 340 ; ...
        180 210 300 240 150 330 ; 190 220 250 210 130 310 ; ...
        210 200 300 190 100 300 ; 180 210 330 250 180 320 ; ...
        180 210 330 250 180 320 ; 200 220 320 220 170 310 ; ...
        190 200 210 200 180 300 ; 190 250 310 270 140 310 ; 
        0 0 0 0 0 0];

% The firms 10 clients needs 120 days of consulting each.

workDemand = [120 120 120 120 120 120 120 120 120 120 50];

[x,cost,costV] = transport(workSupply,workDemand,costs')