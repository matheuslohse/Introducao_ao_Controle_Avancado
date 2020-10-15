function [A,B,C,D,E,delay,umin,umax,id]  = sysdata()
%SYSDATA Summary of this function goes here
%   Detailed explanation goes here

global noise

delay = 5;

umin = 0;
umax = 1;

A = [0       1      0    
     0       0      1    
    -1.256  -3.465 -9.472 ];

B = [ 0
      0
      2.475 ];

C = [1 0 0];

D = 0;

if ~noise
    E = 0;
else
    E = 5e-3;
end

id = 'Sistema de Tanques (2020/2)';

end

