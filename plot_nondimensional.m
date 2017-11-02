%-------------- Plot nondimensional analysis results
% loading data
clear

C_o = 20 *10^-3;    % ocean concertation (kg/m3)
C_f = 15 *10^-3;    % river concentration (kg/m3)
Q_f = 20/2;         % river water discharge (m3/s)
b_fm = 5 *10^3; % total basin width (both sides of the channel) (m)
L_E = 5 *10^3; % basin length (m)
R = 2 *10^-3/365/24/60/60;   % sea level rise (m/s)
T_T = 12 *60*60;   % tidal period (s) ( = 12 hours)
H = 1.4/2;          % tidal amplitude (range/2) (m)
par_v = [1/3, 2/3, 1, 4/3];

%%
Co_ = (10:10:80) *10^-3;
n1 = length(Co_);
k = length (par_v);

load Sol_Co_bfm
bfm_ = b_fm * par_v;

for i = 1 : n1
    dat(:,1,i) = squeeze(Sol(i,1,:))/sqrt(Q_f/R);
    dat(:,2,i) = L_E*bfm_*H/T_T/Q_f;
    dat(:,3,i) = squeeze(Sol(i,1,:))./bfm_';
    dat(:,4,i) = Co_(i)*L_E*bfm_*H/T_T/Q_f/C_f;
    dat(:,5,i) = L_E*bfm_*H/T_T/Q_f;
    dat(:,6,i) = squeeze(Sol(i,1,:));
    dat(:,7,i) = squeeze(Sol(i,2,:));
    dat(:,8,i) = squeeze(Sol(i,3,:));
end
pi_cobfm = dat;
clear dat

load Sol_Co_le
LE_ = L_E * par_v;

for i = 1 : n1
    dat(:,1,i) = squeeze(Sol(i,1,:))/sqrt(Q_f/R);
    dat(:,2,i)  = LE_*b_fm*H/T_T/Q_f;
    dat(:,3,i) = squeeze(Sol(i,1,:))/b_fm;
    dat(:,4,i)  = Co_(i)*LE_*b_fm*H/T_T/Q_f/C_f;
    dat(:,5,i)  = LE_*b_fm*H/T_T/Q_f;
    dat(:,6,i) = squeeze(Sol(i,1,:));
    dat(:,7,i) = squeeze(Sol(i,2,:));
    dat(:,8,i) = squeeze(Sol(i,3,:));
end
pi_cole = dat;
clear dat

load Sol_Co_H
H_  = H * par_v;

for i = 1 : n1
    dat(:,1,i) = squeeze(Sol(i,1,:))/sqrt(Q_f/R);
    dat(:,2,i) = L_E*b_fm*H/T_T/Q_f;
    dat(:,3,i) = squeeze(Sol(i,1,:))/b_fm;
    dat(:,4,i) = Co_(i)*L_E*b_fm*H/T_T/Q_f/C_f;
    dat(:,5,i) = L_E*b_fm*H/T_T/Q_f;
    dat(:,6,i) = squeeze(Sol(i,1,:));
    dat(:,7,i) = squeeze(Sol(i,2,:));
    dat(:,8,i) = squeeze(Sol(i,3,:));
end
pi_coh = dat;
clear dat

load Sol_Co_Qf
Qf_ = Q_f ./ par_v;

