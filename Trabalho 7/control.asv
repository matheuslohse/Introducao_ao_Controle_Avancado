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
syms x1 x2 x3 x4 u
global Q R
global g l m1 m2 b1 b2 sat T 
persistent x_chapeu P ua x_barra

g   = 9.81;   % aceleração da gravidade [m/s^2]
l   = 2;      % comprimento do pêndulo [m]
rho = 1;      % Rho é uma constante que demonstra que a força influencia diretamente na aceleração do carrinho.
u_max = 9;   % Força maxima em [N]
kp = 1;
ks = 10;


%% Parte do Provenienete do Trabalho 7
u_barra = 0;

M_d = [m1+m2 m2*l*cos(x3);m2*l*cos(x3) m2*l^2];
C_d = [b1 -m2*l*sin(x3)*x4;0 b2];
G_d = [0;m2*g*l*sin(x3)];
F_d = [ua; 0];

resp = M_d\(F_d - C_d*[x2;x4] - G_d);

x2_dot = resp(1);
x4_dot = resp(2);

%x_dot = [x2;x2_dot;x4;x4_dot];
fc = [x2;x2_dot;x4;x4_dot];

x_design(1) = x1;
x_design(2) = x2;
x_design(3) = x3;
x_design(4) = x4;

%% EXTENDEND KALMAN FILTER
if t == 0 
    x_chapeu = [y(1); 0; y(2); 0]
    P = [R(1) 0 0 0; 0 1e-8 0 0; 0 0 R(2) 0; 0 0 0 1e-8];
    ua = 0;
    x_barra = [r;0;pi;0];
else
    %% Etapa de Predição
    fk = T * fc + x_chapeu;
    %x_chapeu  -> x_chapeu k-1|k-1
    x_chapeu = fk;
    %x_chapeu  -> x_chapeu k|k-1
    
    %Calculo do A e B - Importada e  Adaptada da Design
    %Derivada + Substituição
    
    Ac = zeros(4);
    
    for i = 1:4
        Ac(1:4,i) = subs(diff(x_chapeu,x_design(i)),{x1 x2 x3 x4 u},{x_barra(1) x_barra(2) x_barra(3) x_barra(4) u_barra});
    end
       
    A = eye(4) + T * Ac;
    C = [1 0 1 0];
    
    %Cálculo do P
    P = A * P * A' + Q;

    %% Etapa de Correção
   
    S = C * P/2 * C' + R;
    L = (P*C')\S; % / OU \ ?
    x_chapeu = x_chapeu + L * (y - C*x_chapeu);       %y_chapeu(k,k-1));
    P = P - L*C*P;

end


%% Contol Escobal

if x_chapeu(3) >= 0 
    x_barra = [r;0;pi;0];
    %u_barra = 0;
end

if x_chapeu(3) < 0 
    x_barra = [r;0;-pi;0];
    %u_barra = 0;
end

dif_x = x_chapeu - x_barra;
%dif_u = u - u_barra;

if cos(x_chapeu(3)) <= -0.94    
      u = -K*dif_x; %seria dif_u no entanto u_barra = 0
else 
      E = (1/2)*m2*(l^2)*x_chapeu(4)^2 + m2*g*l*(1 - cos(x_chapeu(3)));
      
      Ed = 2*m2*g*l;
      
      dE = E - Ed;
      
      u =  u_max * sign(dE * ks * x_chapeu(4) * rho * cos(x_chapeu(3))) - kp*x_chapeu(1)
end
    

ua = u;

end

