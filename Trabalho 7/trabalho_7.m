%% EXTENDEND KALMAN FILTER

syms x1 x2 x3 x4 u
global C Q R
global g l m1 m2 b1 b2 sat T
persistent x_chapeu P ua

%% Parte que vai para a Design
alpha = 1e-6;%? � um escalar positivo pequeno, preferencialmente menor que 1
I = eye(4);%I � uma matriz identidade 4 por 4.
Q = alpha * I;
R = [10^-4 0; 0 10^-4];

%y(k) = [z(k); tetha(k)] + v(k); %zk e ?k representam respectivamente a posi��o real do carrinho e o �ngulo real da haste em cada amostra k de controle
%% Parte do Provenienete da Design

M = [m1+m2 m2*l*cos(x3);m2*l*cos(x3) m2*l^2];
C = [b1 -m2*l*sin(x3)*x4;0 b2];
G = [0;m2*g*l*sin(x3)];
F = [u; 0];

% x = [z; z_dot; tetha; tetha_dot];

%Resp Velha:
%resp = inv(M)*F - inv(M)*C*[x2;x4] - inv(M)*G;
%Resp Nova:
resp = M\(F - C*[x2;x4] - G);

x2_dot = resp(1);
x4_dot = resp(2);

x_dot = [x2;x2_dot;x4;x4_dot];


%fc = 

%% Declarando Vari�veis
%x_dot = fc(x,u); -> fc = fun��o cont�nua do sistema
%fk(x(k-1),u(k-1)) = T * fc(x(k-1),u(k-1)) + x(k-1);

fk = T * fc + x_chapeu;

%% Informa��es de Entrada
% Medi��o atual dos sensores: y(k)
% Sinal de controle pr�vio: u(k?1)
% Estimativa pr�via dos estados: x_chapeu(k?1,k?1)
% Covari�ncias das estimativas pr�vias: P(k?1,k?1)
% Modelo n�o-linear atual do sistema: fk(x(k?1), u(k?1)), h(k,x(k))
% Covari�ncias atuais do sistema: Q(k),R(k)

if t == 0 
    x_chapeu = [y(1) 0 y(2) 0];
    %P = [* 0;0 **] -> *Covari�ncia da Posi��o do �ngulo -> Conhecido e Definido = R 
    %P = [* 0;0 **] -> **Convari�ncia da Velocidade do �ngulo ->
    %Desconhecido em sistemas reais, aqui sabemos que vai come�ar parado
    P = [R(1) 0; 0 1e-8];
    ua = 0;
else
    %% Etapa de Predi��o
    %1: x_chapeuk|k-1 = fk(xk?1|k?1, uk?1)
    %2: Pk|k?1 = Ak(xk?1|k?1, uk?1) Pk?1|k?1 Ak(xk?1|k?1, uk?1)T + Qk

    Ac = [0,                                1,                                                                                                                                                                                                                                             0,                                                   0
    0,                3/(cos(x_chapeu(3))^2 - 6),                               - (200*x_chapeu(4)^2*cos(x_chapeu(3)) + 981*cos(x_chapeu(3))^2 - 981*sin(x_chapeu(3))^2 - 25*x_chapeu(4)*sin(x_chapeu(3)))/(100*(cos(x_chapeu(3))^2 - 6)) - (cos(x_chapeu(3))*sin(x_chapeu(3))*(200*sin(x_chapeu(3))*x_chapeu(4)^2 + 25*cos(x_chapeu(3))*x_chapeu(4) + 500*u - 300*x_chapeu(2) + 981*cos(x_chapeu(3))*sin(x_chapeu(3))))/(50*(cos(x_chapeu(3))^2 - 6)^2), -(25*cos(x_chapeu(3)) + 400*x_chapeu(4)*sin(x_chapeu(3)))/(100*(cos(x_chapeu(3))^2 - 6))
    0,                                0,                                                                                                                                                                                                                                             0,                                                    1
    0, -(3*cos(x_chapeu(3)))/(2*(cos(x_chapeu(3))^2 - 6)), (2943*cos(x_chapeu(3)) + 100*x_chapeu(4)^2*cos(x_chapeu(3))^2 - 100*x_chapeu(4)^2*sin(x_chapeu(3))^2 - 250*u*sin(x_chapeu(3)) + 150*x_chapeu(2)*sin(x_chapeu(3)))/(100*(cos(x_chapeu(3))^2 - 6)) + (cos(x_chapeu(3))*sin(x_chapeu(3))*(100*cos(x_chapeu(3))*sin(x_chapeu(3))*x_chapeu(4)^2 + 75*x_chapeu(4) + 2943*sin(x_chapeu(3)) + 250*u*cos(x_chapeu(3)) - 150*x_chapeu(2)*cos(x_chapeu(3))))/(50*(cos(x_chapeu(3))^2 - 6)^2),  (200*x_chapeu(4)*cos(x_chapeu(3))*sin(x_chapeu(3)) + 75)/(100*(cos(x_chapeu(3))^2 - 6))]


    
    
    %x_chapeu  -> x_chapeu k-1|k-1
    x_chapeu = fk;
    %x_chapeu  -> x_chapeu k|k-1
    
    %Calculo do A e B - Importada e  Adaptada da Design
    %Derivada + Substitui��o
       
    A = eye(4) + T * Ac;
    C = Cc;
    
    %C�lculo do P
    P = A * P * A' + Q;

    %% Etapa de Corre��o
    % 1: Sk = Ck(x_chapeu(k|k?1)) * P(k|k?1) * Ck(x_chapeu(k|k?1))^T + R(k)
    % 2: Lk = P(k|k?1) * Ck(x_chapeu(k|k?1))^T * S(k)^?1
    % 3: y_chapeu(k|k?1) = hk(x_chapeu k|k?1)
    % 4: x_chapeu(k|k) = x_chapeu(k|k?1) + Lk(yk ? y_chapeu(k|k?1))
    % 5: P(k|k) = P(k|k?1) ? L(k) * C(k) * (x_chapeu(k|k?1)) * P(k|k?1)

    S = C * P * C' + R;
    L = (P*C')/S;
    %y_chapeu(k,k-1) = hk(x_chapeu (k,k-1));
    x_chapeu = x_chapeu + L * (y - C*x_chapeu);       %y_chapeu(k,k-1));
    P = P - L*C*P;

    %% Informa��es de Sa�da
    % Estimativa atualizada dos estados: x_chapeu(k,k)
    % Covari�ncias das estimativas atualizadas: P(k,k)

end

ua = u;



