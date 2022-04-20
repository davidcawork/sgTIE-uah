%Clasificador cuadr�tico de m�nimos cuadrados
function error=func_CMC(Design,Test)
    %DISE�O
    Qdesign=[ones(1,size(Design.P,2)); Design.P; Design.P.^2; Design.P(1,:).*Design.P(2,:)];
    t=Design.T; %Etiquetas
    v=t*Qdesign'*inv(Qdesign*Qdesign'); %Pesos calculados

    %TEST
    Qtest=[ones(1,size(Test.P,2));Test.P;Test.P.^2; Test.P(1,:).*Test.P(2,:)];
    ytest=v*Qtest;
    error=EvaluateDatabases(Test,ytest); %Error con los pesos claculados
end