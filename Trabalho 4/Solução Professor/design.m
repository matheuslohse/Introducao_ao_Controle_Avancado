
global Cz Fz delay Gz smith

%% Dados do Projeto

% ts  < 30 s
% ss  < 4%
% fn  < 10 rad/s
% ord < 2
% sinal de controle < 1 unidades

delay = 5;

G = tf( [0 0 0 2.475 ] , [1 9.472 3.465 1.256] );

[num,den] = pade(delay,3);

H = tf(num,den);

Gd = G*H;

T = 0.1;

%% Projeto Nominal

% C = tf( [9.673785495929469   2.712899727974582   0.622006886336866] , [1   6.649999999999999                   0] );
% 
% F = tf( [ 0  0.4 ] , [1  0.4] );
% 
% Cz = c2d( C , T , 'tustin' );
% Fz = c2d( F , T , 'tustin' );

%% Projeto Padè

% C = tf( [0.318709608336963   0.094146213010566   0.311235274530058] , [1   9.986486486486488   0] );
% 
% F = tf( [ 0  0.8 ] , [1  0.8] );

% Cz = c2d( C , T , 'tustin' );
% Fz = c2d( F , T , 'tustin' );

%% Projeto Smith

% Smooth Controller
% C = tf( [1.394476765211555   0.182075670362450   0.074690832637609] , [1   1.258982596276962   0] );
% F = tf( [ 0     0   0.053563892825 ] , [1   0.13057   0.053563892825 ] );

% Agressive Controller
C = tf( [19.947131615834834  16.671014200069358   5.000240263518594] , [1   4.177961100013464     0] );
F = tf( [ 0     0   0.2506727873] , [1   0.83576   0.2506727873] );


Cz = c2d( C , T , 'tustin' );
Fz = c2d( F , T , 'tustin' );
Gz = c2d( G , T , 'zoh' );

smith = true;
