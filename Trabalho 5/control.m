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

u = 0;

end

