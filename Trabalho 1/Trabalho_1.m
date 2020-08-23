%% Introdução
T = 0.001;
z = tf([1 0],[1],T);
Tetha = zeros([1,5]);
Gz = ((Tetha(3)*z^2+Tetha(4)*z+Tetha(5))/(z^2-Tetha(1)*z-Tetha(2)));
Gs = d2c(Gz) %Qual método usar?