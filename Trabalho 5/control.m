function [ u ] = control( t , y , r , x )
% Vari�veis de entrada/sa�da da fun��o de controle:
%
% t -> tempo atual da simula��o [s]
%
% y -> medi��es atuais dos sensores do sistema:
%      y1 -> posi��o do carro [m]
%      y2 -> �ngulo da haste [rad]
%
% r -> setpoint de refer�ncia para posi��o do carro [m]
%
% x -> estado atual do sistema:
%      x1 -> posi��o do carro [m]
%      x2 -> velocidade do carro [m/s]
%      x3 -> �ngulo da haste [rad]
%      x4 -> rota��o da haste [rad/s]
%
% u -> for�a de controle a ser aplicada no carrinho [N]

%% Utilize este espa�o para programar sua lei de controle
global K

x_barra = [0;0;pi;0];
%u_barra = 0;

dif_x = x - x_barra;
%dif_u = u - u_barra;
u = -K*dif_x; %seria dif_u no entanto u_barra = 0

%Malha Aberta:
%Sistema_Linearizado = 0 + A*dif_x + B*dif_u;

%Malha Fechada:
%Sistema_Linearizado = 0 + A*dif_x + B*(-K*dif_x);
%Sistema_Linearizado = (A-B*K)*dif_x;


end

