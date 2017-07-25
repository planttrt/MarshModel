function data = CriticalInitialWidth_c
% Function CriticalInitialWidth looks for a critical fetch value based on
% different system chracteristics using the same method as BoxModel.m.
% Output:
%           8 saved data matrices related to 8 parameters including:
%           1st col: parameter value (SI)
%           2nd col: critical width (m)
%           3rd col: final tidal flat depth (m)
%           4th col: final marsh depth (m)
%           5th col: equlibrium in tidal flat depth (logical)
%           6th col: equlibrium in marsh depth (logical)
%           7th col: platform conversion (0: none, 1:tidal flat emergence & expansion,
%                    2:tidal flat emergence & contraction, 3: marsh drowning & expansion,
%                    4:drowning & contraction)
%
% To plot the results, use the function plot_initialwidth.
%
% Last Update: 7/24/2017
%
%--------------------------------------------------------------------------------------------------
format compact
format longG
clear
% clf

par_temp = 1 : 8;

for k = 1 : 1
    
    k
    %-------------- Set the time span
    tyr = 500;  % solve for time tyr (years)
    ts = tyr *365*24*60*60; % tyr in (s)
    dt = 12*60*60; % time step in (s)
    tspan = 0:dt:ts;
    
    %-------------- Sediment input constants
    C_o = 20 *10^-3;    % ocean concertation (kg/m3)
    C_f = 15 *10^-3;    % river concentration (kg/m3)
    Q_f = 20;         % river water discharge (m3/s)
    
    %-------------- Erosion constants
    k_0 = 1 *10^-3; % roughness (m)
    tau_c = 0.3;  % critical shear stress (Pa)
    E_0 = 10^-4;    % bed erosion coefficient (kg/m2/s)
    k_e = 0.16 /365/24/60/60;  % margin erodibility coefficient (m2/s/W)
    v_w = 6;        % reference wind speed (m/s)
    
    % -------------- Accretion constants
    k_a = 2;        % margin accretion coefficient
    
    %-------------- Vegetation properties
    B_max = 1;      % maximum biomass density (kg/m2)
    k_B = 2*10^-3 /365/24/60/60;    % vegetation characteristics (m3/s/kg)
    
    %-------------- Basin properties
    b_fm = 10 *10^3; % total basin width (both sides of the channel) (m)
    L_E = 10 *10^3; % basin length (m)
    R = 2 *10^-3/365/24/60/60;   % sea level rise (m/s)
    b_r = 0; % river width (m)
    
    %-------------- Tide Characteristics
    T_T = 12 *60*60;   % tidal period (s) (= 12 hours)
    H = 1.4 /2;          % tidal amplitude (range/2) (m)
    
    %-------------- Sediment properties
    rho_s = 1000;   % sediment bulk density (kg/m3)
    omega_s = 0.5 *10^-3;   % settling velocity (m/s)
    
    %-------------- Model constants
    gamma = 9800;   % water specific weight (N/m3)
    
    %-------------- Model assumptions
    Q_f = Q_f/2;    % consider half of the discharge only for one side of the tidal platform (the same will be automatically considered below for Q_T)
    % b_fm = b_fm/2;  % consider half of the basin only for one side of the tidal platform
    
    %-------------- Start the loop for each run
    par = par_temp(k);
    switch par
        case 1
            par_v = 5 *10^-3 : 5 *10^-3 : 100 *10^-3; % for C_o
            TF_width = 10 : 10 : b_fm-10;
        case 2
            par_v = 0 *10^-3: 50 *10^-3 : 1000 *10^-3; % for C_f
            TF_width = 5 : 5 : b_fm-5;
        case 3
            par_v = 0 : 100  : 1000; % for Q_f
            TF_width = 5 : 5 : b_fm-5;
        case 4
            par_v = 1 *10^3 : 2 *10^3 : 20 *10^3; % for L_E
            TF_width = 1 : 1 : b_fm-1;
        case 5
            par_v = 1 *10^3 : 2 *10^3 : 20 *10^3; % for b_fm
        case 6
            par_v = 0 : 2 : 20; % for v_w
            TF_width = 10 : 10 : b_fm-10;
        case 7
            par_v = 0 : 2 *10^-3/365/24/60/60 : 30 *10^-3/365/24/60/60; % for R
            TF_width = 5 : 5 : b_fm-5;
        case 8
            par_v = (1 : 1 : 10)/2; % for H
            TF_width = 5 : 5 : b_fm-5;
    end
    
    for j = 1 : length(par_v)
        
        j
        switch par
            case 1
                C_o = par_v(j);
            case 2
                C_f = par_v(j);
            case 3
                Q_f = par_v(j)/2;
            case 4
                L_E = par_v(j);
            case 5
                b_fm = par_v(j);
                TF_width = 1 : 1 : b_fm-1;
            case 6
                v_w = par_v(j);
            case 7
                R = par_v(j);
            case 8
                H = par_v(j);
        end
        
        if j == 1
        data = zeros(length(par_v),5);
        end
        clear y t width_diff

        for i = 1 : length(TF_width)
            
            i
            %-------------- Initial conditions, y0=[ b_f, d_f, d_m,u(=C_r*(b_f*d_f+b_m*d_m))]
            y0(1) = TF_width(i);
            y0(2) = H+0.3;         % tidal flat depth (m)
            y0(3) = H-0.3;         % marsh depth (m)
            y0(4) =C_o*(y0(1)*y0(2)+(b_fm-y0(1))*y0(3)); % u
            
            %-------------- Solve the system of differential equations
            [t, y] = ode15s(@ode4marshtidalflat,tspan,y0); % or use ode15s/ode23s/ode23tb
            t = t /365/24/60/60; % convert time unit from s to yr for plotting purposes
            y(:,4) = y(:,4)./(y(:,1).*y(:,2)+y(:,3).*(b_fm-y(:,1))); % convert y(:,4) to C_r from the formula used before: y4=u (=C_r*(b_f*d_f+b_m*d_m)
            
            %-------------- Removing data corresponding to platform conversion
            ind = find(y(:,3)>H); % marsh conversion to tidal flat
            if ~isempty(ind) && length(ind)>1
                y(ind(2):end,:)=[]; % retain only one value afetr conversion to remember it is a new tidal flat now
                t(ind(2):end,:)=[];
            end
            
            ind = find(y(:,2)<=H); % tidal flat conversion to marsh
            if ~isempty(ind) && length(ind)>1
                y(ind(2):end,:)=[]; % retain only one value afetr conversion to remember it is a new marsh now
                t(ind(2):end,:)=[];
            end
            
            %-------------- Check tidal flat contraction/expansion
            width = y(:,1); % tidal falt width solution
            n = length(width);
            
            width_diff(i) = sign(width(n)-width(floor(n/2))); % -1 corresponds to tidal flat contraction (or fully marsh) and +1 accounts for expansion (or fully tidal flat)
            
            %-------------- Check emergence, drowning and reaching to boundary limits
            if y(end,2) <= H % check whether if tidal flat has emerged above MSL
                width_diff(i) = -1;
            end
            
            if width(n) >= b_fm % check whether if tidal flat has reached to its boundary limits
                width_diff(i) = 1;
            elseif width(n) <= 0
                width_diff(i) = -1;
            end
            
            if y(end,3) > H % check whether if marsh has been drowned
                width_diff(i) = 1;
            end
            
            %-------------- Evaluate the solutions
            n_width_diff = length(unique(width_diff));
            tidalflatd = y(floor(9*n/10):n,2);
            marshd = y(floor(9*n/10):n,3);
            depth(i,1:2) = [y(end,2),y(end,3)];
            
            if n_width_diff == 2 || (i == length(TF_width) && unique(width_diff) == 1) || (i == length(TF_width) && unique(width_diff) == -1)
                
%                 figure(2)
%                 clf
%                 plot_BoxModel(t,y)
                
                if n_width_diff == 2 % recording critical width
                    data(j,1) = width(1);
                elseif i == length(TF_width) && unique(width_diff) == 1
                    data(j,1) = TF_width(1);
                elseif i == length(TF_width) && unique(width_diff) == -1
                    data(j,1) = TF_width(end);
                end
                
                data(j,2) = y(end,2); % recording tidal flat depth
                data(j,3) = y(end,3); % recording marsh depth
                
                if abs(max(tidalflatd)-min(tidalflatd)) < 1e-3
                    data(j,4) = 1; % tidal flat reached to an equilibrium depth
                end
                
                if abs(max(marshd)-min(marshd)) < 1e-3
                    data(j,4) = 2;  % marsh reached to an equilibrium depth
                end
                
                if abs(max(tidalflatd)-min(tidalflatd)) < 1e-3 && abs(max(marshd)-min(marshd)) < 1e-3
                    data(j,4) = 3;  % both tidal flat and marsh reached to an equilibrium depth
                end
                
                if depth(i-1,1) <= H % tidal flat emergence
                    if width_diff(end) == 1
                        data(j,5) = 1; % tidal flat emergence & expansion
                    elseif width_diff(end) == -1
                        data(j,5) = 2; % tidal flat emergence & contraction
                    end
                end
                
                if depth(i,2) >= H % marsh drowning
                    if width_diff(end) == -1 % marsh drowning & expansion
                        data(j,5) = 3;
                    elseif width_diff(end) == 1 % marsh drowning & contraction
                        data(j,5) = 4;
                    end
                end
                
                break
                
            end
            
        end
        
    end
    
    %-------------- Save the results
    dat = [par_v', data];
    
    switch par
        case 1
            save('co_data.mat','dat')
        case 2
            save('cf_data.mat','dat')
        case 3
            save('qf_data.mat','dat')
        case 4
            save('le_data.mat','dat')
        case 5
            save('bfm_data.mat','dat')
        case 6
            save('vw_data.mat','dat')
        case 7
            save('R_data.mat','dat')
        case 8
            save('H_data.mat','dat')
    end
    
    clear data dat
    
end

%======================= Nested Function =========================
    function dy = ode4marshtidalflat (t,y) %  y1=b_f, y2=d_f, y3=d_m, y4=u (=C_r*(b_f*d_f+b_m*d_m, why solving u instead of C_r? u is the variable on the left hand side of mass conservation equation.)
        % solves the ODE system of equations
        
        %-------------- Setting width boundary limits
        local = y(1); % imposing a constraint for lower and upper limits of y(1)
        if (local < 0)
            local = 0 ;
        end
        if (local > b_fm)
            local = b_fm ;
        end
        
        %-------------- Imposing a condition for tidal flat conversion to marsh in case of presence of new vegetation when tidal flat is above MSL
        flag_f2m = 0;     % showing that tidal flat is below MSL
        if y(2) <= H
            flag_f2m = 1; % showing that tidal flat is above MSL
        end
        
        %-------------- Model assumptions
        b_m = b_fm-local; % marsh width
        if flag_f2m == 0
            chi = 2*local+b_r;    % fetch
        elseif flag_f2m == 1
            chi = b_r;
        end
        
        %---------------------------------- Define the equations -----------------------------------
        
        
        %---------------------------- Tidal flat width changes equation ----------------------------
        
        %-------------- Compute margin erosion (m/s)
        h = (y(2)+max(0,y(2)-2*H))/2;     % reference water depth
        
        if  flag_f2m==1 || chi<=b_r || v_w==0 % condition for no bed and margin erosion in case of a filled mudflat or no wind
            tau = 0; % bed shear stress
            W = 0;   % wave power density
        else
            [ H_w, T_w ] = WaveProps ( h, v_w, chi);   % compute significant height and peak period
            [ tau, k_w ] = ShearStress ( h, k_0, H_w, T_w);     % compute bed shear stress
            % c_g = sqrt(g*h);        % wave group velocity (shallow water)
            c_g = pi/k_w/T_w*(1+2*k_w*h/sinh(2*k_w*h)); % wave group velocity (general form)
            W = gamma*c_g*H_w^2/16; % wave power density (kg.m/s3)
        end
        
        B_e = k_e*W;    % margin erosion
        
        %-------------- Compute margin accretion (m/s)
        C_r = y(4)/(local*y(2)+b_m*y(3)); % concentration (kg/m3)
        
        if flag_f2m == 0
            B_a = k_a*omega_s*C_r/rho_s;  % margin accretion
        else
            B_a = 0;
        end
        
        %-------------- Describe the equation for b_f (m)
        dy(1,1) = B_e - B_a;
        
        if (y(1) < 0 && dy(1,1) < 0) % imposing a constraint for boundary limits of b_f (or y(1))
            dy(1,1) = 0 ;
        end
        if (y(1) > b_fm && dy(1,1) > 0)
            dy(1,1) = 0 ;
        end
        
        
        %----------------------------- Tidal flat depth changes equation ---------------------------
        if flag_f2m == 0
            
            %-------------- Compute submerged time when the tidal flat is covered with water
            if y(2) < 2*H
                t_s = 1/2-1/pi*asin((H-y(2))/H);
            else
                t_s = 1;
            end
            
            %-------------- Compute the rate of bed erosion (m/s)
            TF_erosion = max(0,t_s*E_0/rho_s*(tau-tau_c)/tau_c);
            
            %-------------- Compute the rate of sediment accretion (m/s)
            TF_accretion = min(t_s*C_r*omega_s/rho_s ,C_r*y(2)/T_T/rho_s);
            
            %-------------- Compute the rate of organic matter production in tidal flat (m/s)
            SOM = 0;
            
        elseif flag_f2m == 1
            
            %-------------- Compute the rate of bed erosion (m/s)
            TF_erosion = 0;
            
            %-------------- Compute the rate of sediment accretion (m/s)
            TF_accretion = C_r*y(2)/T_T/rho_s;
            
            %-------------- Compute the rate of organic matter production in the new marsh (m/s)
            z_new = H-y(2);       % elevation of marsh platform
            r_new = -0.5*z_new/H+1;     % reproduction rate
            m_new = 0.5*z_new/H;         % mortality rate
            B_new = B_max*(1-m_new/r_new);  % steady state solution for biomass (kg/m2)
            SOM = k_B*B_new;        % organic matter production rate
            
        end
        
        %-------------- Describe the equation for d_f (m)
        dy(2,1) = TF_erosion - TF_accretion - SOM + R;
        
        
        %----------------------------- Marsh depth changes equation ------------------------------
        
        %-------------- Compute the rate of sediment accretion (m/s)
        M_accretion = C_r*y(3)/T_T/rho_s;
        
        %-------------- Compute organice matter production (m/s)
        z = H-y(3);       % elevation of marsh platform
        if z >= 0           % condition for presence of vegetation when marsh is above MSL
            r = -0.5*z/H+1;     % reproduction rate
            m = 0.5*z/H;         % mortality rate
            B = B_max*(1-m/r);  % steady state solution for biomass (kg/m2)
            O = k_B*B;            % organic matter production rate
        else
            O = 0;
        end
        
        %-------------- Describe the equation for d_m (m)
        dy(3,1) = - M_accretion - O + R;
        
        %-------------------------------- Mass conservation equation ------------------------------
        
        %-------------- Compute tidal flat bed erosion (kg/s)
        if flag_f2m == 0
            bed_erosion = max(0,t_s*E_0*(tau-tau_c)/tau_c*local*L_E);
        else
            bed_erosion = 0;
        end
        
        %-------------- Compute marsh/tidal flat margin erosion/accretion (kg/s)
        if flag_f2m == 0
            margin = (B_e - B_a)*(y(2)-y(3))*L_E*rho_s;
        else
            margin = 0;
        end
        
        %-------------- Compute external sediment input (kg/s)
        Q_T = (y(2)*local+y(3)*b_m)*L_E/T_T-Q_f;
        ocean_in = Q_T*C_o;
        river_in = Q_f*C_f;
        
        %-------------- Compute deposition on tidal flat (kg/s)
        if flag_f2m == 0
            TF_deposition = min(t_s*C_r*local*omega_s*L_E, C_r*local*y(2)*L_E/T_T);
        else
            TF_deposition = C_r*local*y(2)*L_E/T_T;
        end
        
        %-------------- Compute deposition on marsh (kg/s)
        M_deposition = C_r*b_m*y(3)*L_E/T_T;
        
        %-------------- Compute export sediment to the ocean (kg/s)
        if flag_f2m == 0
            export = C_r*local*min(y(2),2*H)*L_E/T_T;
        else
            export = 0;
        end
        
        %-------------- Describe the equation for C_r (kg/m3)
        var = bed_erosion + margin + ocean_in + river_in - TF_deposition - M_deposition - export;   % (kg/s)
        dy(4,1) =  var / L_E;
        
    end

end