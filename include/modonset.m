function [onset_ap, V__]=modonset(anf,f_s,DT)
%function onset_ap=modonset(anf,f_s,DT)
% ursprungcode c von hemmert basierend auf rothman manis 2003 the roles
% potassium channel...
% 4.11.04
% bug m^4 !! es sollte m^3 sein 1.7.05
% Andreas Bahmer
visualize=0;
%//------------- Synaptic Current -----------------------------------------------*/
tau_E=0.6e-3;   % 22 °C
tau_E=0.1e-3;   % 38 °C
g_E=SynapticExcitation(anf,tau_E,f_s); %Übersetzung Spikes zu Kanalöffnung
%------------------Konvergenz auf onsetneuron------------------
% accros channel locking
col=size(g_E,1);
%width_=[2,4,8,16];     %verschiedene Fensterbreiten
%width_=[2,16];
%width_=[16,2];
%for w_cnt=1:size(width_,2)
%width=width_(w_cnt)
width=8;%9.8.0516; %10.11.04
sigma=width;
range=1:round(sigma*2.5);
win=1/sqrt(2*pi)/sigma * exp(-1/2*(range-0.5).^2/sigma^2);



g_E_CH=g_E;                      %% THIS IS A BUG !!!!!!!!!!
for cnt=1:size(range,2);
  win=1/sqrt(2*pi)/sigma * exp(-1/2*(cnt-0.5).^2/sigma^2);
  g_E_CH(1:col-cnt,:)=g_E_CH(1:col-cnt,:) + g_E(1+cnt:col  ,:)   * win;
  g_E_CH(1+cnt:col,:)=g_E_CH(1+cnt:col,:) + g_E(1:col-cnt,:)     * win;
end
%g_E=g_E_CH / win;       % scale window to 1
%g_E=g_E_CH *20;       % scale
if visualize
    %figure,plot(t*1e3,g_E(50,:)*1e12)
    % ylabel('current (pA)')
    plot([win(size(win,2):-1:1) win],[-range(size(win,2):-1:1)+0.5 range-0.5])
    axis([0 0.2 -49 50])
    figure,imagesc([0 size(g_E,2)/f_s*1e3],[1 size(g_E,1)],g_E)
    title(sprintf('Synaptic input CONDUCTIVITY  w=%d ',width))
    xlabel('time (ms)')
    ylabel('low             cochlear frequency channel              high  ')
    colorbar
    figure,imagesc([0 size(g_E,2)/f_s*1e3],[1 size(g_E,1)],g_E_CH)
    title(sprintf('Synaptic input CONDUCTIVITY  w=%d gECH',width))
    xlabel('time (ms)')
    ylabel('low             cochlear frequency channel              high  ')
    colorbar
end

