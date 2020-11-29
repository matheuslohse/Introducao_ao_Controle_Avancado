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
syms x1 x2 x3 x4 u
global C Q R
global g l m1 m2 b1 b2 sat T 
persistent x_chapeu P ua

g   = 9.81;   % acelera��o da gravidade [m/s^2]
l   = 2;      % comprimento do p�ndulo [m]
rho = 1;      % Rho � uma constante que demonstra que a for�a influencia diretamente na acelera��o do carrinho.
u_max = 9;   % For�a maxima em [N]
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

%% EXTENDEND KALMAN FILTER
if t == 0 
    x_chapeu = [y(1) 0 y(2) 0];
    P = [R(1) 0; 0 1e-8];
    ua = 0;
else
    %% Etapa de Predi��o
    fk = T * fc + x_chapeu;
    %x_chapeu  -> x_chapeu k-1|k-1
    x_chapeu = fk;
    %x_chapeu  -> x_chapeu k|k-1
    
    %Calculo do A e B - Importada e  Adaptada da Design
    %Derivada + Substitui��o
    for i = 1:4
        Ac(1:4,i) = subs(diff(x_chapeu,x(i)),{x1 x2 x3 x4 u},{x_barra(1) x_barra(2) x_barra(3) x_barra(4) u_barra});
    end
       
    A = eye(4) + T * Ac;
    C = Cc;
    
    %C�lculo do P
    P = A * P * A' + Q;

    %% Etapa de Corre��o
   
    S = C * P * C' + R;
    L = (P*C')/S;
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
      
      u =  u_max * sat(dE * ks * x_chapeu(4) * rho * cos(x_chapeu(3))) - kp*x_chapeu(1)
end
    

ua = u;

end
