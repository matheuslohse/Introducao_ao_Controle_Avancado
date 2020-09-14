function u = control( t , y , r , T )

% Variáveis de Entrada do Controlador -------------------------------------

    % t -> tempo de execução da simulação [s]
    % y -> sinal de saída medido na amostra atual
    % r -> sinal de referência para a saída atual
    % T -> período de amostragem do sistema [s]

% Variáveis de Saída do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta

% Programe sua lógica de controle aqui ------------------------------------
%     if t >= 1
%        u = 1;
%     else
%        u = 0;
%     end
%    
%%Trabalho 2
    persistent e ui rf ri k
       
    if t == 0
       ri(1:4) = 0; 
       rf(1:4) = 0;
       ui(1:4) = 0;
       e(1:4) = 0;
    end
    
    ri(1) = r;
    rf(1) = 0.003402*ri(2)+0.003265*ri(3)+1.877*rf(2)-0.8834*rf(3);
    %e = r - y;
    e(1) = rf(1)-y;
    ui(1) = 1.988*ui(2) - 1.29*ui(3) + 0.3012*ui(4) + 1205*e(1) - 3279*e(2) + 2952*e(3) - 877.32*e(4); 
    
    for R = 2:4
       ri(R) = ri(R-1); 
       rf(R) = rf(R-1);
       ui(R) = ui(R-1);
       e(R) = e(R-1);
    end
    if ui(1) == 0
        u = 1;
    else
        u = ui(1);
    end
end

