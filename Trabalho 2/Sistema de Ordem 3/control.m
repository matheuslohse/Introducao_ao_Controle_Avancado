function u = control( t , y , r , T )

% Vari�veis de Entrada do Controlador -------------------------------------

    % t -> tempo de execu��o da simula��o [s]
    % y -> sinal de sa�da medido na amostra atual
    % r -> sinal de refer�ncia para a sa�da atual
    % T -> per�odo de amostragem do sistema [s]

% Vari�veis de Sa�da do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta

% Programe sua l�gica de controle aqui ------------------------------------
%     if t >= 1
%        u = 1;
%     else
%        u = 0;
%     end
%    

%%Trabalho 2

    persistent e ui rf ri
       
    if t == 0
       ri(1:4) = 0; 
       rf(1:4) = 0;
       ui(1:4) = 0;
       e(1:4) = 0;
    end
    
    ri(1) = r;
    
%     rf(1) = 0.003402*ri(2) + 0.003265*ri(3) + 1.877*rf(2) - 0.8834*rf(3);
    e(1) = r - y;
    ui(1) = 1.988*ui(2) - 1.29*ui(3) + 0.3012*ui(4) + 1205*e(1) - 3279*e(2) + 2952*e(3) - 877.3*e(4); 
    
%     rf(1) = 0.00036119*ri(4) + 2.829*rf(2) - 2.67098*rf(3) + 0.841617*rf(4);
%     e(1) = rf(1) - y;
%     ui(1) = 1.9394*ui(2) - 1.2723*ui(3) - 0.3329*ui(4) + 948,6*e(1) - 2683.59*e(2) + 2533.69*e(3) - 798.358*e(4); 

       ri(4) = ri(3); 
       rf(4) = rf(3);
       ui(4) = ui(3);
       e(4) = e(3);
       
       ri(3) = ri(2); 
       rf(3) = rf(2);
       ui(3) = ui(2);
       e(3) = e(2);
    
       ri(2) = ri(1); 
       rf(2) = rf(1);
       ui(2) = ui(1);
       e(2) = e(1);
       
       u = ui(1);

end

