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

for i=1:4
    % Pillamos el curr slot :)
    block_test.P=Design.P(:,index==i);
    block_test.T=Design.T(:,index==i);
    block_design.P=Design.P(:,index~=i);
    block_design.T=Design.T(:,index~=i);
    
    % Hacemos un barrido de k=[1-20] (Vecinos) para cada slot
    for k=1:20
        predicted_class = func_kvecino(block_design,k,block_test);
        p_error(i,k) = EvaluateDatabases(block_test,predicted_class); 
        n_errors(i,k)=p_error(i,k)*size(block_test.P,2);
    end
end

%No pasa nada que los conjuntos no sean de mismo tamaño (sumamos los errores)
for k=1:20
    %sum_error(k)=sum(perror(:,k))/4; 
    n_errors_sum(k)=sum(n_errors(:,k))/num_patterns;
end

figure();
set(gcf,'Position',[100 100 900 700]);
plot(n_errors_sum,'LineWidth',1.5); 
grid on;
title('Evoluci\''on del error (KNN) con $k$-Fold ','interpreter','latex','fontsize',18);
xlabel('Valor de $k$ (Vecinos)','interpreter','latex','fontsize',16);
ylabel('Error','interpreter','latex','fontsize',16);

% Con Diseño y test completos probamos la config minima
[~,min_index]=min(n_errors_sum);
min_predicted_class = func_kvecino(Design,min_index,Test);
min_error = EvaluateDatabases(Test,min_predicted_class); 


    
