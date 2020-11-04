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
global K L

g   = 9.81;   % aceleração da gravidade [m/s^2]
l   = 2;      % comprimento do pêndulo [m]
m  = 0.2;     % massa do pêndulo [kg]
rho = 1;      % Rho é uma constante que demonstra que a força influencia diretamente na aceleração do carrinho.
u_max = 6;   % Força maxima em [N]
kp = 1;

if x(3) >= 0 
    x_barra = [r;0;pi;0];
    %u_barra = 0;
end

if x(3) < 0 
    x_barra = [r;0;-pi;0];
    %u_barra = 0;
end

dif_x = x - x_barra;
%dif_u = u - u_barra;

if cos(x(3)) <= -0.94    
      u = -K*dif_x; %seria dif_u no entanto u_barra = 0
else 
      E = (1/2)*m*(l^2)*x(4)^2 + m*g*l*(1 - cos(x(3)));
      
      Ed = 2*m*g*l;
      
      dE = E - Ed;
      
      u =  u_max * sign(dE * x(4) * rho * cos(x(3))) - kp*x(1)
end
    
%Malha Aberta:
%Sistema_Linearizado = 0 + A*dif_x + B*dif_u;

%Malha Fechada:
%Sistema_Linearizado = 0 + A*dif_x + B*(-K*dif_x);
%Sistema_Linearizado = (A-B*K)*dif_x;


end

