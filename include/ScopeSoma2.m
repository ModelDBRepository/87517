function [APraus,Spannungraus]=ScopeSoma(dt,Leckstrom,PSC,schwelle)
%function [APraus,Spannungraus]=ScopeSoma(dt,Leckstrom,PSC)
%Andreas Bahmer 8.9.2004
% nargin eingefügt 19.10.04
% Andreas Bahmer

persistent lzeit
persistent Spannung
if nargin<4
global schwelle
end

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
Spannungraus=Spannung;

if  Spannung>schwelle2(lzeit) + grundschwelle
    APraus=1;
    Spannung=0;
    lzeit=1;
else APraus=0; 
    lzeit=lzeit+1;
end


