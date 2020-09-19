clc
close all
clear all

addpath('data');
load('variaveis_controlador.mat')
global Fz Gz Cz

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

Hs1 = tf([-tau 2],[tau 2]); 
Hs2 = tf([tau^2 -6*tau 12],[tau^2 6*tau 12]);
Hs3 = tf([-tau^3 12*(tau^2) -60*tau 120],[tau^3 12*(tau^2) 60*tau 120]);

Gs = tf([2.475],[1 9.472 3.465 1.256]);
hold on
step(Gs*exp(-5*s))
step(Gs*Hs1)
step(Gs*Hs2)
step(Gs*Hs3)

Fz = c2d(Fs,T,'tustin');
Gz = c2d(Gs,T,'tustin');
Cz = c2d(Cs,T,'tustin');

[t,y,yn,u,r,d] = runsim( ttotal , T , 1e-4 );

% t -> vetor de tempo
% yc -> sinal de sa�da do sistema (limpo)
% yn -> sinal de sa�da do sistema (ruidoso)
% u -> sinal de controle do sistema
% r -> sinal de refer�ncia do controle
% d -> sinal de perturba��o aplicado na planta
%% Anima��o

% runanim( u , y , T );


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
