clc
clear 
close all

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


Nocultas=10;

red=feedforwardnet(Nocultas,'traingdx');

red.divideParam.trainRatio=0.8;
red.divideParam.valRatio=0.2;
red.divideParam.testRatio=0;
red.trainParam.max_fail=1000;
red.trainParam.epochs=10000;

red=train(red,Design.P,Design.T);

ytest=sim(red,Test.P);
error=EvaluateDatabases(Test,ytest);

