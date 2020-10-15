function u = control( t , y , r , T )

% Variáveis de Entrada do Controlador -------------------------------------

    % t -> tempo de execução da simulação [s]
    % y -> sinal de saída medido na amostra atual
    % r -> sinal de referência para a saída atual
    % T -> período de amostragem do sistema [s]

% Variáveis de Saída do Controlador ---------------------------------------

    % u -> sinal de controle a ser entregue a planta

% Programe sua lógica de controle aqui ------------------------------------
    
global Cz Fz delay Gz smith

    persistent ud ed rd rfd ypd upd
    
    N = round(delay/T);
    if t==0
       ud  = zeros(N,1);
       ed  = [0 0];
       rd  = [0 0];
       rfd = [0 0];
       ypd = [0 0 0];
       upd = [0 0 0];
    end 

    a = Cz.num{1};
    b = Cz.den{1};
    
    c = Fz.num{1};
    d = Fz.den{1};
    
    f = Gz.num{1};
    g = Gz.den{1};
    
    % Smith Predictor  ----------------------------------------    
    
    if smith
        up = ud(1) - ud(N); 
        yp = f(1)*up + f(2)*upd(1) + f(3)*upd(2) + f(4)*upd(3)  - g(2)*ypd(1) - g(3)*ypd(2) - g(4)*ypd(3);
    else 
        up = 0; 
        yp = 0; 
    end
    
    % ----------------------------------------------------------
    
    rf = c(1)*r + c(2)*rd(1) + c(3)*rd(2) - d(2)*rfd(1) - d(3)*rfd(2);
    
    e = rf-y-yp;
        
    u = a(1)*e + a(2)*ed(1) + a(3)*ed(2) - b(2)*ud(1) - b(3)*ud(2);
    
    for k=N:-1:2
        ud(k) = ud(k-1);
    end
    ud(1) = u;
    
    ed(2) = ed(1);
    ed(1) = e;
    
    rd(2) = rd(1);
    rd(1) = r;
     
    rfd(2) = rfd(1);
    rfd(1) = rf;
    
    upd(3) = upd(2);
    upd(2) = upd(1);
    upd(1) = up;
    
    ypd(3) = ypd(2);
    ypd(2) = ypd(1);
    ypd(1) = yp;

    % Exempo de degrau em malha-aberta para identificação: 
    
%     if t >= 5
%        u = 1;
%     else
%        u = 0;
%     end
    
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
    
end

