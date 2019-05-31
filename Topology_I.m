%chopper aus 2 neuronen periode:0.8ms
% input: VIII. nerv von hemmert signal: sinusampl.moduliertes und
% unmoduliertes Signal
% onset: modifizeirtes Onsetneuron von Hemmert
% chopper (2 Neuronen im kreis): eingang aus onset und VIII. Nerv 3.11.04
%  synapsen eingefügt, allerdings einmal fünf obwohl zwei chopper neuronen, da in einem zeitschritt das gleiche passiert!! 8.11.04
% 9.12.04 soma rauschen eingefügt.
% 20.1.05 5 neurone
% Andreas Bahmer

clear global
clear functions

visualize=0;
f_s=40000;   % 40000hz= 24µs   %signal aus SAM_Hair_Nerv_Andi_Onset
dt=1./f_s;     %// in s



AP5_realNerv=(anft==5);
AP4_realNerv=bitor(anft==4,AP5_realNerv);
AP3_realNerv=bitor(anft==3,AP4_realNerv);
AP2_realNerv=bitor(anft==2,AP3_realNerv);
AP1_realNerv=bitor(anft==1,AP2_realNerv);
onsetneuron=+onsett;

Zeitachse=0:dt:length(AP1_realNerv)*dt;
Schritte=length(AP1_realNerv);

%-----Variablendeklaration----------------------
%Somata
absRefraktaerzeit=0.0017;%0.0006 3.11.04%0.0003%18.10.04
relRefraktaerzeit=0.0001;%0.0002 3.11.04
Verlust=3000;%3600%1850;
sigma=0;  %0.3 schon onset erkennbar0.4 auch ohne onset 0.5 grenze %standardabweichung*grundschwelle beim rauschen
%Synapse
Verlustsy=4000;%1800;%10000; %zeitkonstante 10000 = 0.1ms
Gewicht=0.75;%0.39;%2;%3;%1.8; %gewicht 2.5 grenze 2.0
VerlustsyNerv=1300;%1300 %8000 vorher
GewichtNerv=0.1%0.6 schwelle bei dem ohne onset choppt 0.15 mit onset%.2%0.4;%0.3;%0.5 %gewicht 2.5 grenze 2.0 %hier drehen um die ersten chopps mit modulation zu trennen
Latenzsy_A=0.00018;%0.00026%0.00028
sigmasyn=0.00026;

global Ausschuettung2
Ausschuettung2=Ausschuettung(dt,Schritte); 
%global schwelle
schwelle=schwellwert(absRefraktaerzeit,relRefraktaerzeit,dt);
AP_5A=0;

for s=1:Schritte%-----BEGINN---------------------------------------------------------------

[PSC_realNervAP1]=Synapse1(dt,Schritte,VerlustsyNerv,GewichtNerv/5,+AP1_realNerv(s),Latenzsy_A);
[PSC_realNervAP2]=Synapse2(dt,Schritte,VerlustsyNerv,GewichtNerv/5,+AP2_realNerv(s),Latenzsy_A);
[PSC_realNervAP3]=Synapse3(dt,Schritte,VerlustsyNerv,GewichtNerv/5,+AP3_realNerv(s),Latenzsy_A);
[PSC_realNervAP4]=Synapse4(dt,Schritte,VerlustsyNerv,GewichtNerv/5,+AP4_realNerv(s),Latenzsy_A);
[PSC_realNervAP5]=Synapse5(dt,Schritte,VerlustsyNerv,GewichtNerv/5,+AP5_realNerv(s),Latenzsy_A);
PSC_realNerv=PSC_realNervAP1+PSC_realNervAP2+PSC_realNervAP3+PSC_realNervAP4+PSC_realNervAP5;

%-------------- SynapseOnset für Onset ----------------------------
[PSC_Onset]=Synapse6(dt,Schritte,Verlustsy,0.8,+onsetneuron(s),Latenzsy_A);  


