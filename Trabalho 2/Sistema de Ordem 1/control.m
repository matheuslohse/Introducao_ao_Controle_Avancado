function u = control( t , y , r , T )

% Vari�veis de Entrada do Controlador -------------------------------------

    % t -> tempo de execu��o da simula��o [s]
    % y -> sinal de sa�da medido na amostra atual
    % r -> sinal de refer�ncia para a sa�da atual
    % T -> per�odo de amostragem do sistema [s]

% Vari�veis de Sa�da do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta

% Programe sua l�gica de controle aqui ------------------------------------
    
%     u=0;

    % Exempo de degrau em malha-aberta para identifica��o: 
    
    if t >= 1
       u = 1;
    else
       u = 0;
    end

    
%% Trabalho 2

    persistent ui rf e ri
    if t == 0
        ui(1:2) = 0;
        rf(1:2) = 0;
        e(1:2) = 0;
        ri = r;
    end
    
    rf(1) = 0.9418*rf(2) + 0.05824*ri; 
    e(1) = rf(1) - y;
    ui(1) = ui(2) + 3*e(1) - 2.82*e(2);
    
    rf(2) = rf(1);
    e(2) = e(1); 
    ui(2) = ui(1);
    ri = r;
    
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

