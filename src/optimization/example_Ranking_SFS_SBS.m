clc
clear all
close all


load('DataBreastCancerWisconsin.mat')
%% Ranking de caracteristicas

% Vector de probs de caracteristicas 
P = zeros(1,30);

for n=1:30
    x=zeros(1,30);
    x(n)=1;
    P(n) = EvaluatekfoldNN(x, Data);
end

% Pillamos las 6 mejores, vamos a ordenarlas de mejor a peor
k=6;
[~,ind] = sort(P,'ascend');
x=zeros(1,30);
x(ind(1:k))=1;

% Vamos a pintar la probabilidad de error, con las caracteristicas elegidas
% de forma secuencial
x=zeros(1,30);
for n=1:30
    x(n)=1;
    P(n) = EvaluatekfoldNN(x, Data);
end

figure();
plot(P)
grid minor
title('Select de features - Secuencial')

%% Second Option: Sequential Forward Search 

sfs_sol=zeros(1,30);
P_sol=zeros(1,30);

for i=0:sum(sfs_sol==0)-1
    
    % Get zeros pos 
    ind = find(sfs_sol==0);
    curr_p = zeros(1,length(ind));
    for j=0:length(ind)-1
        curr_sfs_sol = sfs_sol;
        curr_sfs_sol(ind(j+1)) = 1;
        curr_p(j+1) = EvaluatekfoldNN(curr_sfs_sol, Data); 
    end
    
    % Get best op
    [~,index_p] = min(curr_p);
    
    % Set to one that feature
    sfs_sol(ind(index_p)) = 1;
    
    % Lets evaluate curr solution
    P_sol(i+1) = EvaluatekfoldNN(sfs_sol, Data);    
end

figure();
plot(P_sol)
grid minor
title('SFS')
xlim([1,30])
xlabel('Features')
ylabel('Pe')

%% third Option: Sequential Backward Search 

sbs_sol=ones(1,30);
P_solb=zeros(1,30);

for i=0:sum(sbs_sol==1)-1
    
    % Get ones pos 
    ind = find(sbs_sol==1);
    curr_p = zeros(1,length(ind));
    for j=0:length(ind)-1
        curr_sfs_sol = sbs_sol;
        curr_sfs_sol(ind(j+1)) = 0;
        curr_p(j+1) = EvaluatekfoldNN(curr_sfs_sol, Data); 
    end
    
    % Get best op
    [~,index_p] = min(curr_p);
    
    % Set to zero that feature
    sbs_sol(ind(index_p)) = 0;
    
    % Lets evaluate curr solution
    P_solb(i+1) = EvaluatekfoldNN(sbs_sol, Data);    
end

figure();
plot(P_solb)
grid minor
title('SBS')
xlim([1,30])
xlabel('Features')
ylabel('Pe')