
% ------------------------------------------------------------
% Endogenous variables in the model, including shock processes
% ------------------------------------------------------------

var

y           //  1 output
c           //  2 consumption
I           //  3 investment
k           //  4 capital
rk          //  5 rental rate of capital
w           //  6 real wage
h           //  7 hours worked
lam         //  8 Lagrange multiplier budget constraint
mu          //  9 Lagrange multiplier capital accumulation
csi         // 10 Lagrange multiplier production function in firms optimization
pie         // 11 Inflation (gross)
R           // 12 Nominal interest rate (gross);              
RR          // 13 Real interest rate (gross)
grC         // 14 trend growth rate consumption
grK         // 15 trend growth rate capital
grA         // 16 growth rate labour-augmenting technology shock
grAK        // 17 growth rate investment-specific technology shock
grB         // 18 growth rate labour supply shock
e_C         // 19 preference shock
d_c         // 20 growth rate consumption
d_I         // 21 growth rate investment
d_q         // 22 growth rate relative price investment
d_tfp       // 23 growth rate TFP
pi_t        // 24 inflation target 
data_dc     // 25 observable consumption growth
data_di     // 26 observable investment growth
data_q      // 27 observable relative price investment growth
data_R      // 28 observable nominal interest rate
data_pi     // 29 observable inflation
data_h      // 30 observable hours worked growth
data_tfp    // 31 observable TFP growth
data_pit    // 32 observable inflation target
data_dypot  // 33 observable potential output (growth flexible economy)
y_f         // 34 output flexible price economy
c_f         // 35 consumption flexible price economy
k_f         // 36 capital flexible price economy
grK_f       // 37 growth rate capital flexible price economy
grC_f       // 38 growth rate consumption flexible price economy
I_f         // 39 investment flexible price economy 
h_f         // 40 hours worked flexible price economy
lam_f       // 41 Lagrange multiplier budget constraint flexible price economy
mu_f        // 42 Lagrange multiplier capital accumulation constraint flexible price economy
rk_f        // 43 rentral rate flexible price economy
w_f         // 44 real wage flexible price economy
RR_f        // 45 real rate flexible price economy
d_c_f       // 46 growth rate consumption flexible price economy
d_I_f       // 47 growth rate investment flexible price economy
d_y_f       // 48 growth rate output flexible price economy
y_gap       // 49 output gap 
e_ei        // 50 Shock to marginal efficiency of investment
e_rp        // 51 Shock to risk premium
e_z         // 52 Stationary shock to technology
RR_gap      // 53 Real interest rate gap
;

% ***********************************************
% Exogenous variables, i.e. innovations to shocks
% ***********************************************

varexo 

eps_A     // 1  innovation to labour-augmenting technology shock
eps_B     // 2  innovation to labour supply shock
eps_AK    // 3  innovation to investment-specific technology shock
eps_C     // 4  innovation to preference shock
eps_R     // 5  monetary policy shock           
eps_p     // 6  price mark up shock
eps_pi_t  // 7  innovation to inflation target shock
eps_ei    // 8  innovation to marginal efficiency of investment shock
eps_rp    // 9  innovation to risk premium
eps_z     // 10 innovation to stationary technology shock
;

% ***********************************    
% declare the parameters of the model
% ***********************************

parameters gamma_h gamma_c vi betta alpha delta omega rho_A rho_B rho_C rho_AK rho_rp rho_z kappa_p phi_p phi_y phi_R theta gammaA gammaAK gammaB rho_pi_t piss ind_p rho_ei;

% *********************
% calibrated parameters
% *********************

vi       = 1.5;       % Inverse of labour supply elasticity      
delta    = 0.08;      % Depreciation rate of capital
theta    = 6;         % Elasticity of demand for goods


alpha    = 0.30;      % capital share in production function         
betta    = 1.008;     % Discount factor       

omega    = 5;         % Investment adjustment cost
gamma_h  = 0.505;     % Habit formation in labour
gamma_c  = 0.628;     % Habit formation in consumption

kappa_p  = 20;        % Cost for adjusting prices
ind_p    = 0.0;       % indexation of prices

