clc
clear all
close all

syms x1 x2 x3 x4 u

g   = 9.81;   % acelera��o da gravidade [m/s^2]
l   = 2;      % comprimento do p�ndulo [m]
m1  = 1;      % massa do carro [kg]
m2  = 0.2;    % massa do p�ndulo [kg]
b1  = 0.6;    % fator de atrito do carro [kg/s]
b2  = 0.1;    % fator de atrito do p�ndulo [kgm/s]
sat = 10;     % n�vel de satura��o do controle [N]
T = 0.001;    % per�odo de amostragem do controle [s]

%% Utilize este espa�o para projetar o seu controle

M = [m1+m2 m2*l*cos(x3);m2*l*cos(x3) m2*l];
C = [b1 -m2*l*sin(x3)*x4;0 b2];
G = [0;m2*g*l*sin(x3)];
F = [u; 0];

resp = inv(M)*F - inv(M)*C*[x2;x4] - inv(M)*G;
x2_dot = resp(1);
x4_dot = resp(2);