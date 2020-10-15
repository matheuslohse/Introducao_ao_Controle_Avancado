function [t,y,yn,u,r,d] = runsim( ttotal , T , Ts )
% Esta fun��o realiza a simula��o de sistemas de conrtole

% Carrega o sistema
[A,B,C,D,E,delay,umin,umax,id] = sysdata();

n = size(A,1);
m = size(C,1);

% N�mero de amostras da simula��o
Ns = round(ttotal/Ts);

% N�mero de amostras do log do controle
N = round(ttotal/T);

% N�mero de amostras de atraso na simula��o
Nd = round(delay/Ts);

% Pr�-aloca��es
u = zeros(1,N);
r = zeros(1,N);
d = zeros(1,N);
yc = zeros(1,N);
yn = zeros(1,N);
t = T*(0:(N-1));
k = 0;

us = zeros(1,Ns);
rs = zeros(1,Ns);
ds = zeros(1,Ns);
ys = zeros(1,Ns);
xs = zeros(n,Ns);

% Loop de Simula��o

ts = Ts*(0:(Ns-1));
   
disp('Efetuando a simula��o...')
for i=1:Ns
   
   % Simula��o dos Dist�rbios  
   ds(:,i) = distdata(ts(i));
           
   % Simula��o do Sistema de Controle
   
   if rem( ts(i) , T ) == 0       
      k=k+1;
      
      d(:,k) = ds(:,i);
      
      y(:,k) = ys(:,i); 
      
      yn(:,k) = y(:,k) + E*(rand(m,1)-0.5)*2;
      
      r(:,k) = setpoint( t(k) );                       % Sinal de Refer�ncia     
      u(:,k) = control( t(k) , yn(:,k) , r(:,k) , T ); % Lei de controle
      
      if u(:,k) > umax
         u(:,k) = umax;
      elseif u(:,k) < umin
         u(:,k) = umin;
      end
      
      rs(:,i) = r(:,k); 
      us(:,i) = u(:,k); 
 else   
      rs(:,i) = rs(:,i-1); 
      us(:,i) = us(:,i-1);  
   end
   
   % Simula��o da Planta
   
   if i < Ns
   
       if i > Nd
          ud = us(:,i-Nd);
       else
          ud = 0*us(:,i);
       end
       
       uu = ud+ds(:,i);
       
       xs(:,i+1) = Ts*( A*xs(:,i) + B*uu ) + xs(:,i);
       ys(:,i+1) = C*xs(:,i+1) + D*uu;  
   end
   
end
disp('Simula��o completa!')

y=y';
yn=yn';
u=u';
r=r';
t=t';

end

