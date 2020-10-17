clc
clear all
close all

%% Dados do sistema

g   = 9.81;   % aceleração da gravidade [m/s^2]
l   = 2;      % comprimento do pêndulo [m]
m1  = 1;      % massa do carro [kg]
m2  = 0.2;    % massa do pêndulo [kg]
b1  = 0.6;    % fator de atrito do carro [kg/s]
b2  = 0.1;    % fator de atrito do pêndulo [kgm/s]
sat = 10;     % nível de saturação do controle [N]
T = 0.001;    % período de amostragem do controle [s]

%% Utilize este espaço para projetar o seu controle

syms x1 x2 x3 x4 u
global K r

%% Questão 2
M = [m1+m2 m2*l*cos(x3);m2*l*cos(x3) m2*l];
C = [b1 -m2*l*sin(x3)*x4;0 b2];
G = [0;m2*g*l*sin(x3)];
F = [u; 0];

% x = [z; z_dot; tetha; tetha_dot];

resp = inv(M)*F - inv(M)*C*[x2;x4] - inv(M)*G;
x2_dot = resp(1);
x4_dot = resp(2);

x_dot = [x2;x2_dot;x4;x4_dot];
%x_dot = f(x, u)

%% Questão 3

%0 = f(x_barra, u_barra)
x_barra = [0;0;pi;0];
u_barra =0;

x1_eq = x_barra(1);
x2_eq = x_barra(2);
x3_eq = x_barra(3);
x4_eq = x_barra(4);
u_eq = u_barra(1);

M = [m1+m2 m2*l*cos(x3_eq);m2*l*cos(x3_eq) m2*l];
C = [b1 -m2*l*sin(x3_eq)*x4_eq;0 b2];
G = [0;m2*g*l*sin(x3_eq)];
F = [u_eq; 0];

resp_eq = inv(M)*F - inv(M)*C*[x2_eq;x4_eq] - inv(M)*G;

for i = 1:size(resp_eq) 
    if resp_eq(i) < 10^-20
        resp_eq(i) = 0;
    end
    if resp_eq(i) < -1*10^-20
        resp_eq(i) = 0;
    end
end
x2_dot_eq = resp_eq(1);
x4_dot_eq = resp_eq(2);

%x_dot = f(x, u)

x_dot_eq = [x2_eq;x2_dot_eq;x4_eq;x4_dot_eq];

if x_dot_eq == 0 
    fprintf('x_barra = [ %.4f \n            %.4f \n            %.4f \n            %.4f ]\nu_barra = %.4f \n', x_barra(1), x_barra(2), x_barra(3), x_barra(4), u_barra(1))
    disp('x_barra é um ponto de Equilbrio')
end
%% Questão 4

x(1) = x1;
x(2) = x2;
x(3) = x3;
x(4) = x4;

%A:
%Derivada:
%diff(x_dot,x2)

%Derivada + Substituição
for i = 1:4
    A(1:4,i) = subs(diff(x_dot,x(i)),{x1 x2 x3 x4 u},{x_barra(1) x_barra(2) x_barra(3) x_barra(4) u_barra});
end
%B:
%diff(x_dot,u)
B = subs(diff(x_dot,u),{x1 x2 x3 x4 u},{x_barra(1) x_barra(2) x_barra(3) x_barra(4) u_barra});

%% Questão 5

for i = 1:4;
    dif_x(i) = x(i) - x_barra(i);
end
dif_u = u - u_barra;

%Malha Aberta:
%Sistema_Linearizado = 0 + A*dif_x + B*dif_u;

%Malha Fechada:
%Sistema_Linearizado = 0 + A*dif_x + B*(-K*dif_x);
%Sistema_Linearizado = (A-B*K)*dif_x;

%Autovalores c/ parte real neg., s/parte imag.
%Quanto mais negativo mais rápida a resposta
ta = 4;
%av = autovalores
av = [0;3.550429689801335;-4.179623179432992; -0.495806510368343];

A = [ 0,    1,        0,    0
 0, -3/4,  981/200, -1/8
 0,    0,        0,    1
 0, -3/4, 2943/200, -3/8];

B = [   0
 5/4
   0
 5/4]; 

%Polos em torno da região -(8/ta)
p = -(4/ta)*[1 1.1 1.2 1.3];
K = place(A,B,p); 