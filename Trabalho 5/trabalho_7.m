%% Informações de Entrada
% Medição atual dos sensores: y(k)
% Sinal de controle prévio: u(k?1)
% Estimativa prévia dos estados: x_chapeu(k?1,k?1)
% Covariâncias das estimativas prévias: P(k?1,k?1)
% Modelo não-linear atual do sistema: fk(x(k?1), u(k?1)), h(k,x(k))
% Covariâncias atuais do sistema: Q(k),R(k)

%% Etapa de Predição
%1: x_chapeuk|k?1 = fk(xk?1|k?1, uk?1)
%2: Pk|k?1 = Ak(xk?1|k?1, uk?1) Pk?1|k?1 Ak(xk?1|k?1, uk?1)T + Qk

x_chapeu(k,k-1) = fk(x(k-1,k-1), u(k-1));
P(k,k-1) = Ak(x(k-1,k-1), u(k-1)) * P(k-1,k-1) * Ak(x(k-1,k-1), u(k-1))^T + Q(k);

%% Etapa de Correção
% 1: Sk = Ck(x_chapeu(k|k?1)) * P(k|k?1) * Ck(x_chapeu(k|k?1))^T + R(k)
% 2: Lk = P(k|k?1) * Ck(x_chapeu(k|k?1))^T * S(k)^?1
% 3: y_chapeu(k|k?1) = hk(x_chapeu k|k?1)
% 4: x_chapeu(k|k) = x_chapeu(k|k?1) + Lk(yk ? y_chapeu(k|k?1))
% 5: P(k|k) = P(k|k?1) ? L(k) * C(k) * (x_chapeu(k|k?1)) * P(k|k?1)

Sk = Ck(x_chapeu(k,k-1)) * P(k,k-1) * Ck(x_chapeu(k,k-1))^T + R(k);
Lk = P(k,k-1) * Ck(x_chapeu(k,k-1))^T * S(k)^-1;
y_chapeu(k,k-1) = hk(x_chapeu (k,k-1));
x_chapeu(k,k) = x_chapeu(k|k-1) + Lk(yk - y_chapeu(k,k-1));
P(k,k) = P(k,k-1) - L(k) * C(k) * (x_chapeu(k,k-1)) * P(k,k-1);

%% Informações de Saída
% Estimativa atualizada dos estados: x_chapeu(k,k)
% Covariâncias das estimativas atualizadas: P(k,k)

%% Tarefas
y(k) = [z(k); tetha(k)] + v(k);
R = [10^-4 0; 0 10^-4];
x_dot = 

