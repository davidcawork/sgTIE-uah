%Clasificador lineal con mínimo error cuadrático 
function error=func_LMC(Design,Test)
    %DISEÑO
    Qdesign=[ones(1,size(Design.P,2));Design.P];
    t=Design.T; %Etiquetas
    v=t*Qdesign'*inv(Qdesign*Qdesign'); %Pesos calculados

    %TEST
    Qtest=[ones(1,size(Test.P,2));Test.P];
    ytest=v*Qtest;
    error=EvaluateDatabases(Test,ytest); %Error con los pesos claculados
end