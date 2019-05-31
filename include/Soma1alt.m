function [APraus]=Soma(dt,Leckstrom,PSC)
%function [APraus]=Soma(dt,Leckstrom,PSC)
%Andreas Bahmer 4.9.2004

persistent lzeit
persistent Spannung
global schwelle

if length(Spannung)==0
    Spannung=0;
end

%----------Schwellwert----------------------------------
grundschwelle=0.0001;
schwelle2=[schwelle 0 zeros(1,lzeit)];  %mit puffer nach hinten
if length(lzeit)==0
lzeit=length(schwelle)+1;   %außerhalb refraktaerzeit
end


%--------------Berechnung---------------

Spannung=Spannung+PSC*dt;
Spannung=Spannung-Spannung*dt*Leckstrom;

if  Spannung>schwelle2(lzeit) + grundschwelle
    APraus=1;
    Spannung=0;
    lzeit=1;
else APraus=0; 
    lzeit=lzeit+1;
end