phi_p    = 2;         % Response to inflation in MP rule
phi_y    = 0.15;      % Response to output growth in MP rule
phi_R    = 0.75;      % Inertia of MP rule

rho_A    = 0.9;       % AR(1) coeff. of growth of labour-augm. tech. shock
rho_B    = 0.5;       % AR(1) coeff. of growth of labour supply shock
rho_C    = 0.99;      % AR(1) coeff. of preference shock
rho_AK   = 0.99;      % AR(1) coeff. of growth of invest.-spec tech. shock
rho_pi_t = 0.0;       % AR(1) coeff. inflation target shock    
rho_ei   = 0.5;       % AR(1) coeff. marginal efficiency of investment shock    
rho_rp   = 0.5;       % AR(1) coeff. risk premium shock    
rho_z    = 0.7;       % AR(1) coeff. stationary technology shock 

gammaA   = 1.011;     % steady state growth rate of labour-augm. tech. shock 
gammaAK  = 1.016;     % steady state growth rate of invest.-spec tech. shock
gammaB   = 1.008;     % steady state growth rate of labour supply shock
piss     = 0.020;     % steady state inflation rate
Rss      = 0.040;     % steady state nominal interest rate (NOT USED)

% *******************
% * Model equations *
% *******************

%*****
model;
%*****
     

exp(y)   = exp(c) + exp(I) - (kappa_p/2) * ( exp(pie) - 1 )^2 * exp(y)                                                                                                                 ; // (L1) Resource constraint



exp(k)   = (1-delta) * exp(k(-1)) / exp(grK) + exp(e_ei) * exp(I) * ( 1 - 0.5 * omega * ( exp(grK) * exp(I) / exp(I(-1)) - exp(steady_state(grK)) )^2 )                                ; // (L2) Capital accumulation



exp(y)   = exp(e_z) * exp(h)^(1-alpha) * ( exp(k(-1)) / exp(grK) )^alpha                                                                                                               ; // (L3) Production function



exp(lam) * exp(mu) = betta * exp(lam(+1)) / ( exp(grC(+1)) * exp(grAK(+1)) ) * ( exp(rk(+1)) + (1 - delta) * exp(mu(+1)) )                                                             ; // (L4) Euler equation       
 


exp(lam) = exp(lam) * exp(mu) * exp(e_ei) * ( 1 - 0.5*omega * (  exp(grK) * exp(I) / exp(I(-1)) - exp(steady_state(grK)) )^2 
            - omega * (  exp(grK) * exp(I) / exp(I(-1)) - exp(steady_state(grK)) ) * (  exp(grK) * exp(I) / exp(I(-1)) ) ) 
            + betta * exp(e_ei(+1)) * ( exp(mu(+1)) * exp(lam(+1)) / (exp(grK(+1))*exp(grC(+1))) )  
            * omega * ( exp(grK(+1)) * exp(I(+1)) / exp(I) - exp(steady_state(grK)) ) * exp(grK(+1))^2 * exp(I(+1))^2 / exp(I)^2                                                       ; // (L5) FOC Investment
 
            
            
exp(lam) * exp(rk) * exp(k(-1))/exp(grK) = alpha * exp(csi) * exp(y)                                                                                                                   ; // (L6) Rental rate of capital      
   


exp(lam) * exp(w) * exp(h)  = (1-alpha) * exp(csi)  * exp(y)    	                                                                                                                   ; // (L7) Real wage      
 


exp(lam) * exp(w) = exp(e_C) * ( exp(h) - gamma_h * exp(h(-1)) / exp(grB) )^(1/vi)                                                                                                                                               

- betta * gamma_h * exp(e_C(+1)) * ( ( exp(h(+1)) - gamma_h * exp(h)/exp(grB(+1)) )^(1/vi) ) * (1 / exp(grB(+1)))                                                                      ; // (L8) Labour supply choice
       


exp(lam)  = exp(e_C) / ( exp(c) - gamma_c * exp(c(-1)) / exp(grC) ) -  exp(e_C(+1)) * betta * gamma_c / ( exp(grC(+1)) * exp(c(+1)) - gamma_c * exp(c) )                               ; // (L9) Lagrange multiplier  



