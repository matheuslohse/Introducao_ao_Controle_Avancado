clc
close all
clear all

addpath('data');
load('variaveis.mat','Fz','Cz');

global Fz Cz Pz Hz Gz

%% Configuração da Simulação

% Atraso de transporte
tau = 5;
s = tf([1 0],[1]);

% Tempo total de simulação
ttotal = 120; % s

% Perído de amostragem do controle
T = 0.1; % s

% Flag para habilitar/desabilitar ruído no sensor da planta
global noise
noise = true; %( false -> sem ruído , true -> com ruído )

% Flag para simulação de distúrbio externo na entrada da planta
global dist
dist = 1; %( 0 -> sem distúrbio ,
          %  1 -> distúrbio do tipo degrau ativado aos 60 segundos )
   
%% Ensaio do Sistema

%Trouxe pra cá
Cz = tf(Cz);
Fz = tf(Fz);

Gs = tf([2.475],[1 9.472 3.465 1.256]);
Hs = exp(-(5*s));
Ps = Gs*(1 - Hs);

Gz = c2d(Gs,T);
Hz = c2d(Hs,T);
Pz = c2d(Ps,T);


[t,y,yn,u,r,d] = runsim( ttotal , T , 1e-4 );

% t -> vetor de tempo
% yc -> sinal de saída do sistema (limpo)
% yn -> sinal de saída do sistema (ruidoso)
% u -> sinal de controle do sistema
% r -> sinal de referência do controle
% d -> sinal de perturbação aplicado na planta

%Levei pra cima
% Gs = tf([2.475],[1 9.472 3.465 1.256]);
% Hs = exp(-(5*s));
% Ps = Gs*(1 - Hs);
% 
% Gz = c2d(Gs,T);
% Hz = c2d(Hs,T);
% Pz = c2d(Ps,T);

% Fz = tf([0.001],[1 -1.98 0.981],T);
% Cz = 0.42*tf([1 -1.98 0.981],[1 -1.93 0.93],T);

hold on
step(Fz*feedback(feedback(Cz,Pz)*Gz*Hz,1))
step(Fz*feedback(Cz*Gz,1)*Hz)
legend('Sistema 1','Sistema 2');

%% Animação

%runanim( u , y , T );

%% Plotagem

figure
subplot(2,1,1)
stairs(t,r,'r')
hold on
stairs(t,yn,'b')
grid on
xlabel('t [s]')
ylabel('y(t) : nível do tanque [m]')
title('Resposta (Saída do Sistema)')
legend('Referência','Saída','Location','SE')
subplot(2,1,2)
stairs(t,u,'b')
grid on
xlabel('t [s]')
ylabel('u(t) : abertura da válvula')
title('Sinal de Controle (Entrada do Sistema)')
