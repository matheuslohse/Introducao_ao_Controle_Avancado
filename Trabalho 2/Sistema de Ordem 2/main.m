clc
close all
clear all

addpath('data');

%% Configura��o da Simula��o (n�o alterar)

% Tempo total de simula��o
ttotal = 10; % s

% Per�do de amostragem do controle
T = 0.01; % s

% Flag para habilitar/desabilitar ru�do no sensor da planta
global noise
noise = false; %( false -> sem ru�do , true -> com ru�do )

% Flag para simula��o de dist�rbio externo na entrada da planta
global dist
dist = 0; %( 0 -> sem dist�rbio ,
          %  1 -> dist�rbio do tipo degrau ,
          %  2 -> dist�rbio do tipo senoidal de per�odo 1 segundo )
          %
          % Obs: os dist�rbios s�o ativados aos 5 segundos da simula��o.
         
%% Ensaio do Sistema

[t,y,u,r,d] = runsim( ttotal , T , 1e-4 );

% t -> vetor de tempo
% y -> sinal de sa�da do sistema
% u -> sinal de controle do sistema
% r -> sinal de refer�ncia do controle
% d -> sinal de perturba��o aplicado na planta

Gs_Ident = tf([-0.009224 6.08],[1 1.241 1.475]);

Fs2 = tf([14.76],[1 6 14.76]);
Cs2 = 43.191 * tf([1 6 14.76],[1 25 0]);
Sys2 = Fs2*feedback(Cs2*Gs_Ident,1);
step(Sys2)
title('ROOTLOCUS')

%% Plotagem

figure
subplot(2,1,1)
stairs(t,r,'r')
hold on
stairs(t,y,'b')
grid on
xlabel('t [s]')
ylabel('y(t)')
title('Resposta (Sa�da do Sistema)')
legend('Refer�ncia','Sa�da','Location','SE')
subplot(2,1,2)
stairs(t,u,'b')
grid on
xlabel('t (seconds)')
ylabel('u(t)')
title('Sinal de Controle (Entrada do Sistema)')
