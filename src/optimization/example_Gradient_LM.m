clc
clear all
close all

% Vars aux
PosAntenas = [0,0;100,0;0,100;100,100]';
PosReal = [70;50];
% Al azar PosReal = 100*rand(2,1);

DistanciaReal = sqrt(sum((PosAntenas-PosReal).^2));

% Introducimos un error
DistanciaMedida = DistanciaReal+5*rand(1,4); %d_k

% Pintamos si queremos la posicion de las antenas 
figure(1)
plot(PosAntenas(1,:).',PosAntenas(2,:).', 'or')
title('Localización del soldado')
xlim([-10,110]);
ylim([-10,110]);
grid on;
hold on;

PosEstimadaInicial = [1;1];
%% Algoritmo del gradiente

PosEstimada = PosEstimadaInicial;
CteMu = 0.1;
iter = 20;

% Pintamos la posicion estimada
plot(PosEstimada(1), PosEstimada(2), 'xb')

% Entramos en el metodo del gradiente
f=zeros(1,iter);

for i = 1:iter
    % Evaluar la funcion e ir guardando, y Calcular el gradiente
    f(i) =  0;
    gradiente = 0;
    for k=0:length(PosAntenas)-1
        x_diff = PosEstimada(1,:) - PosAntenas(1,k+1);
        y_diff = PosEstimada(2,:) - PosAntenas(2,k+1);
        
        % Calculamos el gradiente
        gradiente = gradiente + (-2*(DistanciaMedida(k+1) - sqrt(x_diff^2 + y_diff^2))/(sqrt(x_diff^2 + y_diff^2)))*[x_diff; y_diff];
        
        % Calculamos la función
        f(i) = f(i) + (DistanciaMedida(k+1) - sqrt(x_diff^2 + y_diff^2))^2;
    end
    
    % Pintamos el fin de la ejecucion del algoirmo
    plot(PosEstimada(1), PosEstimada(2), 'xg')

    % Calcular el nuevo punto
    PosEstimada = PosEstimada - CteMu*gradiente;
end

% Pintamos el fin de la ejecucion del algoirmo
plot(PosEstimada(1), PosEstimada(2), 'xg')
legend("Antenas", "Pos init", "Pos Fin");

% Pintamos la evolución de la minimizacion
figure();
plot(f)
grid on;
xlabel("Iteraciones")
ylabel("f(x)")
title('Función a minimizar')

%% Algoritmo LM

PosEstimadaLM = PosEstimadaInicial;

figure(3)
plot(PosAntenas(1,:).',PosAntenas(2,:).', 'or')
title('Localización del soldado - LM')
xlim([-10,110]);
ylim([-10,110]);
grid on;
hold on;

% Posicion inicial
plot(PosEstimadaLM(1), PosEstimadaLM(2), 'og')

% Entramos en el metodo del gradiente
f_LM=zeros(1,iter);

for i = 1:iter
    % Evaluar la funcion e ir guardando, y Calcular el gradiente
    f_LM(i) =  0;
    
    % Necesarias para calcular la jacobiana 
    deriv_x = zeros(1,length(PosAntenas));
    deriv_y = zeros(1,length(PosAntenas));
    error = zeros(1,length(PosAntenas));
    
    for k=0:length(PosAntenas)-1
        x_diff = PosEstimadaLM(1,:) - PosAntenas(1,k+1);
        y_diff = PosEstimadaLM(2,:) - PosAntenas(2,k+1);
        
        % Calculamos las deriv
        deriv_x(k+1) = -x_diff/(sqrt(x_diff^2 + y_diff^2));
        deriv_y(k+1) = -y_diff/(sqrt(x_diff^2 + y_diff^2));
        
        % Calculamos la función
        f_LM(i) = f_LM(i) + (DistanciaMedida(k+1) - sqrt(x_diff^2 + y_diff^2)).^2;
        error(k+1) = DistanciaMedida(k+1) - sqrt(x_diff^2 + y_diff^2);
    end
    
    % Calculamos la Jacobiana
    J = [deriv_x; deriv_y];
    J_t = J.'; 

    % Calcular el nuevo punto
    PosEstimadaLM = PosEstimadaLM - pinv(J*J_t)*J*error.';
    
    % Pintamos el fin de la ejecucion del algoirmo
    plot(PosEstimadaLM(1), PosEstimadaLM(2), 'xg')
end

% Pintamos el fin de la ejecucion del algoirmo
plot(PosEstimadaLM(1), PosEstimadaLM(2), 'xg')
legend("Antenas", "Pos init", "Pos Fin");

% Pintamos la evolución de la minimizacion
figure();
plot(f_LM)
grid on;
xlabel("Iteraciones")
ylabel("f(x)")
title('Función a minimizar')
