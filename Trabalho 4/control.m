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
    
    for i = 1:N
    ri(1) = r;
    
        %Antigo
    %     rf(1) = - denF(1)*rf(2) + numF(1)*ri(1) + numF(2)*ri(2);
    %     e(1) = ri(1) - y;
    %     ui(1) = ui(2) + 0.003*e(1);

        %Novo

        rf(N-1) = - denF(N-2)*rf(N-2) + denF(N-3)*rf(N-3) + numF(N-3)*ri(N-3);
        e(N-1) = ri(N-1) - y;
        ui(N-1) =  denC(N-1)/numC(N-1)*e(N-1) - denC(N-2)/numC(N-1)*e(N-2) + denC(N-3)/numC(N-1)*e(N-3) + numC(N-2)/numC(N-1)*u(N-2) - numC(N-3)/numC(N-1)*u(N-3);

    %     %ui(1) = - denC(2)*ui(2) - denC(3)*ui(3) + numC(1)*e(1) + numC(2)*e(2) + numC(3)*e(3);

        ui(i) = ui(i-1);
        rf(i) = rf(i-1);
        e(i) = e(i-1);
        ri(i) = ri(i-1);

    end
    
    u = ui(N-1);
    
end