exp(lam)  = betta * ( exp(lam(+1)) / exp(grC(+1)) ) * exp(R) / exp(pie(+1)) - ( exp(e_rp) - 1 )                                                                                        ; // (L10) FOC nominal bond



kappa_p * exp(lam) * ( exp(pie) - exp(pie(-1))^ind_p * exp(pi_t)^(1-ind_p) ) * exp(pie) = (1-theta * (1+eps_p) ) * exp(lam) + theta * (1+eps_p) * exp(csi) +


betta * kappa_p * ( exp(lam(+1)) / exp (grC(+1))) * ( exp(pie(+1)) - exp(pie)^ind_p * exp(pi_t(+1))^(1-ind_p) ) * exp(pie(+1)) * ( exp(y(+1)) / ( exp(y) * exp(grC(+1)) ) )            ; // (L11) Optimal pricing condition



exp(R) = (exp(piss)* exp(steady_state(grC))/betta)^(1-phi_R)*( (( exp(pie)/ exp(pi_t) )^phi_p) * ( exp(y)/( exp(steady_state(y)) ))^phi_y )^(1-phi_R) * exp(R(-1))^(phi_R) + eps_R     ; // (L12) Monetary policy rule



exp(RR)  = exp(R)/exp(pie(+1))                                                                                                                                                         ; // (L13) Real interest rate


% ***********************************************************
% SHOCKS: exogenous trends & other structural shock processes
% ***********************************************************


exp(grA)  = (1-rho_A)  * gammaA    + rho_A  * exp(grA(-1))  + eps_A                                                                                                                    ; // (L14) Technology shock



exp(grB)  = (1-rho_B)  * gammaB    + rho_B  * exp(grB(-1))  + eps_B                                                                                                                    ; // (L15) Labour supply shock    



exp(grAK) = (1-rho_AK) * gammaAK   + rho_AK * exp(grAK(-1)) + eps_AK                                                                                                                   ; // (L16) Investment-specific shock    
        


exp(e_C)  = (1-rho_C)              + rho_C *  exp(e_C(-1))  + eps_C                                                                                                                    ; // (L17) Preference shock    



exp(pi_t) = (1-rho_pi_t)*exp(piss) + rho_pi_t*exp(pi_t(-1)) + eps_pi_t                                                                                                                 ; // (L18) Inflation target shock    



exp(e_ei)  = (1-rho_ei)            + rho_ei * exp(e_ei(-1)) + eps_ei                                                                                                                   ; // (L19) Marginal efficiency investment shock    



exp(e_rp)  = (1-rho_rp)            + rho_rp * exp(e_rp(-1)) + eps_rp                                                                                                                   ; // (L20) Risk premium


exp(e_z)   = (1-rho_z)             + rho_z * exp(e_z(-1)) + eps_z                                                                                                                      ; // (L21) Stationary technology shock    


% *********************************
% Other trends & trending variables
% *********************************


exp(grC)   = exp(grA) * exp(grB) * exp(grAK)^(alpha/(1-alpha))                                                                                                                         ; // (L22) trend growth consumption     
   

exp(grK)   = exp(grA) * exp(grB) * exp(grAK)^(1/(1-alpha))                                                                                                                             ; // (L23) trend growth capital    
    

exp(d_c)   = exp(c) / exp(c(-1)) * exp(grC)                                                                                                                                            ; // (L24) Growth rate of consumption


exp(d_I)   = exp(I) / exp(I(-1)) * exp(grK)                                                                                                                                            ; // (L25) Growth rate of investment


exp(d_tfp) = ( exp(e_z) / exp(e_z(-1)) ) * exp(grA)^(1-alpha)                                                                                                                          ; // (L26) Growth rate of TFP


exp(d_q)   = 1 / exp(grAK)                                                                                                                                                             ; // (L27) Growth rate relative price investment                                                                                                                                                           


% *********************************
% Observables that ARE in the model
% *********************************


data_dc  = exp(d_c)                                                                                                                                                                    ; // (L28) Observable growth rate consumption


data_di  = exp(d_I)                                                                                                                                                                    ; // (L29) Observable growth rate investment


data_q   = exp(d_q)                                                                                                                                                                    ; // (L30) Observable growth rate relative price investment


