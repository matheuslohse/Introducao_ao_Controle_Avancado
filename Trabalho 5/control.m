function [ u ] = control( t , y , r , x )
% Variáveis de entrada/saída da função de controle:
%
% t -> tempo atual da simulação [s]
%
% y -> medições atuais dos sensores do sistema:
%      y1 -> posição do carro [m]
%      y2 -> ângulo da haste [rad]
%
% r -> setpoint de referência para posição do carro [m]
%
% x -> estado atual do sistema:
%      x1 -> posição do carro [m]
%      x2 -> velocidade do carro [m/s]
%      x3 -> ângulo da haste [rad]
%      x4 -> rotação da haste [rad/s]
%
% u -> força de controle a ser aplicada no carrinho [N]

%% Utilize este espaço para programar sua lei de controle
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

