function plot_nond_v2_1_bfm
% Function plot_nond plots nondimensional critical initial width values (computed from functin CriticalInitialWidth) vs different
% nondimensional parameters.
%
% Last Update: 9/10/2017
%
%--------------------------------------------------------------------------------------------------
format compact
format longG
clear
clf
hold on

%------------------- Shared Data ------------------
C_f = 15 *10^-3;   % river concentration (kg/m3)
Q_f = 20;          % river water discharge (m3/s)
b_B = 10 *10^3;  % total basin width (both sides of the channel) (m)
L_E = 10 *10^3;   % Estuary length (m)
R = 2 *10^-3/365/24/60/60; % sea level rise (m/s)
H = 1.4 /2;       % tidal amplitude (range/2) (m)
T = 12 *60*60;   % tidal period (s) (= 12 hours)
rho_s = 1000; % (kg/m3)

%--------------------- Graph 1 --------------------
load co_data_Rby2; conv = dat(:,7);
Chi = dat(:,2);    % Nonstable  equilibrium tidal flat width
C_o = dat(:,1);    % ocean concertation (kg/m3)

R = 1 *10^-3/365/24/60/60; % sea level rise (m/s)

x = C_o/C_f;
y = Chi/b_B;
z1 = round((b_B*L_E*R*rho_s)/(C_f*Q_f*T),4);

p1 = gscatter(x,y,conv,'k','ox<s+',[],'off');

%--------------------- Graph 2 --------------------
load co_data_base; conv = dat(:,7);
Chi = dat(:,2);    % Nonstable  equilibrium tidal flat width
C_o = dat(:,1);    % ocean concertation (kg/m3)

R = 2 *10^-3/365/24/60/60; % sea level rise (m/s)

x = C_o/C_f;
y = Chi/b_B;
z2 = round((b_B*L_E*R*rho_s)/(C_f*Q_f*T),4);

p2 = gscatter(x,y,conv,'r','ox<s+',[],'off');

%--------------------- Graph 3 --------------------
load co_data_Rx2; conv = dat(:,7);
Chi = dat(:,2);    % Nonstable  equilibrium tidal flat width
C_o = dat(:,1);    % ocean concertation (kg/m3)

R = 4 *10^-3/365/24/60/60; % sea level rise (m/s)

x = C_o/C_f;
y = Chi/b_B;
z3 = round((b_B*L_E*R*rho_s)/(C_f*Q_f*T),4);

p3 = gscatter(x,y,conv,'b','ox<s+',[],'off');

%--------------------- Graph 4 --------------------
load co_data_Rx4; conv = dat(:,7);
Chi = dat(:,2);    % Nonstable  equilibrium tidal flat width
C_o = dat(:,1);    % ocean concertation (kg/m3)

R = 8 *10^-3/365/24/60/60; % sea level rise (m/s)

x = C_o/C_f;
y = Chi/b_B;
z4 = round((b_B*L_E*R*rho_s)/(C_f*Q_f*T),4);

p4 = gscatter(x,y,conv,'g','ox<s+',[],'off');

%------------------------------------------------
title('z = Sediment Input Ratio (SLR Space/Riverine)') 
legend([p1(1),p2(1),p3(1),p4(1)],['z = ' num2str(z1)],['z = ' num2str(z2)],['z = ' num2str(z3)],['z = ' num2str(z4)],'location','northwest')
ylabel('Tidal Flat Width Ratio (\chi/b_B)')
xlabel('Concentration Ratio (C_O/C_R)')
box on

% set(findobj('type','axes'),'fontsize',10)
% h_fig=gcf;
% set(h_fig,'PaperOrientation','portrait')
% set(h_fig,'PaperPosition', [0 0 12 5]) % [... ... max_width=7.5 max_height=9]
% tit='equilibrium solutions-1kyr';
% print(tit,'-dtiff','-r400')
% movefile([tit,'.tif'],'C:\Users\fy23\Fateme\Projects\Marsh Model\Results\20 - Unstable Equlibrium Results through Optimization of Steady State')
% close all