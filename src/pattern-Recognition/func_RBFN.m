function clase=func_RBFN(Design,h,Test,Nc)
    Ncenters=Nc;
    
    [~,C]=kmeans(Design.P',Ncenters,'Maxiter',1000);

    D=dist(C,Design.P);
    P=exp(-0.5/h^2*D.^2);
    Q=[ones(1,size(Design.P,2));P];
    W=Design.T*Q'*pinv(Q*Q');
    Dtest=dist(C,Test.P);
    Ptest=exp(-0.5/h^2*Dtest.^2);
    Qtest=[ones(1,size(Test.P,2));Ptest];
    clase=W*Qtest;

end