%----------------modifiziertes Onset Neuron----------------------
%// 22.12.2003 Temperature scaling: tau *0.17, IN CALLING PROGRAMME: G*3.03 (except g_E) according to Rothman & Manis 2003
% VALUES in ms and mV !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
C_M=12e-12;          %// 12pF Membrane capacitance
V_K=-70e-3;          %// -70mV K reversal potential
V_Na= +55e-3;          %// 55mV Na reversal potential
V_h= -43e-3;           %// -43mV Na reversal potential
V_lk= -65e-3;          %// -65mV Na reversal potential
V_E=  0e-3;          %// 0 mV reversal potential of excitation
g_Na = 3.03* 1000e-9;          %// 1000nS
g_HT = 3.03* 150e-9;          %// nS
g_LT = 3.03* 200e-9;          %// nS
g_A  = 3.03* 0e-9;          %// nS
g_h  = 3.03* 20e-9;          %// nS
g_lk = 3.03* 2e-9;          %// nS
V_0  =-63.6e-3;          %// -63.6mV   resting potential for START
V_0  =-43.6e-3;          %// -43.6mV   PRE-depolarized potential for START
g_E0=34e-9;   % nS Threshold
[l_channel schritte]=size(g_E_CH);
for channel=1:l_channel;%l_channel
    g_E_input=g_E_CH(channel,:)*g_E0; %g_E0*g_E_CH input von vcn dll von hemmert!! anpassen!!
    %-----------Initialisierung-------------------
    V=V_0;
    w_inf=(1.+exp(-(V+48e-3)/6e-3))^(-0.25);
    z_inf=0.5/(1.+exp( (V+71e-3)/10e-3)) + 0.5;
    m_inf= 1./(1.+exp(-(V+38e-3)/7e-3)); % // fast Na+  NO BUG in PAPER!!
    h_inf= 1./(1.+exp( (V+65e-3)/6e-3)); % // BUG bis 5.11.2003
    w = w_inf;
    z = z_inf;
    m = m_inf;
    h = h_inf;
    g_E = 1e-14; 
    % neuron:  void neuron(double *V__, double *g_E_input, double g_Na,double g_HT,double g_LT,double g_A,double g_h,double g_lk,double V_0, int sections, double *debug__)
    for t=1:schritte
        %-------Kaliumkanal low threshold(LT)-----------
        w_inf= (1.+exp(-(V+48e-3)/6e-3))^(-0.25);    
        z_inf=0.5/(1.+exp( (V+71e-3)/10e-3)) + 0.5;
        tau_w= 0.17*  (100./(6.*exp((V+60e-3)/6e-3)+16.*exp(-(V+60e-3)/45e-3)) +1.5)/1000.;% // s
        tau_z= 0.17* (1000./(  exp((V+60e-3)/20e-3)+exp(-(V+60e-3)/8e-3)) +50.)/1000.;     % // s
        w=w+(w_inf-w)*DT/tau_w;
        z=z+(z_inf-z)*DT/tau_z;
        G_LT = g_LT*w^4*z;  %// DOMINANT
        I_LT=G_LT*(V-V_K);
        %-------Natriumkanal fast----------------------
        m_inf= 1./(1+exp(-(V+38e-3)/7e-3));       
        %// m_inf= pow(1+exp(-(V+38e-3)/7e-3),-0.333333333333);       %// fast Na+  NO BUG in PAPER!!
        h_inf= 1./(1+exp( (V+65e-3)/6e-3));       %// BUG bis 5.11.2003
        %//SLOW    tau_m= 0.17* ( 10./(5*exp((V+60e-3)/18e-3)+36*exp(-(V+60e-3)/25e-3)) +0.04)/1000; %// s
        %//SLOW    tau_h= 0.17* (100./(7*exp((V+60e-3)/11e-3)+10*exp(-(V+60e-3)/25e-3)) +0.6)/1000;  %// s
        tau_m= 0.5* ( 10./(5*exp((V+60e-3)/18e-3)+36*exp(-(V+60e-3)/25e-3)) +0.04)/1000; %// s
        tau_h= 0.5* (100./(7*exp((V+60e-3)/11e-3)+10*exp(-(V+60e-3)/25e-3)) +0.6)/1000;  %// s
        m=m+(m_inf-m)*DT/tau_m;
        h=h+(h_inf-h)*DT/tau_h;
        G_Na = g_Na*m^3*h;
        I_Na = G_Na*(V-V_Na);
        %-------------Leakage current------------
        G_lk = g_lk;
        I_lk=G_lk*(V-V_lk);                      
        %----------Process input------------------
        G_E =g_E_input(t);  %// DOMINANT
        %I_E=g_E_input*(V-V_E);   %// CONDUCTANCE ACTIVATION
        %---------- STABILITY: CALCULATE EXACT SOLUTION -------------------
        G_tot=G_LT+G_Na+G_lk+G_E;  %// Tevernin equivalent conductivity %anscheinend damit die berechnung stabil bleibt.
        %G_tot=G_A+G_LT+G_HT+G_Na+G_h+G_lk+G_E;  %// Tevernin equivalent conductivity %anscheinend damit die berechnung stabil bleibt.
        V_inf=(V_K*G_LT+V_Na*G_Na+V_lk*G_lk+V_E*G_E)/(G_LT+G_Na+G_lk+G_E);      %// Tevernin equivalent Voltage
        V=V_inf + (V-V_inf) * exp(-DT/C_M*G_tot);   %// Exact Solution
        V__(channel,t)=V;
        G_LTs(t)=G_LT;
        G_Nas(t)=G_Na;
        G_lks(t)=G_lk;
    end
end

%---------------------Ausgabe-------------------------------------------
% figure
% imagesc([0 size(V,2)/f_s*1e3],[1 size(V,1)],V__*1000,[-60 0])
% title(sprintf('%s w=%d  Type II Model',signal_name,width))
% xlabel('time (ms)')
% ylabel('low             cochlear frequency channel              high  ')
% colorbar
% % end
% %end
 onset_ap=((V__*1000)>0);
 if visualize
 figure
 imagesc([0 size(onset_ap,2)/f_s*1e3],[1 size(onset_ap,1)],onset_ap)
 %title(sprintf('%s w=%d  Type II Model',signal_name,width))
 xlabel('time (ms)')
 ylabel('low             cochlear frequency channel              high  ')
 colormap (1-gray)
 %figure,plot(V(50,:))
% %figure, plot(onset_ap(50,:))
 end