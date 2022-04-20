clc
clear 
close all

% Cargamos la base datos
load('dataset.mat')

% Hacemos la división => {4/5 design, 1/5 test}
num_patterns = size(dataset,1);

% Pillamos num enteros rng 1 - 5 (Uniforme)
% Cuando sea ind == 5 sera para test.
index = ceil(rand(1,num_patterns)*5);

% Necesitamos contadores para ir almacenando en desing y test
test_cnt=1;
design_cnt=1;

for i=1:num_patterns
    if index(i)==5 
        Test.P(:,test_cnt) = dataset(i,1:9).';
        Test.T(test_cnt) = dataset(i,10);
        test_cnt = test_cnt+1;
        
    else  
        Design.P(:,design_cnt)=dataset(i,1:9).';
        Design.T(design_cnt)=dataset(i,10);
        design_cnt = design_cnt+1;
    end
end

% Pasamos de 2 - 4 = 0 - 1 Notación de clase 
Design.T(find(Design.T == 2)) = 0;
Design.T(find(Design.T == 4)) = 1;
Test.T(find(Test.T == 2)) = 0;
Test.T(find(Test.T == 4)) = 1;

