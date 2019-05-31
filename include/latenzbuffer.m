function APraus=latenzbuffer(APrein,dt,mu,sigma)
%function APraus=latenzbuffer(APrein,dt,mu,sigma)

% 3.2.05
% Andreas Bahmer

persistent Latenzschritt
persistent buffer

%--Initialisierung
if length(Latenzschritt)==0
    Latenzschritt=abs(round(normrnd(mu,sigma)/dt)); %keine verteilung mehr
end

%---nur Update der Latenz wenn ein AP kommt
if APrein==1
    Latenzschritt=abs(round(normrnd(mu,sigma)/dt));
end

%----latenz
buffer(Latenzschritt+1)=APrein;
APraus=buffer(1);
buffer(1)=[];