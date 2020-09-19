function u = control( t , y , r , T )

% Variáveis de Entrada do Controlador -------------------------------------

    % t -> tempo de execução da simulação [s]
    % y -> sinal de saída medido na amostra atual
    % r -> sinal de referência para a saída atual
    % T -> período de amostragem do sistema [s]

% Variáveis de Saída do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta

% Programe sua lógica de controle aqui ------------------------------------
    
    % u=0;

    % Exempo de degrau em malha-aberta para identificação: 
    
    if t >= 5
       u = 0.4;
    else
       u = 0;
    end
    
    % Exemplo de controle em malha-fechada proporcional:
    
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
global Fz Gz Cz
persistent ui rf e ri
        if t == 0
            ui(1:3) = 0;
            rf(1:2) = 0;
            e(1:3) = 0;
            ri(1:2) = r;
        end
    
    %Vetores da Fz e Cz
    numF = Fz.num{1};
    denF = Fz.den{1};
    numC = Cz.num{1};
    denC = Cz.den{1};
    
    ri(1) = r;
    
    rf(1) = - denF(1)*rf(2) + numF(1)*ri(1) + numF(2)*ri(2);
    e(1) = rf(1) - y;
    ui(1) = - denC(2)*ui(2) - denC(3)*ui(3) + numC(1)*e(1) + numC(2)*e(2) + numC(3)*e(3);

    ui(3) = ui(2);
    e(3) = e(2);

    ui(2) = ui(1);
    rf(2) = rf(1);
    e(2) = e(1);
    ri(2) = ri(1);

    u = ui(1);

end

