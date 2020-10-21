clc
close all
clear all

addpath('data');
run design

%% Configura��o da Simula��o

% Tempo total de simula��o
ttotal = 30; % s

% Per�do de amostragem do controle (n�o alterar)
T = 1e-3; % s

% Condi��es iniciais do sistema
pos0 = -2;            % posi��o inicial do carro (metros)
ang0 = 160*(pi/180);  % �ngulo inicial da haste (radianos)

x0 = [ pos0 ; 0 ; ang0 ; 0 ];

% Flag para habilitar/desabilitar ru�do nos sensores
global noise
noise = true; %( false -> sem ru�do , true -> com ru�do )

%% Simula��o do Sistema

[t,x,y,u,r] = runsim( ttotal , T , 1e-4 , x0 );

% t -> vetor de tempo
% x -> estados do sistema
% y -> sinal dos sensores do sistema
% u -> sinal de controle do sistema
% r -> sinal de refer�ncia do controle

%% Plotagem

figure('outerposition',[700 50 580 768])
subplot(3,1,1)
plot(t,r(:,1),'r--')
hold on
plot(t,x(:,1),'b')
xlabel('t')
ylabel('Posi��o do Carro')
grid on
subplot(3,1,2)
plot(t,(180/pi)*x(:,3),'b')
grid on
ylabel('�ngulo do P�ndulo')
subplot(3,1,3)
plot(t,u,'b')
grid on
ylabel('Sinal de Controle')

%% Anima��o

figure('outerposition',[0 50 700 600])
runanim( x );