for i = 1 : n1
    dat(:,1,i) = squeeze(Sol(i,1,:))./sqrt(Qf_'/R);
    dat(:,2,i) = L_E*b_fm*H/T_T./Qf_;
    dat(:,3,i) = squeeze(Sol(i,1,:))/b_fm;
    dat(:,4,i) = Co_(i)*L_E*b_fm*H/T_T./Qf_/C_f;
    dat(:,5,i) = L_E*b_fm*H/T_T./Qf_;
    dat(:,6,i) = squeeze(Sol(i,1,:));
    dat(:,7,i) = squeeze(Sol(i,2,:));
    dat(:,8,i) = squeeze(Sol(i,3,:));
end
pi_coqf = dat;
clear dat

R_ = (1:8) *10^-3/365/24/60/60;
n2 = length(R_);

load Sol_R_bfm
bfm_ = b_fm ./ par_v;

for i = 1 : n2
    dat(:,1,i) = squeeze(Sol(i,1,:))./sqrt(bfm_'*L_E);
    dat(:,2,i) = C_f*Q_f/C_o/R_(i)/L_E./bfm_;
    dat(:,3,i) = squeeze(Sol(i,1,:));
    dat(:,4,i) = squeeze(Sol(i,2,:));
    dat(:,5,i) = squeeze(Sol(i,3,:));
end
pi_rbfm = dat;
clear dat

load Sol_R_le
LE_ = L_E ./ par_v;


for i = 1 : n2
    dat(:,1,i) = squeeze(Sol(i,1,:))./sqrt(b_fm*LE_');
    dat(:,2,i) = C_f*Q_f/C_o/R_(i)./LE_/b_fm;
    dat(:,3,i) = squeeze(Sol(i,1,:));
    dat(:,4,i) = squeeze(Sol(i,2,:));
    dat(:,5,i) = squeeze(Sol(i,3,:));
end
pi_rle = dat;
clear dat

load Sol_R_Co
Co_ = C_o ./ par_v;

for i = 1 : n2
    dat(:,1,i) = squeeze(Sol(i,1,:))/sqrt(b_fm*L_E);
    dat(:,2,i) = C_f*Q_f./Co_/R_(i)/L_E/b_fm;
    dat(:,3,i) = squeeze(Sol(i,1,:));
    dat(:,4,i) = squeeze(Sol(i,2,:));
    dat(:,5,i) = squeeze(Sol(i,3,:));
end
pi_rco = dat;
clear dat

load Sol_R_Cf
Cf_ = C_f * par_v;

for i = 1 : n2
    dat(:,1,i) = squeeze(Sol(i,1,:))/sqrt(b_fm*L_E);
    dat(:,2,i) = Cf_*Q_f/C_o/R_(i)/L_E/b_fm;
    dat(:,3,i) = squeeze(Sol(i,1,:));
    dat(:,4,i) = squeeze(Sol(i,2,:));
    dat(:,5,i) = squeeze(Sol(i,3,:));
end
pi_rcf = dat;
clear dat

%%
% chi_2
clf

subplot(2,2,1)

hold on
for i = 1 : n1
    plot(pi_cobfm(:,2,i),pi_cobfm(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , b_B')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

subplot(2,2,2)

hold on
for i = 1 : n1
    plot(pi_cole(:,2,i),pi_cole(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , l_E')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

subplot(2,2,3)

hold on
for i = 1 : n1
    plot(pi_coh(:,2,i),pi_coh(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , H')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)B')
box on

subplot(2,2,4)

hold on
for i = 1 : n1
    plot(pi_coqf(:,2,i),pi_coqf(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , Q_R')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

set(findobj('type','axes'),'fontsize',10)
h_fig = gcf;
set(h_fig,'PaperOrientation','portrait')
set(h_fig,'PaperPosition', [0 0 14 10]) % [... ... max_width = 7.5 max_height = 9]
tit = 'chi-2';
print(tit,'-dtiff','-r400')
movefile([tit,'.tif'],'C:\Users\fy23\Fateme\Projects\Marsh Model\Results\22 - Nondimensional Analysis')
close all

%%
% chi_3
clf

subplot(2,2,1)

hold on
for i = 1 : n2
    plot(pi_rbfm(:,2,i),pi_rbfm(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Mass Ratio (C_R Q_R / C_O Q_{SLR}) , b_B')
ylabel('\pi = Tidal Flat Width Ratio (\chi/\surd b_B l_E)')
title('\pi_2 = Water Rise Rate Ratio (H/T/R)')
box on

subplot(2,2,2)

hold on
for i = 1 : n2
    plot(pi_rle(:,2,i),pi_rle(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Mass Ratio (C_R Q_R / C_O Q_{SLR}) , l_E')
ylabel('\pi = Tidal Flat Width Ratio (\chi/\surd b_B l_E)')
title('\pi_2 = Water Rise Rate Ratio (H/T/R)')
box on

subplot(2,2,3)

hold on
for i = 1 : n2
    plot(pi_rco(:,2,i),pi_rco(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Mass Ratio (C_R Q_R / C_O Q_{SLR}) , C_O')
ylabel('\pi = Tidal Flat Width Ratio (\chi/\surd b_B l_E)')
title('\pi_2 = Water Rise Rate Ratio (H/T/R)')
box on

subplot(2,2,4)

hold on
for i = 1 : n2
    plot(pi_rcf(:,2,i),pi_rcf(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Mass Ratio (C_R Q_R / C_O Q_{SLR}) , C_R')
ylabel('\pi = Tidal Flat Width Ratio (\chi/\surd b_B l_E)')
title('\pi_2 = Water Rise Rate Ratio (H/T/R)')
box on

set(findobj('type','axes'),'fontsize',10)
h_fig = gcf;
set(h_fig,'PaperOrientation','portrait')
set(h_fig,'PaperPosition', [0 0 14 10]) % [... ... max_width = 7.5 max_height = 9]
tit = 'chi-3';
print(tit,'-dtiff','-r400')
movefile([tit,'.tif'],'C:\Users\fy23\Fateme\Projects\Marsh Model\Results\22 - Nondimensional Analysis')
close all

%%
% chi_4
clf

subplot(2,2,1)

hold on
for i = 1 : n1
    plot(pi_cobfm(:,4,i),pi_cobfm(:,3,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , b_B')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

subplot(2,2,2)

hold on
for i = 1 : n1
    plot(pi_cole(:,4,i),pi_cole(:,3,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , l_E')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

subplot(2,2,3)

hold on
for i = 1 : n1
    plot(pi_coh(:,4,i),pi_coh(:,3,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , H')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)B')
box on

subplot(2,2,4)

hold on
for i = 1 : n1
    plot(pi_coqf(:,4,i),pi_coqf(:,3,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , Q_R')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

set(findobj('type','axes'),'fontsize',10)
h_fig = gcf;
set(h_fig,'PaperOrientation','portrait')
set(h_fig,'PaperPosition', [0 0 14 10]) % [... ... max_width = 7.5 max_height = 9]
tit = 'chi-4';
print(tit,'-dtiff','-r400')
movefile([tit,'.tif'],'C:\Users\fy23\Fateme\Projects\Marsh Model\Results\22 - Nondimensional Analysis')
close all

%%
% chi_5
clf

subplot(2,2,1)

hold on
for i = 1 : n1
    plot(pi_cobfm(:,2,i),pi_cobfm(:,1,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , b_B')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

subplot(2,2,2)

hold on
for i = 1 : n1
    plot(pi_cole(:,5,i),pi_cole(:,3,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , l_E')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

subplot(2,2,3)

hold on
for i = 1 : n1
    plot(pi_coh(:,5,i),pi_coh(:,3,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , H')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)B')
box on

subplot(2,2,4)

hold on
for i = 1 : n1
    plot(pi_coqf(:,5,i),pi_coqf(:,3,i),'Linewidth',2);
end
xlabel('\pi_1 = Tidal Prism Ratio (Q_O/Q_R) , Q_R')
ylabel('\pi = Tidal Flat Width Ratio (\chi/{\surd} Q_R/R)')
title('\pi_2 = Concentration Ratio (C_O/C_R)')
box on

set(findobj('type','axes'),'fontsize',10)
h_fig = gcf;
set(h_fig,'PaperOrientation','portrait')
set(h_fig,'PaperPosition', [0 0 14 10]) % [... ... max_width = 7.5 max_height = 9]
tit = 'chi-5';
print(tit,'-dtiff','-r400')
movefile([tit,'.tif'],'C:\Users\fy23\Fateme\Projects\Marsh Model\Results\22 - Nondimensional Analysis')
close all

%%
% width and depths vs concentration
Co_ = (10:10:80) *10^-3;

clf

subplot(4,3,1)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_cobfm(i,6,:)),'Linewidth',2)
end
xlabel('Concentration (mg/l)')
ylabel('TF Width (m)')
title('Basin Width')
box on

subplot(4,3,2)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_cobfm(i,7,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Tidal Flat Depth (m)')
title('Basin Width')
box on

subplot(4,3,3)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_cobfm(i,8,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Marsh Depth (m)')
title('Basin Width')
box on

subplot(4,3,4)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_cole(i,6,:)),'Linewidth',2)
end
xlabel('Concentration (mg/l)')
ylabel('TF Width (m)')
title('Estuary Length')
box on

subplot(4,3,5)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_cole(i,7,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Tidal Flat Depth (m)')
title('Estuary Length')
box on

subplot(4,3,6)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_cole(i,8,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Marsh Depth (m)')
title('Estuary Length')
box on

subplot(4,3,7)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_coh(i,6,:)),'Linewidth',2)
end
xlabel('Concentration (mg/l)')
ylabel('TF Width (m)')
title('Tidal Range')
box on

subplot(4,3,8)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_coh(i,7,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Tidal Flat Depth (m)')
title('Tidal Range')
box on

subplot(4,3,9)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_coh(i,8,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Marsh Depth (m)')
title('Tidal Range')
box on

subplot(4,3,10)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_coqf(i,6,:)),'Linewidth',2)
end
xlabel('Concentration (mg/l)')
ylabel('TF Width (m)')
title('River Discharge')
box on

subplot(4,3,11)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_coqf(i,7,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Tidal Flat Depth (m)')
title('River Discharge')
box on

subplot(4,3,12)

hold on
for i = 1 : k
    plot(Co_*1000,squeeze(pi_coqf(i,8,:)),'Linewidth',2)
end
plot([0,100],[.7,.7],'k--')
text(90,.72,'MSL')
xlabel('Concentration (mg/l)')
ylabel('Marsh Depth (m)')
title('River Discharge')
box on

set(findobj('type','axes'),'fontsize',10)
h_fig = gcf;
set(h_fig,'PaperOrientation','portrait')
set(h_fig,'PaperPosition', [0 0 7 7]) % [... ... max_width = 7.5 max_height = 9]
tit = 'Co vs pars';
print(tit,'-dtiff','-r400')
movefile([tit,'.tif'],'C:\Users\fy23\Fateme\Projects\Marsh Model\Results\22 - Nondimensional Analysis')
close all

%%
% width and depths vs concentration
R_ = (1:8);

clf

subplot(4,3,1)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rbfm(i,3,:)),'Linewidth',2)
end
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('TF Width (m)')
title('Basin Width')
box on

subplot(4,3,2)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rbfm(i,4,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Tidal Flat Depth (m)')
title('Basin Width')
box on

subplot(4,3,3)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rbfm(i,5,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Marsh Depth (m)')
title('Basin Width')
box on

subplot(4,3,4)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rle(i,3,:)),'Linewidth',2)
end
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('TF Width (m)')
title('Estuary Length')
box on

subplot(4,3,5)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rle(i,4,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Tidal Flat Depth (m)')
title('Estuary Length')
box on

subplot(4,3,6)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rle(i,5,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Marsh Depth (m)')
title('Estuary Length')
box on

subplot(4,3,7)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rco(i,3,:)),'Linewidth',2)
end
xlabel('Concentration (mg/l)')
ylabel('TF Width (m)')
title('Ocean Concentration')
box on

subplot(4,3,8)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rco(i,4,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Tidal Flat Depth (m)')
title('Ocean Concentration')
box on

subplot(4,3,9)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rco(i,5,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Marsh Depth (m)')
title('Ocean Concentration')
box on

subplot(4,3,10)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rcf(i,3,:)),'Linewidth',2)
end
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('TF Width (m)')
title('River Concentration')
box on

subplot(4,3,11)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rcf(i,4,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Tidal Flat Depth (m)')
title('River Concentration')
box on

subplot(4,3,12)

hold on
for i = 1 : k
    plot(R_,squeeze(pi_rcf(i,5,:)),'Linewidth',2)
end
plot([0,10],[.7,.7],'k--')
text(8,.72,'MSL')
xlabel('Sea Level Rise Rate (mm/yr)')
ylabel('Marsh Depth (m)')
title('River Concentration')
box on

set(findobj('type','axes'),'fontsize',10)
h_fig = gcf;
set(h_fig,'PaperOrientation','portrait')
set(h_fig,'PaperPosition', [0 0 7 7]) % [... ... max_width = 7.5 max_height = 9]
tit = 'R vs pars';
print(tit,'-dtiff','-r400')
movefile([tit,'.tif'],'C:\Users\fy23\Fateme\Projects\Marsh Model\Results\22 - Nondimensional Analysis')
close all