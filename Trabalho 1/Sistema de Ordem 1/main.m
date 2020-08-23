clc
close all
clear all

addpath('data');

%% Configuração da Simulação

% Tempo total de simulação
ttotal = 10; % s

% Perído de amostragem do controle
T = 0.01; % s

% Flag para habilitar/desabilitar ruído no sensor da planta
global noise
noise = false; %( false -> sem ruído , true -> com ruído )

%% Ensaio do Sistema

[t,y,u,r] = runsim( ttotal , T , 1e-4 );

% t -> vetor de tempo
% y -> sinal de saída do sistema
% u -> sinal de controle do sistema
% r -> sinal de referência do controle

%% Plotagem

figure
subplot(2,1,1)
stairs(t,y,'b')
grid on
xlabel('t [s]')
ylabel('y(t)')
title('Resposta (Saída do Sistema)')
subplot(2,1,2)
stairs(t,u,'b')
grid on
xlabel('t (seconds)')
ylabel('u(t)')
title('Sinal de Controle (Entrada do Sistema)')

%% Utilize este espaço para identificar seu modelo










%% Validação do Modelo Indentificado

% Comente o "return" a seguir para rodar este bloco.

return

% Obs: Para que este trecho do código funcione, você deve ter declarado
% o modelo contínuo do sistema com o nome "Gs" utilizando a função "tf".
% Digite no "help tf" no prompt para obter ajuda.

disp('Efetuando a valiação do modelo...')

[ts,ys] = runsim_step( ttotal , T , 1e-4 );
figure
plot(ts,ys,'r','Linewidth',2)
hold on
step(Gs,ttotal,'b');
grid on
xlabel('t')
ylabel('u(t)')
title('Respostas ao Degrau Unitário')
legend('Sistema Original','Modelo','Location','SE')