%---------------Latenzrauschen des chopperkreises----
%AP_5A_L=latenzbuffer(AP_5A,dt,0.0009,0.00026);
%-------------- Synapse1A2-------------------von Soma5A--------------------
[PSC_1A]=Synapselatenztrauschen1(dt,Schritte,Verlustsy,Gewicht,AP_5A,0.0001,sigmasyn);
%--------------Soma1A------------------------------------------------------
PSC_1Agesamt=PSC_Onset+PSC_1A+PSC_realNerv;
%PSC_1Agesamt=PSC_1A+PSC_realNerv;

[AP_1A,Spannung_1A]=ScopeSomarausch1(dt,Verlust,PSC_1Agesamt,schwelle,0,sigma);
%--------------Synapse2A---------------------------------------------------
[PSC_2A]=Synapselatenztrauschen2(dt,Schritte,Verlustsy,Gewicht,AP_1A,0.0001,sigmasyn);
%---------------Soma2A-----------------------------------------------------
PSC_2Agesamt=PSC_2A+PSC_realNerv;
[AP_2A]=Somarausch2(dt,Verlust,PSC_2Agesamt,schwelle,0,sigma);
%--------------Synapse3A---------------------------------------------------
[PSC_3A]=Synapselatenztrauschen3(dt,Schritte,Verlustsy,Gewicht,AP_2A,0.0001,sigmasyn);
%--------------Soma3A------------------------------------------------------
PSC_3Agesamt=PSC_3A+PSC_realNerv;
[AP_3A]=Somarausch3(dt,Verlust,PSC_3Agesamt,schwelle,0,sigma);
%--------------Synapse4A---------------------------------------------------
[PSC_4A]=Synapselatenztrauschen4(dt,Schritte,Verlustsy,Gewicht,AP_3A,0.0001,sigmasyn);
%---------------Soma4A-----------------------------------------------------
PSC_4Agesamt=PSC_4A+PSC_realNerv;
[AP_4A]=Somarausch4(dt,Verlust,PSC_4Agesamt,schwelle,0,sigma);
%--------------Synapse5A---------------------------------------------------
[PSC_5A]=Synapselatenztrauschen5(dt,Schritte,Verlustsy,Gewicht,AP_4A,0.0001,sigmasyn);
%---------------Soma5A-----------------------------------------------------
PSC_5Agesamt=PSC_5A+PSC_realNerv;
[AP_5A]=Somarausch5(dt,Verlust,PSC_5Agesamt,schwelle,0,sigma);

%--------------SCOPES-------------------------------------------------
if visualize
scope1(s+1)=PSC_realNerv;
scope2(s+1)=PSC_1Agesamt;
scope3(s+1)=AP_1A;
scope4(s+1)=Spannung_1A;
scope5(s+1)=PSC_2Agesamt;
scope6(s+1)=AP_2A;
scope7(s+1)=PSC_Onset;

else
%scope2(s+1)=PSC_1Agesamt;
scope3(s+1)=AP_1A;
%scope4(s+1)=Spannung_1A;
scope5(s+1)=AP_5A;
end

end;%----------ENDE SIMULATION---------------------------------------

%--------Darstellung----------------------------------------------------

if visualize
figure
subplot(5,1,1)
plot(Zeitachse,[ 0 anf(kanal,:)])
ylabel('AP real Nerv')
subplot(5,1,2)
plot(Zeitachse,scope7)
ylabel('PSC Onset')
subplot(5,1,3)
plot(Zeitachse,scope2)
ylabel('Chopper PSC')
subplot(5,1,4)
plot(Zeitachse,scope4)
ylabel('Chopper Spannung')
subplot(5,1,5)
plot(Zeitachse,scope3)
ylabel('Chopper AP')

figure
plot(Zeitachse,scope3)
%figure
%plot(Zeitachse,scope5)
%figure
%plot(Zeitachse,scope6)

end

