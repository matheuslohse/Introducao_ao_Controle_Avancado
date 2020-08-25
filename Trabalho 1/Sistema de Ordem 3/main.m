clc
close all
clear all

addpath('data');

%% Configura��o da Simula��o

% Tempo total de simula��o
ttotal = 10; % s

% Per�do de amostragem do controle
T = 0.01; % s

% Flag para habilitar/desabilitar ru�do no sensor da planta
global noise
noise = false; %( false -> sem ru�do , true -> com ru�do )

%% Ensaio do Sistema

[t,y,u,r] = runsim( ttotal , T , 1e-4 );

% t -> vetor de tempo
% y -> sinal de sa�da do sistema
% u -> sinal de controle do sistema
% r -> sinal de refer�ncia do controle

%% Plotagem

figure
subplot(2,1,1)
stairs(t,y,'b')
grid on
xlabel('t [s]')
ylabel('y(t)')
title('Resposta (Sa�da do Sistema)')
subplot(2,1,2)
stairs(t,u,'b')
grid on
xlabel('t (seconds)')
ylabel('u(t)')
title('Sinal de Controle (Entrada do Sistema)')

%% Utilize este espa�o para identificar seu modelo

y1=zeros(size(y));
m=1;
y1(m+1:end) = y(1:end-m);

y2=zeros(size(y));
n=2;
y2(n+1:end) = y(1:end-n);

y3=zeros(size(y));
l=3;
y3(l+1:end) = y(1:end-l);

u1=zeros(size(u));
m=1;
u1(m+1:end) = u(1:end-m);

u2=zeros(size(u));
n=2;
u2(n+1:end) = u(1:end-n);

u3=zeros(size(u));
l=3;
u3(l+1:end) = u(1:end-l);

u4=zeros(size(u));
p=4;
u4(p+1:end) = u(1:end-p);

psi = [y1 y2 y3 u4 u3 u2 u1];

teta = ((psi'*psi)^-1)*psi'*y;

Gz = tf([teta(4) teta(5) teta(6) teta(7)],[1 -teta(1) -teta(2) -teta(3)],T);

Gs = d2c(Gz, 'zoh');


%% Valida��o do Modelo Indentificado

% Comente o "return" a seguir para rodar este bloco.

% return

% Obs: Para que este trecho do c�digo funcione, voc� deve ter declarado
% o modelo cont�nuo do sistema com o nome "Gs" utilizando a fun��o "tf".
% Digite no "help tf" no prompt para obter ajuda.

disp('Efetuando a valia��o do modelo...')

[ts,ys] = runsim_step( ttotal , T , 1e-4 );
figure
plot(ts,ys,'r','Linewidth',2)
hold on
step(Gs,ttotal,'b');
grid on
xlabel('t')
ylabel('u(t)')
title('Respostas ao Degrau Unit�rio')
legend('Sistema Original','Modelo','Location','SE')
