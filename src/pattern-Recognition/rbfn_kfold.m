clc
clear 
close all
rng default;

% Flags 
NORM=1;

% Cargamos nuestra base de datos
load('dataset_parsed.mat');

if NORM == 1
    % Normalizar datos de diseño
    mean = mean(Design.P,2); 
    desv_std = std(Design.P,[],2);
    Design.P = (Design.P - mean)./desv_std;
    Design.T=Design.T;

    % Normalizar datos de test
    Test.P = (Test.P - mean)./desv_std;
    Test.T = Test.T;
end   


%% Main (k-fold == 4)

num_patterns = size(Design.P,2);
index = ceil(rand(1,num_patterns)*4);
h_aux=10.^(-2:0.1:3);
Ncenters = 100;

for i=1:4
    % Pillamos el curr slot :)
    block_test.P=Design.P(:,index==i);
    block_test.T=Design.T(:,index==i);
    block_design.P=Design.P(:,index~=i);
    block_design.T=Design.T(:,index~=i);
    
    % Hacemos un barrido de h=[1-50] para cada slot
    for h=1:length(h_aux)
        predicted_class = func_RBFN(block_design,h_aux(h),block_test,Ncenters);
        p_error(i,h) = EvaluateDatabases(block_test,predicted_class); 
        n_errors(i,h)=p_error(i,h)*size(block_test.P,2);
    end
end

%No pasa nada que los conjuntos no sean de mismo tamaño (sumamos los errores)
for h=1:length(h_aux)
    n_errors_sum(h)=sum(n_errors(:,h))/num_patterns;
end

figure();
set(gcf,'Position',[100 100 900 700]);
plot(h_aux, n_errors_sum,'LineWidth',1.5); 
grid on;
xlim([0 50]);
title('Evoluci\''on del error (RBFN) con $k$-Fold ','interpreter','latex','fontsize',18);
xlabel('Valor de $h$','interpreter','latex','fontsize',16);
ylabel('Error','interpreter','latex','fontsize',16);

% Con Diseño y test completos probamos la config minima
[~,min_index]=min(n_errors_sum);
min_predicted_class = func_RBFN(Design,h_aux(min_index),Test,Ncenters);
min_error = EvaluateDatabases(Test,min_predicted_class); 