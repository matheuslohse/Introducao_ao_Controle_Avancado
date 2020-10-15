clc
clear all
close all

syms x1 x2 x3 x4 u

g   = 9.81;   % aceleração da gravidade [m/s^2]
l   = 2;      % comprimento do pêndulo [m]
m1  = 1;      % massa do carro [kg]
m2  = 0.2;    % massa do pêndulo [kg]
b1  = 0.6;    % fator de atrito do carro [kg/s]
b2  = 0.1;    % fator de atrito do pêndulo [kgm/s]
sat = 10;     % nível de saturação do controle [N]
T = 0.001;    % período de amostragem do controle [s]

%% Utilize este espaço para projetar o seu controle

M = [m1+m2 m2*l*cos(x3);m2*l*cos(x3) m2*l];
C = [b1 -m2*l*sin(x3)*x4;0 b2];
G = [0;m2*g*l*sin(x3)];
F = [u; 0];

resp = inv(M)*F - inv(M)*C*[x2;x4] - inv(M)*G;
x2_dot = resp(1);
x4_dot = resp(2);