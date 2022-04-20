clc
clear 
close all
rng default;

% Cargamos nuestra base de datos
load('dataset_parsed.mat');

%% Main
percep=feedforwardnet([],'traingdx');

percep.layers{1}.transferFcn='tansig';

percep.divideParam.trainRatio=1;
percep.divideParam.valRatio=0;
percep.divideParam.testRatio=0;

percep=train(percep,Design.P,Design.T);

ytest=sim(percep,Test.P);
error=EvaluateDatabases(Test,ytest);