data_R   = exp(R)                                                                                                                                                                      ; // (L31) Observable nominal interest rate


data_pi  = exp(pie)                                                                                                                                                                    ; // (L32) Observable inflation


data_h   = exp(h) / exp(h(-1)) * exp(grB)                                                                                                                                              ; // (L33) Observable growth rate hours
 

data_tfp = exp(d_tfp)                                                                                                                                                                  ; // (L34) Observable growth rate TFP


data_pit = exp(pi_t)                                                                                                                                                                   ; // (L35) Observable inflation target


% *************************
% ** Flexible price economy
% *************************


exp(y_f)   = exp(c_f) + exp(I_f)                                                                                                                                                       ; // (L36) Flex model: resource constraint



exp(k_f)   = (1-delta) * exp(k_f(-1)) / exp(grK_f) + exp(e_ei) * exp(I_f) * ( 1 - 0.5 * omega * ( exp(grK_f) * exp(I_f) / exp(I_f(-1)) - exp(steady_state(grK_f)) )^2 )                ; // (L37) Flex model: capital accumulation



exp(y_f)   = exp(e_z) * exp(h_f)^(1-alpha) * ( exp(k_f(-1)) / exp(grK_f) )^alpha                                                                                                       ; // (L38) Flex model: production function



exp(lam_f) * exp(mu_f) = betta * exp(lam_f(+1)) / ( exp(grC_f(+1)) * exp(grAK(+1)) ) * ( exp(rk_f(+1)) + (1 - delta) * exp(mu_f(+1)) )                                                 ; // (L39) Flex model: Euler equation       



exp(lam_f) = exp(lam_f) * exp(mu_f) * exp(e_ei) * ( 1 - 0.5*omega * (  exp(grK_f) * exp(I_f) / exp(I_f(-1)) - exp(steady_state(grK_f)) )^2  
            - omega * (  exp(grK_f) * exp(I_f) / exp(I_f(-1)) - exp(steady_state(grK_f)) ) * (  exp(grK_f) * exp(I_f) / exp(I_f(-1)) ) ) 
            + betta * exp(e_ei(+1)) * ( exp(mu_f(+1)) * exp(lam_f(+1)) / (exp(grK_f(+1))*exp(grC_f(+1))) )  
            * omega * ( exp(grK_f(+1)) * exp(I_f(+1)) / exp(I_f) - exp(steady_state(grK_f)) ) * exp(grK_f(+1))^2 * exp(I_f(+1))^2 / exp(I_f)^2                                         ; // (L40) Flex model: FOC Investment
 
            
                      
(theta / (theta - 1)) * exp(rk_f) * exp(k_f(-1))/exp(grK_f) = alpha * exp(y_f)                                                                                                         ; // (L41) Flex model: rental rate of capital      
  


(theta / (theta - 1)) * exp(w_f) * exp(h_f)  = (1-alpha) *  exp(y_f)    	                                                                                                           ; // (L42) Flex model: real wage      
 

 
exp(lam_f) * exp(w_f) = exp(e_C) * ( exp(h_f) - gamma_h * exp(h_f(-1)) / exp(grB) )^(1/vi)                                                              

- betta * gamma_h * exp(e_C(+1)) * ( ( exp(h_f(+1)) - gamma_h * exp(h_f)/exp(grB(+1)) )^(1/vi) ) * (1 / exp(grB(+1)))                                                                  ; // (L43) Flex model: labour supply choice



exp(lam_f)  = exp(e_C) / ( exp(c_f) - gamma_c * exp(c_f(-1)) / exp(grC_f) ) -  exp(e_C(+1)) * betta * gamma_c / ( exp(grC_f(+1)) * exp(c_f(+1)) - gamma_c * exp(c_f) )                 ; // (L44) Flex model: Lagrange multiplier  



exp(lam_f)  = betta * ( exp(lam_f(+1)) / exp(grC_f(+1)) ) * exp(RR_f) - ( exp(e_rp) - 1 )                                                                                              ; // (L45) Flex model: FOC nominal bond


% *********************************
% Other trends & trending variables
% *********************************


exp(grC_f)   = exp(grC)                                                                                                                                                                ; // (L46) Flex model: trend growth consumption     
   

