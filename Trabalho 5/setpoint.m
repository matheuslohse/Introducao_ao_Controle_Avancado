function [ r ] = setpoint( t )

% t -> tempo atual da simula��o [s]
% r -> sinal de refer�ncia para o controle

%% Programe aqui a defini��o de "r" em fun��o de "t"

    if t < 10
       r = 0;
    elseif t < 20
       r = -2;
    else
       r = 2;
    end

end

