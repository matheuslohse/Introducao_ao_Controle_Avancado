function [ r ] = setpoint( t )

% Esta fun��o � respons�vel por definir o sinal de refer�ncia a ser
% enviado para o sistema de controle.

% Programe aqui a defini��o de "r"

    r = 0;

    % Exemplo: Refer�ncia do tipo degrau

%     if t >= 1
%        r = 1;
%     else
%        r = 0;
%     end

    % Exemplo: Refer�ncia do tipo senoidal
    
%     per = 1; % per�do da onda [s]
%     
%     w = 2*pi/per;
%     
%     r = sin( w*t );
    
    

end

