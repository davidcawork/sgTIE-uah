clc
clear 
close all

load('DataBreastCancerWisconsin.mat');

%% GA
gens = 20;
num_indv = 400;
features = 30;
prob_mut=0.02;

% Gatherer stats
stats = zeros(gens,3); % min,avg,max

% Let's build our poblation :)
poblation=rand(num_indv,features)>0.5; % (num_indv x features)


% Main loop
for i=0:gens-1
    
    % Ranking and Depredation
    fitness = zeros(1,num_indv);
    for j=0:num_indv-1
        fitness(j+1) = EvaluatekfoldNN(poblation(j+1,:),Data);
    end
    
    % Lets sort using fitness info
    poblation_wlabels = [poblation fitness.'];
    poblation_wlabels = sortrows(poblation_wlabels, features+1);
    poblation = poblation_wlabels(1:num_indv,1:features);
    
    % Depredation
    n_indv_saved = round(num_indv*0.1);
    poblation(n_indv_saved+1:end,:)= NaN;
    
    % Cross
    n_childs = num_indv - n_indv_saved;
    for k=0:n_childs-1
        %select the parents
        ind_parents = randperm(n_indv_saved,2);
        father = poblation(ind_parents(1),:);
        mother = poblation(ind_parents(2),:);
        
        child = [father(1:features/2) mother(features/2+1:end)];
        
        % Append child
        poblation(n_indv_saved+k+1,:) = child;
    end
    
    % Mutation
    best = poblation(1,:);
    
    mask=rand(size(poblation))<prob_mut;
    poblation(mask)=~poblation(mask);
    poblation(1,:) = best;
    
    
    % Gather stats
    stats(i+1,:) = [min(fitness) mean(fitness) max(fitness)];
    
end


figure();
hold on
plot(stats(:,1).')
plot(stats(:,2).')
plot(stats(:,3).')
xlim([1 gens])
title('GA')
xlabel('Generation')
ylabel('Pe')
legend('min','avg','max')
grid minor
hold off