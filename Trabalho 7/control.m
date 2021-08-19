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
global Q R
global g l m1 m2 b1 b2 T 
persistent x_chapeu P ua 

g   = 9.81;   % aceleração da gravidade [m/s^2]
l   = 2;      % comprimento do pêndulo [m]
rho = 1;      % Rho é uma constante que demonstra que a força influencia diretamente na aceleração do carrinho.
u_max = 9;   % Força maxima em [N]
kp = 1;
ks = 10;
ta = 5;

%% EXTENDEND KALMAN FILTER
if t == 0 
    x_chapeu = [y(1); 0; y(2); 0];
    P = [R(1,1) 0 0 0; 0 1e-8 0 0; 0 0 R(2,2) 0; 0 0 0 1e-8];
    ua = 0;
else
    %% Etapa de Predição
        % Parte do Provenienete da Design

    M = [m1+m2 m2*l*cos(x_chapeu(3));m2*l*cos(x_chapeu(3)) m2*l^2];
    C = [b1 -m2*l*sin(x_chapeu(3))*x_chapeu(4);0 b2];
    G = [0;m2*g*l*sin(x_chapeu(3))];
    F = [ua; 0];
    resp = M\(F - C*[x_chapeu(2);x_chapeu(4)] - G);

    x2_dot = resp(1);
    x4_dot = resp(2);

    fc = [x_chapeu(2);x2_dot;x_chapeu(4);x4_dot];
    
    fk = T * fc + x_chapeu;
    %x_chapeu  -> x_chapeu k-1|k-1
    x_chapeu = fk;
    %x_chapeu  -> x_chapeu k|k-1
    
    %Calculo do A e B - Importada e  Adaptada da Design
    %Derivada + Substituição
    
    Ac = [0,                                1,                                                                                                                                                                                                                                             0,                                                   0
    0,                3/(cos(x_chapeu(3))^2 - 6),                               - (200*x_chapeu(4)^2*cos(x_chapeu(3)) + 981*cos(x_chapeu(3))^2 - 981*sin(x_chapeu(3))^2 - 25*x_chapeu(4)*sin(x_chapeu(3)))/(100*(cos(x_chapeu(3))^2 - 6)) - (cos(x_chapeu(3))*sin(x_chapeu(3))*(200*sin(x_chapeu(3))*x_chapeu(4)^2 + 25*cos(x_chapeu(3))*x_chapeu(4) + 500*ua - 300*x_chapeu(2) + 981*cos(x_chapeu(3))*sin(x_chapeu(3))))/(50*(cos(x_chapeu(3))^2 - 6)^2), -(25*cos(x_chapeu(3)) + 400*x_chapeu(4)*sin(x_chapeu(3)))/(100*(cos(x_chapeu(3))^2 - 6))
    0,                                0,                                                                                                                                                                                                                                             0,                                                    1
    0, -(3*cos(x_chapeu(3)))/(2*(cos(x_chapeu(3))^2 - 6)), (2943*cos(x_chapeu(3)) + 100*x_chapeu(4)^2*cos(x_chapeu(3))^2 - 100*x_chapeu(4)^2*sin(x_chapeu(3))^2 - 250*ua*sin(x_chapeu(3)) + 150*x_chapeu(2)*sin(x_chapeu(3)))/(100*(cos(x_chapeu(3))^2 - 6)) + (cos(x_chapeu(3))*sin(x_chapeu(3))*(100*cos(x_chapeu(3))*sin(x_chapeu(3))*x_chapeu(4)^2 + 75*x_chapeu(4) + 2943*sin(x_chapeu(3)) + 250*ua*cos(x_chapeu(3)) - 150*x_chapeu(2)*cos(x_chapeu(3))))/(50*(cos(x_chapeu(3))^2 - 6)^2),  (200*x_chapeu(4)*cos(x_chapeu(3))*sin(x_chapeu(3)) + 75)/(100*(cos(x_chapeu(3))^2 - 6))];
    
       
    A = eye(4) + T * Ac;
    C = [1 0 0 0;0 0 1 0];

    %Cálculo do P
    P = A * P * A' + Q;

    %% Etapa de Correção
   
    S = C * P/2 * C' + R;
    L = (P*C')*S^-1; % / OU \ ?
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
      
      u =  u_max * sat(dE * ks * x_chapeu(4) * rho * cos(x_chapeu(3))) - kp*x_chapeu(1);
end
    
if u > 10 
    u = 10;
end

if u < -10
    u = -10;
end

ua = u;

end

