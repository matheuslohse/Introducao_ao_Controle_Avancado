clc
close all
clear all

addpath('data');
load('variaveis.mat','Fz','Cz');

global Fz Cz Pz Hz Gz

%% Configura��o da Simula��o

% Atraso de transporte
tau = 5;
s = tf([1 0],[1]);

% Tempo total de simula��o
ttotal = 120; % s

% Per�do de amostragem do controle
T = 0.1; % s

% Flag para habilitar/desabilitar ru�do no sensor da planta
global noise
noise = true; %( false -> sem ru�do , true -> com ru�do )

% Flag para simula��o de dist�rbio externo na entrada da planta
global dist
dist = 1; %( 0 -> sem dist�rbio ,
          %  1 -> dist�rbio do tipo degrau ativado aos 60 segundos )
   
%% Ensaio do Sistema

%Trouxe pra c�
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
% yc -> sinal de sa�da do sistema (limpo)
% yn -> sinal de sa�da do sistema (ruidoso)
% u -> sinal de controle do sistema
% r -> sinal de refer�ncia do controle
% d -> sinal de perturba��o aplicado na planta

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

%% Anima��o

%runanim( u , y , T );

%% Plotagem

figure
subplot(2,1,1)
stairs(t,r,'r')
hold on
stairs(t,yn,'b')
grid on
xlabel('t [s]')
ylabel('y(t) : n�vel do tanque [m]')
title('Resposta (Sa�da do Sistema)')
legend('Refer�ncia','Sa�da','Location','SE')
subplot(2,1,2)
stairs(t,u,'b')
grid on
xlabel('t [s]')
ylabel('u(t) : abertura da v�lvula')
title('Sinal de Controle (Entrada do Sistema)')
