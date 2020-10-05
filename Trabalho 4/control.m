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
    N = 110;
        if t == 0
            ui(1:N) = 0;
            rf(1:N) = 0;
            e(1:N) = 0;
            ri(1:N) = r;
        end
    
    %Vetores da Fz e Cz
    numF = Fz.num{1};
    denF = Fz.den{1};
    
    CP = (Cz*Pz)/(1+Cz*Pz);
    CPz = tf(CP);
    numCP = CPz.num{1};
    denCP = CPz.den{1};
    
    ri(1) = r;

    rf(1) = - denF(2)*rf(2) - denF(3)*rf(3) + numF(3)*rf(3);
    e(1) = ri(1) - y;
    
    soma_e = numCP(1)*e(1);
    soma_ui = denCP(1)*ui(1);
    
    for i = 2: N
       soma_e = numCP(i)*e(i) + soma_e;
       soma_ui = denCP(i)*ui(i) + soma_ui;
       
        e(i) = e(i-1);
        ui(i) = ui(i-1);
        rf(i) = rf(i-1);
        ri(i) = ri(i-1);
    end
    
    ui(1) =  soma_e - soma_ui;
    u = ui(1);
    
end

