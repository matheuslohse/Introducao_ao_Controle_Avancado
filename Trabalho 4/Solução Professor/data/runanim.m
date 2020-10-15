function runanim( u , y , T )
%RUN_TANK_ANIM Summary of this function goes here
%   Detailed explanation goes here

disp('Rodando a animação...')
disp('(Pressione CTRL+C para interromper)')

Ta = T;

ya = y(1:end);
ua = u(1:end);

% umax = max(ua);
% for k=1:length(ua)
%     if ua(k) <=0
%         ua(k)=0;
%     end
% end
umax = 1;

delay = abs(find(ya,1)-find(ua,1));

%pipe
pipe.L = 5;
pipe.H = 0.25;
pipe.yo= 4;
pipe.xo= 0;

%tank
tank.L = 2;
tank.H = 2;
tank.yo= pipe.yo-tank.H-1;

figure
% plot pipe
plot([pipe.xo pipe.xo+pipe.L],[pipe.yo pipe.yo],'k') %bottom line
hold on
plot([pipe.xo pipe.xo+pipe.L],[pipe.yo+pipe.H pipe.yo+pipe.H] ,'k') %top line

% plot tank
plot([3.5 6.5],[1 1],'k') %bottom line
plot(pipe.xo+pipe.L+[-tank.L/1.5 tank.L/1.5],[tank.yo+1 tank.yo+1],'k--') %level line
plot(pipe.xo+pipe.L+[-tank.L/2 -tank.L/2],[tank.yo tank.yo+tank.H],'k') %left line
plot(pipe.xo+pipe.L+[tank.L/2 tank.L/2],[tank.yo tank.yo+tank.H],'k') %right line
tankp = patch(pipe.xo+pipe.L+[-tank.L/2 tank.L/2 tank.L/2 -tank.L/2],tank.yo + [0 0 0 0],'b');

for k=1:delay    
    pipep(k) = patch(pipe.xo+([k k+1 k+1 k]-1)*5/delay,[pipe.yo pipe.yo pipe.yo+pipe.H  pipe.yo+pipe.H],'b','Linewidth',0.1);
end

axis([0 pipe.L+1.5 0 pipe.yo+1])
axis off
h3=axes('position',[.12 .275 0.4 0.32],'visible','off');
yplot = plot(ones(1,length(ya))*Ta,zeros(1,length(ya)));
set(yplot,'XData',[0:length(ya)-1]*Ta)
axis([0 length(ya)*Ta 0 2])
xlabel('tempo [s]')
ylabel('nível [m]')
grid on

for k = delay+1:length(ua)
    set(tankp,'YData',tank.yo + [0 0 ya(k) ya(k)])
    
    for j=1:length(pipep)
        set(pipep(j),'YData',[pipe.yo pipe.yo pipe.yo+ua(k-j)*pipe.H/umax  pipe.yo+ua(k-j)*pipe.H/umax])
    end

    if ya(k)>tank.H
        set(tankp,'FaceColor','r')
        break
    end
    
    set(yplot,'YData',[ya(1:k)])
    set(yplot,'XData',[0:k-1]*Ta)
    drawnow
end

disp('Animação concluída!')

end