exp(grK_f)   = exp(grK)                                                                                                                                                                ; // (L47) Flex model: trend growth capital    
    

exp(d_c_f)   = exp(c_f) / exp(c_f(-1)) * exp(grC_f)                                                                                                                                    ; // (L48) Flex model: growth rate of consumption


exp(d_I_f)   = exp(I_f) / exp(I_f(-1)) * exp(grK_f)                                                                                                                                    ; // (L49) Flex model: growth rate of investment


exp(y_gap)   = exp(y)/exp(y_f)                                                                                                                                                         ; // (L50) Flex model: growth rate of investment 


exp(d_y_f)   = exp(y_f) / exp(y_f(-1)) * exp(grC_f)                                                                                                                                    ; // (L51) Flex model: growth rate of consumption


data_dypot = exp(d_y_f)                                                                                                                                                                ; // (L52) Flex model: growth rate of investment 


exp(RR_gap)  = exp(RR) / exp(RR_f)                                                                                                                                                     ; // (L53) Definition of real interest rate gap


end;

% *********************************
% ends the declaration of the model
% *********************************

% **************************************************************
% * Set initial conditions for computation of the steady state *
% **************************************************************

initval; 

y          = 1.15739;
c          = 1.0952498;
I          = 0.32789982;
k          = 2.73771;
rk         = -2.53876;
w          = 0.79891853;
h          = -0.0160645; 
lam        = -0.6952498;
mu         = 0;
grA        = 0.005;
grB        = 0.0075;
grAK       = 0.01;
grC        = 0.0175;
e_C        = 0;
pie        = piss;
d_c        = 0.0075;
d_I        = 0.0075;
pi_t       = 0;
R          = Rss;
y_f        = y;
c_f        = c;
I_f        = I;
k_f        = k;
rk_f       = rk;
w_f        = w;
h_f        = h; 
lam_f      = lam;
mu_f       = mu;
grC_f      = grC;
d_c_f      = d_c;
d_I_f      = d_I;
RR_f       = RR;
grK_f      = grK;
grC_f      = grC;
d_y_f      = grC;
grC_f      = d_y_f;
grA        = 0.005;
grB        = 0.0075;
grAK       = 0.01;

end;

% ********************************
% ** Solve for the steady state ** 
% ********************************

opts = optimoptions(@fsolve,'Display','none');

steady(solve_algo=0);

check;

% ****************************
% ***** Set shock variances ** 
% ****************************

shocks;
var eps_A;     stderr  0.01^2;
var eps_B;     stderr  0.01^2;
var eps_C;     stderr  0.01^2;
var eps_AK;    stderr  0.01^2;
var eps_R;     stderr  0.0025^2;
var eps_p;     stderr  0.005^2;
var eps_pi_t;  stderr  0.005^2;
var eps_ei;    stderr  0.005^2;
var eps_rp;    stderr  0.005^2;
var eps_z;     stderr  0.005^2;
end;


% ****************
% ** ESTIMATION **
% ****************

estimated_params;

stderr eps_A      , 0.0103,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_B      , 0.0186,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_AK     , 0.0056,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_C      , 0.0367,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_R      , 0.0119,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_p      , 0.0084,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_pi_t   , 0.0020,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_ei     , 0.5220,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_rp     , 0.0045,  inv_gamma_pdf,     0.0100,   0.05  ;      
stderr eps_z      , 0.0080,  inv_gamma_pdf,     0.0100,   0.05  ;      

rho_A             ,  0.457,       beta_pdf,       0.50,   0.20  ;
rho_B             ,  0.270,       beta_pdf,       0.50,   0.20  ;
rho_AK            ,  0.540,       beta_pdf,       0.50,   0.20  ; 
rho_C             ,  0.810,       beta_pdf,       0.50,   0.20  ;
rho_pi_t          ,  0.770,       beta_pdf,       0.50,   0.20  ;    
rho_ei            ,  0.180,       beta_pdf,       0.50,   0.20  ;
rho_z             ,  0.820,       beta_pdf,       0.50,   0.20  ;
rho_rp            ,  0.770,       beta_pdf,       0.50,   0.20  ;

