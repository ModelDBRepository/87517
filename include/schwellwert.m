function raus=schwellwert(absrefrak,relrefrak,dt)


absz=zeros(1,round(absrefrak/dt));
absz(1,:)=10;

if relrefrak~=0
unter=round(relrefrak/dt);
x=linspace(0,14,unter);
relz=(10)*exp(-x);
raus=[absz relz];
else
    raus=absz;
end
