function u = control( t , y , r , T )

% Vari�veis de Entrada do Controlador -------------------------------------

    % t -> tempo de execu��o da simula��o [s]
    % y -> sinal de sa�da medido na amostra atual
    % r -> sinal de refer�ncia para a sa�da atual
    % T -> per�odo de amostragem do sistema [s]

% Vari�veis de Sa�da do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta
    u = 1;
% Programe sua l�gica de controle aqui ------------------------------------
    
    global Fz Cz Pz Hz
    persistent ui rf e ri
    N = 500;
        if t == 0
            ui(1:N) = 0;
            rf(1:N) = 0;
            e(1:N) = 0;
            ri(1:N) = r;
        end
    
    %Vetores da Fz e Cz
    numF = Fz.num{1};
    denF = Fz.den{1};
    
    numC = Cz.num{1};
    denC = Cz.den{1};
	   
    numH = Hz.num{1};
    denH = Hz.den{1};
    
    ri(1) = r;
    for i = 1:N

    %Antigo
%     rf(1) = - denF(1)*rf(2) + numF(1)*ri(1) + numF(2)*ri(2);
%     e(1) = ri(1) - y;
%     ui(1) = ui(2) + 0.003*e(1);
     
    %Novo
     
    rf(1) = - denF(2)*rf(2) + denF(3)*rf(3) + numF(3)*ri(3);
    e(1) = ri(1) - y;
    ui(1) =  denC(1)/numC(1)*e(1) - denC(2)/numC(1)*e(2) + denC(3)/numC(1)*e(3) + numC(2)/numC(1)*u(2) - numC(3)/numC(1)*u(3);
      
%     %ui(1) = - denC(2)*ui(2) - denC(3)*ui(3) + numC(1)*e(1) + numC(2)*e(2) + numC(3)*e(3);
% 
    
        ui(N) = ui(N-1);
        rf(N) = rf(N-1);
        e(N) = e(N-1);
        ri(N) = ri(N-1);
    end
    
    u = ui(1);
    
end

