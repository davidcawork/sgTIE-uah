function clase=kernel(Design,h,Test)
% OJO: Tiene que funcionar para múltiples clases
% h = Ancho de la campana de gauss -> Parámetro a estimar con kfold
    n_patronesTest=size(Test.P,2);
    n_clases=size(Design.T,1);
    clase=zeros(1,n_patronesTest);
    L=size(Design.P,1);  %Número de características
    if n_clases==1  %Si son dos clases, único vector con 0/1 = hay dos clases
        n_clases=2;
    end
    
    for n=1:n_patronesTest
        x=Test.P(:,n);
        %Vamos a clasificarlo
        if n_clases==2
            clase_patrones=Design.T;
            clase_patrones=clase_patrones+1; %Paso de (0/1) a (1/2) para funcionar de forma genérica
        else
            [~,clase_patrones]=max(Design.T);
        end
        %Patrones de diseño que pertenezcan a esa clase = Cada clase por separado
        for c=1:n_clases 
            %0) Calculo cuáles son los patrones de diseño que pertenecen a la clase c
            x_n=0; %Número de patrones de diseño que pertenecen a la clase c
            patrones_clase=[]; %Almacena patrones de diseño que pertenecen a clase c
            for j=1:size(Design.P,2)
                if clase_patrones(j)==c
                    x_n=x_n+1;
                    patrones_clase.P(:,x_n)=Design.P(:,j);
                end
            end
            n_patrones_clase(c)=x_n;
            P(c)=n_patrones_clase(c)/size(Design.P,2);
            %1) Calcular distancia de x a todos lo patrones de Design.P de la
            %clase c. Algo parecido a D=dist(x',Design.P(:,1:500)).^2;
            D=dist(x',patrones_clase.P).^2;

            %2) algo parecido a f(c)=mean(1/h^2*exp(-D/2/h^2))
            f(c)=mean(1/h^L*exp(-D/2/h^2)); %Estimación de fdp para la clase c
        end

        %3) voy a mirar cuando f(c)*P(c) es mayor => decido
        %P(c) = probabilidad a priori de la clase c
        [~,b]=max(f.*P);
        
        %clase(n)=...
        if n_clases==2
            clase(n)=b(1)-1;
        else
            clase(n)=b;
        end
    end
end