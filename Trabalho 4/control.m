function u = control( t , y , r , T )

% Variáveis de Entrada do Controlador -------------------------------------

    % t -> tempo de execução da simulação [s]
    % y -> sinal de saída medido na amostra atual
    % r -> sinal de referência para a saída atual
    % T -> período de amostragem do sistema [s]

% Variáveis de Saída do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta
    u = 1;
% Programe sua lógica de controle aqui ------------------------------------
    %% Blocão
    global Fz Cz Pz Hz
    persistent ui rf e ri ec
    N = 57;
        if t == 0
            ui(1:N) = 0;
            rf(1:3) = 0;
            e(1:N) = 0;
            ri(1:3) = r;
        end
    
    %Vetores da Fz e Cz
    numF = Fz.num{1};
    denF = Fz.den{1};
    
    CP_E = (Cz)/(1+Cz*Pz);
    CP = tf(CP_E);  
    numCP = CP.num{1};
    denCP = CP.den{1};
    
    ri(1) = r;

    rf(1) = - denF(2)*rf(2) - denF(3)*rf(3) + numF(3)*ri(3);
    e(1) = rf(1) - y;
    
    soma_e = numCP(1)*e(1);
    soma_ui = denCP(1)*ui(1);
    
    for i = 2:N 
       soma_e = numCP(i)*e(i) + soma_e;
       soma_ui = denCP(i)*ui(i) + soma_ui;
       e(i+1) = e(i);
       ui(i+1) = ui(i);
    end
    
    for i = 1:3
        rf(i+1) = rf(i);
        ri(i+1) = ri(i);
    end
    
    ui(1) =  soma_e - soma_ui;
    u = ui(1);
    
    %% Muitas Equacoes
    
%     global Fz Cz Pz Hz
%     persistent ui rf e ri ec p
%     
%     N = 500;
%     if t == 0
%         ui(1:N) = 0;
%         rf(1:3) = 0;
%         e(1:N) = 0;
%         ec(1:N) = 0;
%         ri(1:3) = r;
%         p(1:N) = 0;
%     end
% 
%     Pz_tf = tf(Pz);
%     
%     numF = Fz.num{1};
%     denF = Fz.den{1};
%     
%     numPz = Pz_tf.num{1};
%     denPz = Pz_tf.den{1};
%     
%     numC = Cz.num{1};
%     denC = Cz.den{1};
%     
%     for j = 1:N
%         rf(1) = - denF(2)*rf(2) - denF(3)*rf(3) + numF(3)*ri(3);
%         e(1) = rf(1) - y;
%         ec(1) = e(1) - p(2);
%         ui(1) = numC(1)*ec(1) + numC(2)*ec(2) + numC(3)*ec(3) - (denC(2)*ui(2) +denC(3)*ui(3));
%         tamanho_for = size(denPz);
%         somaNumPz = numPz(1)*u(1);
%         somaDemPz = 0;
% 
%         for i = 2:tamanho_for
%             somaNumPz = numPz(i)*u(i) + somaNumPz;
%             somaDemPz = demPz(i)*p(i) + somaDemPz;
%         end
%         
%         p(1) = somaNumPz - somaDemPz;
%         
%         ui(j+1) = ui(j);
%         e(j+1) = e(j);
%         ec(j+1) = ec(j);
%         p(j+1) = p(j);
%         
%     end
%     
%     for i = 1:3
%         rf(i+1) = rf(i);
%         ri(i+1) = ri(i);
%     end
%     
%     u = ui(1)
end

