%% Car manufacturer transportation

% An automobile manufacturer has to assemble plants in three different
% locations with capacities of 100K, 120K and 60K cars per year,
% respectivly (K=1000). The cars are assembled and then sent to major
% markets. In total four different locations, each location requires 50K,
% 40K, 90K nad 70K of cars per year, respectivly. The price (in EUROS) per
% var transported to each locations is as follows:
%
%        |11 * 8 6|
% Cost = |7  5 6 8|
%        |7  6 8 5|
%
% However, there are no routs from plant 1 to market 2 (* in table).
% Due to limited transportation capacity, no more than 40K vars can be
% transported from plant 1 to market 3. Similarly, no more than 40K cars
% from plant 2 to market 3 and no more than 40K from plant 3 to market 3
% can be transported. Find the opimal transportation pattern in order to
% minimize cost with these restrictions.

infSub = 1000; % Infinity

Cost = [11 infSub 8 infSub infSub 6 0 ; 7 5 infSub 6 infSub 8 0 ; 7 6 infSub infSub 8 5 0];
Supply = [100 120 60];
Demand = [50 40 40 40 10 70 30];

[x,cost,costV] = transport(Supply,Demand,Cost)