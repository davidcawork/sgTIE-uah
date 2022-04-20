clc
clear 
close all
rng default;

% Cargamos nuestra base de datos
load('dataset_parsed.mat');


%% Main

%svm_auto=fitcsvm(Design.P',Design.T','KernelFunction','rbf');
svm_auto=fitcsvm(Design.P',Design.T','KernelFunction','rbf','OptimizeHyperParameters','auto');

[yclass,score]=predict(svm_auto,Test.P');
error = EvaluateDatabases(Test,yclass');