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
global K L

g   = 9.81;   % acelera��o da gravidade [m/s^2]
l   = 2;      % comprimento do p�ndulo [m]
m  = 0.2;     % massa do p�ndulo [kg]
rho = 1;      % Rho � uma constante que demonstra que a for�a influencia diretamente na acelera��o do carrinho.
u_max = 6;   % For�a maxima em [N]
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

