function clase=func_kvecino(Design,k,Test)
    %Devuelve a qu� clase asigno cada uno de los patrones de test
    n_patronesTest=size(Test.P,2);
    n_clases=size(Design.T,1);
    clase=zeros(1,n_patronesTest);
    if n_clases==1  %Si son dos clases, �nico vector con 0/1 = hay dos clases
        n_clases=2;
    end
    
    %Calculamos la clase para cada uno de los patrones de test a partir de
    %la clase de los patrones de dise�o
    for n=1:n_patronesTest
        x=Test.P(:,n); %Patr�n(n) de test
        %1)C�lculo de la distancia de x con todos los patrones de dise�o
        D=dist(x',Design.P);
        %2)Ordenamos las distancias para coger las k m�s cercanas
        [~,indices]=sort(D);
        
        %3)Obtenemos las clases de todos los patrones de dise�o
        if n_clases==2
            clase_patrones=Design.T;
        else
            [~,clase_patrones]=max(Design.T);
        end
        
        %Creamos los contadores por cada clase
        contad_clases=zeros(1,n_clases);
        
        %4)A qu� clase pertenece cada uno de los k vecinos
        clase_patrones_k=clase_patrones(indices(1:k)); %Cogemos las k clases m�s cercanas
        for m=1:k   %POR CADA UNO DE LOS PATRONES COMPROBAMOS SU CLASE
            clase_k=clase_patrones_k(m); %Clase del patr�n(m) de k
            if n_clases==2
                clase_k=clase_k+1; %Para pasar de (0/1) a (1/2) y usarlo como �ndice en los contadores
            end
            if m==1
                contad_clases(clase_k)=contad_clases(clase_k)+1.5;
            else
                contad_clases(clase_k)=contad_clases(clase_k)+1;
            end                
        end
        
        %5)Cu�l es el mayor contador => Ser� la clase del patr�n
        [~,I]=max(contad_clases);
        if n_clases==2
            clase(n)=I-1; %Volvemos a (0/1)
        else
            clase(n)=I;
        end
    end
end