omega             ,  1.281,      gamma_pdf,       2.00,   0.50  ; 
kappa_p           , 15.430,      gamma_pdf,       20.0,   5.00  ; 
ind_p             ,  0.452,       beta_pdf,       0.50,   0.10  ;
gamma_h           ,  0.505,       beta_pdf,       0.50,   0.025 ;
gamma_c           ,  0.600,       beta_pdf,       0.60,   0.05  ;

phi_R             ,  0.644,       beta_pdf,       0.70,   0.10  ;
phi_p             ,  2.250,     normal_pdf,       2.50,   0.20  ;
phi_y             ,  0.200,     normal_pdf,       0.50,   0.10  ;

gammaA            ,  1.010,     normal_pdf,       1.01,   0.005 ;
gammaAK           ,  1.020,     normal_pdf,       1.02,   0.005 ;
gammaB            ,  1.000,     normal_pdf,       1.00,   0.005 ;
piss              ,  0.023,     normal_pdf,      0.020,   0.005 ;
betta             ,  0.996,     normal_pdf,       1.00,   0.020 ;
alpha             ,  0.260,       beta_pdf,       0.30,   0.025 ;

end;

varobs 
data_dc     % per-capita real consumption growth
data_di     % per-capita real investment growth 
data_q      % relative price of investment growth
data_pi     % inflation
data_pit    % inflation target
data_R      % nominal short-term interest rate
data_h      % total employment (per-capita)
;

        
% **** To do it ALL AT ONCE  **********

estimation(datafile=data
        ,mh_replic  = 100000
        ,mh_nblocks = 1 
        ,mh_drop   = 0.2
        ,mh_jscale = 0.30
%%      ,mode_compute=4
        ,mode_compute = 0 ,mode_file = NRI_baseline_euro_area_mode
        ,order = 1
        ,presample = 0
        ,first_obs = 1
        ,plot_priors = 0
%%        ,moments_varendo
        ,bayesian_irf  
        ,smoother
        ,filtered_vars
        ,sub_draws = 10000
        ) d_c d_I grC grK RR pie R RR_f pi_t
        ;


% *********************************************
% HISTORICAL DECOMPOSITION (w/o NOMINAL shocks)
% *********************************************

close all;

options_.groups{1}={'eps_A'};
options_.groups{2}={'eps_B'};
options_.groups{3}={'eps_AK'};
options_.groups{4}={'eps_C'};
options_.groups{5}={'eps_ei'};
options_.groups{6}={'eps_rp'};
options_.groups{7}={'eps_z'};
options_.labels = char('Labor-augmenting tech.', 'Labour supply', 'IST', 'Discount factor' , 'MEI', 'Risk premium', 'TFP');
shock_decomposition(datafile=data,parameter_set=posterior_mean) RR_f;


% **********************************************
% HISTORICAL DECOMPOSITION (with NOMINAL shocks)
% **********************************************

options_.groups{1}={'eps_A'};
options_.groups{2}={'eps_B'};
options_.groups{3}={'eps_AK'};
options_.groups{4}={'eps_C'};
options_.groups{5}={'eps_ei'};
options_.groups{6}={'eps_rp'};
options_.groups{7}={'eps_z'};
options_.groups{8}={'eps_p','eps_R','eps_pi_t'};
options_.labels = char('Labor-augmenting tech.', 'Labour supply', 'IST', 'Discount factor' , 'MEI', 'Risk premium', 'TFP','Nominal');
shock_decomposition(datafile=data,parameter_set=posterior_mean) RR;

% **********************************************
% HISTORICAL DECOMPOSITION (with NOMINAL shocks)
% **********************************************

options_.groups{1}={'eps_A'};
options_.groups{2}={'eps_B'};
options_.groups{3}={'eps_AK'};
options_.groups{4}={'eps_C'};
options_.groups{5}={'eps_ei'};
options_.groups{6}={'eps_rp'};
options_.groups{7}={'eps_z'};
options_.groups{8}={'eps_p','eps_R','eps_pi_t'};
options_.labels = char('Labor-augmenting tech.', 'Labour supply', 'IST', 'Discount factor' , 'MEI', 'Risk premium', 'TFP','Nominal');
shock_decomposition(datafile=data,parameter_set=posterior_mean) d_I;

