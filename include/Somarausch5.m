function [APraus]=Somarausch(dt,Leckstrom,PSC,schwelle,mu,sigma)
%function [APraus]=Somarausch(dt,Leckstrom,PSC,schwelle,rauschprozent)
%Andreas Bahmer 4.9.2004

persistent lzeit
persistent Spannung

if nargin<4
global schwelle
end

if length(Spannung)==0
    Spannung=0;
end

%----------Schwellwert----------------------------------
rausch=normrnd(mu,sigma)*0.0001;
schwelle2=[schwelle 0 zeros(1,lzeit)];  %mit puffer nach hinten
if length(lzeit)==0
lzeit=length(schwelle)+1;   %außerhalb refraktaerzeit
end


%--------------Berechnung---------------

Spannung=Spannung+PSC*dt;
Spannung=Spannung-Spannung*dt*Leckstrom;
Spannungraus=Spannung;

if  (Spannung+rausch)>schwelle2(lzeit) + 0.0001
    APraus=1;
    Spannung=0;
    lzeit=1;
else APraus=0; 
    lzeit=lzeit+1;
end


