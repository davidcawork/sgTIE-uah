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


%% Main

% Froteras de decisión son trazos paralelos a los ejes coordenadas (2D). En 3D son planos 
% Árboles no funcionan bien para características con números reales, 
% están más pensados para características con valores enteros

tree=fitctree(Design.P', Design.T');
%tree=fitctree(Design.P', Design.T', 'OptimizeHyperparameters','auto');

view(tree, 'Mode','graph')
ytest=predict(tree,Test.P');
error = EvaluateDatabases(Test,ytest');

