function [PSCraus]=Synapse(dt,Schritte,Leckstrom,Gewicht,AP,mu,sigma)
%function [PSCraus]=Synapse(dt,Schritte,Leckstrom,Gewicht,AP,mu,sigma)
% latenzfunktion eingefügt 6.9.04
%latenz funktion verändert für rauschen 2.2.05
% rauschen eingefügt 21.2.05
% Andreas Bahmer 

persistent lzeit
persistent Transmitter
persistent buffer
persistent Latenzschritt

global Ausschuettung2


if length(Transmitter)==0
    Transmitter=0;
end

if length(lzeit)==0
    lzeit=length(Ausschuettung2)- Schritte +1; %am Anfang außerhalb der Ausschuettung
    Latenzschritt=abs(round(normrnd(mu,sigma)/dt));
end

%-----------Berechnung--------------

if AP ==1
    lzeit=1;
    Latenzschritt=abs(round(normrnd(mu,sigma)/dt));
end


Transmitter=Transmitter+Ausschuettung2(lzeit)*dt;
Transmitter=Transmitter-Transmitter*dt*Leckstrom;
PSCrein=Gewicht*(tanh(abs(Transmitter)*10 - 5)+1)/2; %tangenshyp.funktion für sigmoidale übertagungsfunktion
lzeit=lzeit+1;

%------------------------------Latenz einfügen--------

if Latenzschritt+1>length(buffer)
buffer(Latenzschritt+1)=PSCrein;
else
buffer(Latenzschritt+1)=buffer(Latenzschritt+1)+PSCrein;
end
PSCraus=buffer(1);
buffer(1)=[];
