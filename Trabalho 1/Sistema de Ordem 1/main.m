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
noise = true; %( false -> sem ruído , true -> com ruído )

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

y1=zeros(size(y));
m=1;
y1(m+1:end) = y(1:end-m); %y(n-1)

u1=zeros(size(u));
k=1;
u1(k+1:end) = u(1:end-k);%u(n-1)

u2=zeros(size(u));
l=2;
u2(l+1:end) = u(1:end-l); %u(n-2)

psi = [y1 u1 u2];

teta = ((psi'*psi)^-1)*psi'*y;

Gz = tf([teta(2) teta(3) ],[1 -teta(1)],T);

Gs = d2c(Gz, 'zoh');
Gs_Ident = tf([-0.01542 5.826],[1 1.226]);

%% Validação do Modelo Indentificado

% Comente o "return" a seguir para rodar este bloco.

%return

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
figure
plot(ts,ys,'r','Linewidth',2)
hold on
step(Gs,ttotal,'b');
step(Gs_Ident,ttotal,'c');%k, c, m
grid on
xlabel('t')
ylabel('u(t)')
title('Respostas ao Degrau Unitário')
legend('Sistema Original','Modelo Quad.','Modelo Ident','Location','SE')
