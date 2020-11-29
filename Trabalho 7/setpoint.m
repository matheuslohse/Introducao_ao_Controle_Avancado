function [ r ] = setpoint( t )

% t -> tempo atual da simulação [s]
% r -> sinal de referência para o controle

%% Programe aqui a definição de "r" em função de "t"

    if t < 10
       r = 0;
    elseif t < 20
       r = -2;
    else
       r = 2;
    end

end

