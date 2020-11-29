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
x_barra = [0;0;pi;0];
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



