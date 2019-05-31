function [PSCraus]=Synapse(dt,Schritte,Leckstrom,Gewicht,AP,Latenz)
%function [PSCraus]=Synapse(dt,Schritte,Leckstrom,Gewicht,AP,Latenz)
% latenzfunktion eingef�gt 6.9.04
% Andreas Bahmer 

persistent lzeit
persistent Transmitter
persistent buffer

global Ausschuettung2


if length(Transmitter)==0
    Transmitter=0;
end

if length(lzeit)==0
    lzeit=length(Ausschuettung2)- Schritte +1; %am Anfang au�erhalb der Ausschuettung
end

%-----------Berechnung--------------

if AP ==1
    lzeit=1;
end


Transmitter=Transmitter+Ausschuettung2(lzeit)*dt;
Transmitter=Transmitter-Transmitter*dt*Leckstrom;
PSCrein=Gewicht*(tanh(abs(Transmitter)*10 - 5)+1)/2; %tangenshyp.funktion f�r sigmoidale �bertagungsfunktion
lzeit=lzeit+1;

%------------------------------Latenz einf�gen--------
Latenzschritt=round(Latenz/dt);
buffer(Latenzschritt+1)=PSCrein;
PSCraus=buffer(1);
buffer(1)=[];

