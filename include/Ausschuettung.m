function Ausschuettung2=Ausschuettung(dt,Schritte);
%function Ausschuettung2=Ausschuettung(dt,Schritte);


LaengeAussch=0.0002; %0.2ms
if dt>=LaengeAussch
    disp('dt muﬂ kleiner als 0.0002 sein!')
    Ausschuettung=0;
else
Schrittetable=round(LaengeAussch/dt);
maxwert=12e3;
x=1:Schrittetable/2;
table=x*(maxwert/(Schrittetable/2));
Ausschuettung=[  table fliplr(x(1:end-1))*maxwert/(Schrittetable/2) 0];
Ausschuettung2=[Ausschuettung zeros(1,Schritte)]; 
end
