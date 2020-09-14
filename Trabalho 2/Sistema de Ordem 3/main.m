clc
close all
clear all
load ('arquivo.mat');
addpath('data');

%% Configuração da Simulação (não alterar)

% Tempo total de simulação
ttotal = 10; % s

% Perído de amostragem do controle
T = 0.01; % s

% Flag para habilitar/desabilitar ruído no sensor da planta
global noise
noise = false; %( false -> sem ruído , true -> com ruído )

% Flag para simulação de distúrbio externo na entrada da planta
global dist
dist = 0; %( 0 -> sem distúrbio ,
          %  1 -> distúrbio do tipo degrau ,
          %  2 -> distúrbio do tipo senoidal de período 1 segundo )
          %
          % Obs: os distúrbios são ativados aos 5 segundos da simulação.
         
%% Ensaio do Sistema

[t,y,u,r,d] = runsim( ttotal , T , 1e-4 );

% t -> vetor de tempo
% y -> sinal de saída do sistema
% u -> sinal de controle do sistema
% r -> sinal de referência do controle
% d -> sinal de perturbação aplicado na planta

Gs = tf([112], [1 4.06 11.98 23.9]);
Cs = tf(Crl);
Fs = tf(Frl);

step(Fs*feedback(Cs*Gs,1));
hold on

Cz = c2d(Cs,T,'zoh');
Fz = c2d(Fs,T,'zoh');

hold off
%% Plotagem

figure
subplot(2,1,1)
stairs(t,r,'r')
hold on
stairs(t,y,'b')
grid on
xlabel('t [s]')
ylabel('y(t)')
title('Resposta (Saída do Sistema)')
legend('Referência','Saída','Location','SE')
subplot(2,1,2)
stairs(t,u,'b')
grid on
xlabel('t (seconds)')
ylabel('u(t)')
title('Sinal de Controle (Entrada do Sistema)')
