clc
clear 
close all
rng default;

% Cargamos nuestra base de datos
load('dataset_parsed.mat');

%% Main

e_lineal = func_LMC(Design,Test);
e_squad = func_CMC(Design,Test);