% **********************************************
% HISTORICAL DECOMPOSITION (with NOMINAL shocks)
% **********************************************

options_.groups{1}={'eps_A'};
options_.groups{2}={'eps_B'};
options_.groups{3}={'eps_AK'};
options_.groups{4}={'eps_C'};
options_.groups{5}={'eps_ei'};
options_.groups{6}={'eps_rp'};
options_.groups{7}={'eps_z'};
options_.groups{8}={'eps_p','eps_R','eps_pi_t'};
options_.labels = char('Labor-augmenting tech.', 'Labour supply', 'IST', 'Discount factor' , 'MEI', 'Risk premium', 'TFP','Nominal');
shock_decomposition(datafile=data,parameter_set=posterior_mean) d_c;

% *****************************************
% COSMETICS for shock decomposition figures
% *****************************************

initYr            = 1971;
endYr             = 2024;
TickEvery_n_Years = 1/2;
gray_color        = [0.4, 0.4, 0.4];
blue_color        = [0,     0,   1];
black_color       = [0,     0,   0];

clear dates_plot
dates_plot(:,1) = floor((initYr:1:endYr)');
dates_plot(:,2) = repmat([1], (endYr-initYr)+1, 1);

open_figs = get(0,'Children')';
for i = open_figs
    figure(i);
    name_fig = get(gcf,'Name');
    name_fig(strfind(name_fig,':')) = []; % erase semi-colon from name_fig ...
    name_fig = deblank(name_fig);
    name_fig = strrep(name_fig,'.','');

    Child      = get(i,'Children');
    if numel(Child)~=2, continue; end;
    legendAx     = Child(1);
    HistdecompAx = Child(2);
    set(i,'CurrentAxes',HistdecompAx);
    DatesTicks(dates_plot,TickEvery_n_Years,'noqrt');
    lineH          = findobj(HistdecompAx,'LineWidth', 2);
    legendEntriesH = findobj(legendAx,'FontSize', 10);
    set(lineH,'LineWidth',3);
    set(HistdecompAx,   'FontSize',12,'FontWeight','Demi','XColor',black_color,'YColor',gray_color);
    limitsY = ylim; axis tight; ylim(limitsY);
    set(legendEntriesH, 'FontSize',12,'FontWeight','Normal','Color',black_color);
    grid;
    saveas(gcf,name_fig, 'fig')
    saveas(gcf,name_fig, 'pdf')
end;


% ************
% SAVE results 
% ************

FinalMatFilename = 'GeraliNeri_euro_area_full_sample_results.mat';

save(FinalMatFilename, 'oo_', 'M_', 'options_', ...
                       'estim_params_','bayestopt_');
if exist('dataset_', 'var') == 1
  % % % save(FinalMatFilename.mat, 'dataset_', '-append');
  save(FinalMatFilename, 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save(FinalMatFilename, 'estimation_info', '-append');
end

% To save a copy of the diary file, you might have to re-type the following 
% line only AFTER dynare has finished its computations

[success,theMessage] = copyfile('NRI_baseline_euro_area_full_sample.log','GeraliNeri_euro_area_full_sample.log')


% % % estimate_NR = [ oo_.SmoothedVariables.HPDinf.RR_f', oo_.SmoothedVariables.Median.RR_f, oo_.SmoothedVariables.HPDsup.RR_f' ];
estimate_NR = [ oo_.SmoothedVariables.HPDinf.RR_f, oo_.SmoothedVariables.Median.RR_f, oo_.SmoothedVariables.HPDsup.RR_f ];


Excelfile  = 'GeraliNeri_full_sample_results.xlsx';
ExcelSheet = 'NR estimate';
[success,theMessage] = xlswrite(Excelfile, dates_plot(:,1)       ,ExcelSheet,'A2');
[success,theMessage] = xlswrite(Excelfile, {'2.5 HPD','median','97.5 HPD'},ExcelSheet,'B1');
[success,theMessage] = xlswrite(Excelfile,  [estimate_NR] ,ExcelSheet,'B2');
disp(['... done!'])

