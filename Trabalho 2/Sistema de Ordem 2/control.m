function u = control( t , y , r , T )

% Variáveis de Entrada do Controlador -------------------------------------

    % t -> tempo de execução da simulação [s]
    % y -> sinal de saída medido na amostra atual
    % r -> sinal de referência para a saída atual
    % T -> período de amostragem do sistema [s]

% Variáveis de Saída do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta

% Programe sua lógica de controle aqui ------------------------------------
    
%     u=0;
%     
%     % Exempo de degrau em malha-aberta para identificação: 
%     
%     if t >= 1
%        u = 1;
%     else
%        u = 0;
%     end
%     
%% Trabalho 2
    
    persistent ui rf ri e
    if t == 0
        ui(1:3) = 0;
        rf(1:3) = 0;
        e(1:3) = 0;
        ri(1:3) = r;
    end    
    
%     ri(1) = r;
%     rf(1) = 1.94*rf(2) - 0.9418*rf(3) + 0.000709*ri(2) + 0.000709*ri(3);
%     e(1) = rf(1) - y;
%     ui(1) = 1.779*ui(2) - 0.7788*ui(3) + 43.19*e(1) - 84.06*e(2) + 40.93*e(3);
    
    ui(3) = ui(2);
    rf(3) = rf(2);
    e(3) = e(2);
    ri(3) = ri(2);

    ui(2) = ui(1);
    rf(2) = rf(1);
    e(2) = e(1);
    ri(2) = ri(1);

    u = ui(1);
        
        %% Exemplo de controle em malha-fechada proporcional:
    
%     Kp = 1;
%     
%     e = r-y;
%     u = -Kp*e;

    % Exemplo de controle em malha-fechada PID:
    
%     persistent ui ed
%     if t == 0
%        ui = 0;
%        ed = 0;
%     end
%     
%     Kp = 1;
%     Ki = 1;
%     Kd = 1;
%     
%     e  = r-y;
%     ed = e; 
% 
%     up = Kp*e;
%     ui = ui + Ki*T*e;
%     ud = Kd*(e-ed)/T;
%     
%     u  = up+ui+ud;
    
end

