function [ r ] = setpoint( t )

% Esta função é responsável por definir o sinal de referência a ser
% enviado para o sistema de controle.

% Programe aqui a definição de "r"
% 
%      r = 0;

    % Exemplo: Referência do tipo degrau

    if t >= 0
       r = 1;
    else
       r = 0;
    end

    % Exemplo: Referência do tipo senoidal
    
%     per = 1; % perído da onda [s]
%     
%     w = 2*pi/per;
%     
%     r = 10*sin( w*t );
%     
    

end

