%% This script computes power spectra of variables ...
%
% Dynare soln. is:   yh(t) = y_ss + A*yh(t-1) + B*u(t) (see sect. 4.13.3 manual) 
% I neeed to split vector yh(t) in two parts: states (X) and everything else (J):
%
%	X(t)  =  A1*X(t-1) +  B1*u(t)
%	J(t)  =  A2*X(t-1) +  B2*u(t)


%% 1. load objects and decide which parametrization ....
clear all
% load ('NRI_baseline_euro_area_results.mat')
load ('GeraliNeri_euro_area_full_sample_results.mat');
parameters = get_posterior_parameters('mean');
M_ = set_all_parameters(parameters,estim_params_,M_);


%% 2. run 'stoch_simul' to get the correct parameters in oo_.dr  
options_.irf = 0;
options_.nograph = 1;
options_.nomoments = 1;
options_.noprint = 1;
options_.order = 1;
options_.periods = 0;
options_.irf_shocks = 'eps_A';
var_list_ = 'y';
info = stoch_simul(var_list_);


%% 3. extract objects from oo_.dr ...
y_ss      = oo_.dr.ys;
Adyn      = oo_.dr.ghx;
Bdyn      = oo_.dr.ghu;
Sigma2_u  = M_.Sigma_e;
Sigma_u   = chol(M_.Sigma_e);
ShockNames = cellstr(M_.exo_names);
% state_var = oo_.dr.state_var; %in declaration order
% state_nbr = numel(state_var);
% order_var = oo_.dr.order_var;


%% 4. construct matrices for the state-space representation ...
A1 = oo_.dr.Gy; % squared matrix (nspred x nspred) for the state dynamics
% my_A1 = Adyn(M_.nstatic+(1:M_.nspred),:);
% if norm(my_A1 - A1) > eps*norm(A1), error('... something wrong ...'); end

A2_part1 = Adyn(1:M_.nstatic,:);
A2_part2 = Adyn(M_.nstatic+M_.nspred+(1:M_.nfwrd),:);
A2 = [A2_part1; A2_part2];

B1 = Bdyn(M_.nstatic+(1:M_.nspred),:);

B2_part1 = Bdyn(1:M_.nstatic,:);
B2_part2 = Bdyn(M_.nstatic+M_.nspred+(1:M_.nfwrd),:);
B2 = [B2_part1; B2_part2];

% create varNames array for the vars inside J(t)
varNamesJ = [];
varNames_do = cellstr(M_.endo_names); % varnames in Declaration Order
varNamesJ =[varNamesJ; varNames_do(oo_.dr.order_var(1:M_.nstatic))]; % static vars
varNamesJ =[varNamesJ; varNames_do(oo_.dr.order_var(M_.nstatic+M_.nspred+1: end ))];% frwd vars

%% 5. compute  spectra (for each str. shock & overall) 
clear Spectra 
Nfreq=100;
% freq = linspace(0,pi,Nfreq+1); freq(1)=[];
freq = linspace(0,pi,Nfreq);
Tsys = ss(A1,B1*Sigma_u,A2,B2*Sigma_u,-1); % define the LTI system 
G    = freqresp(Tsys,freq); % frequency response of the system
% compute spectra from the freq. response
GG = squeeze(G);
spectra = GG.*conj(GG);
spectra(:,end+1,:) = squeeze(sum(spectra,2));
spectra = permute(spectra,[3 1 2]);
spectra = circshift(spectra,[0, 0, 1]);% move sum to the top


%% 8. save results to Excel ...
% Excelfile   = 'spectral_decomp_perc_Mlb_euro_area.xlsx';
% 
% disp(['... writing data to Excel ... please wait!'])
% [success,theMessage] = xlswrite(Excelfile,['freq.',varNamesJ'], 'total','A1');
% [success,theMessage] = xlswrite(Excelfile,freq',                'total','A2');
% [success,theMessage] = xlswrite(Excelfile,spectra(:,:,1),       'total','B2');
% 
% for sk=1:M_.exo_nbr,
%     ExcelSheet  = ShockNames{sk}
%     [success,theMessage] = xlswrite(Excelfile,['freq.',varNamesJ'], ExcelSheet,'A1');
%     if not(success), error(theMessage); end;
%     [success,theMessage] = xlswrite(Excelfile,freq',                ExcelSheet,'A2');
%     if not(success), error(theMessage); end;
%     [success,theMessage] = xlswrite(Excelfile,spectra(:,:,sk+1),    ExcelSheet,'B2');
%     if not(success), error(theMessage); end;
% end%for 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Excelfile   = 'spectral_decomp_perc_Mlb_euro_area.xlsx';

spectra_perc        = zeros(Nfreq, M_.nstatic+M_.nfwrd , M_.exo_nbr);
spectra_perc(:,:,1) = spectra(:,:,1);

disp(['... writing data to Excel ... please wait!'])
Excelfile
[success,theMessage] = xlswrite(Excelfile,['freq.',varNamesJ'], 'total','A1');
[success,theMessage] = xlswrite(Excelfile,freq',                'total','A2');
[success,theMessage] = xlswrite(Excelfile,spectra(:,:,1),       'total','B2');

for sk=1:M_.exo_nbr,
    
    spectra_perc(:,:,sk+1) = 100 * spectra(:,:,sk+1) ./ spectra(:,:,1);
     
    ExcelSheet  = ShockNames{sk}
    [success,theMessage] = xlswrite(Excelfile,['freq.',varNamesJ'],   ExcelSheet,'A1');
    if not(success), error(theMessage); end;
    [success,theMessage] = xlswrite(Excelfile,freq',                  ExcelSheet,'A2');
    if not(success), error(theMessage); end;
    [success,theMessage] = xlswrite(Excelfile,spectra_perc(:,:,sk+1), ExcelSheet,'B2');
    if not(success), error(theMessage); end;
end%for 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['... done!'])


%% plot results ...
freq_or_period =  'freq' ;% 'freq' or 'period' 
var_to_plot    =  'RR_f';
sk_to_plot     =  'eps_rp';% 'eps_R' 'eps_p' 'eps_ei'

figure;
set(gcf,'Name',['Freq. decompostion of variance'])
 switch lower(freq_or_period),
     case 'freq',
         xlabel = 'Frequencies';
         xticknums = pi*(0:4)/4;
         xticklabels = {'0' 'pi/4' 'pi/2' '3/2pi' 'pi'};
     case 'period',
         xlabel = 'Periods';
         periods = (2*pi)./freq;
         periods_n = 10;
         xticknums = linspace(freq(1),freq(end),periods_n);
         periods_ticks = linspace(periods(1),periods(end),periods_n);
         xticklabels = {num2str(periods_ticks')};
 end%switch
 
plot(freq, spectra_perc(:,strcmp(varNamesJ,var_to_plot), 1+find(strcmp(ShockNames,sk_to_plot))) ,'r')
set(gca,'Xticklabel',xticklabels,'Xtick',xticknums);
title(['Proportion of total variance of ',var_to_plot,' explained by ''',sk_to_plot,''' by ',freq_or_period,'.'],'Interpreter','none')

disp('done')


%% 9. plotting ALL variables ..
vars_to_plot  = [18:20];
vars_to_plot  = [18];
N_plots       = numel(vars_to_plot);
% N_plots       = M_.endo_nbr;
[prows,pcols] = arrange_plots(N_plots);

clear settings
settings.plottype    = 'spectra';
settings.thin_lines  = 2;
settings.thick_lines = 3;
settings.small_fonts = 9;
settings.big_fonts   = 11;
settings.texnames    = 0;
settings.boxoff      = 0;


 switch lower(freq_or_period),
     case 'freq',
         xlabel = 'Frequencies';
         xticknums = pi*(0:4)/4;
         xticklabels = {'0' 'pi/4' 'pi/2' '3/2pi' 'pi'};
     case 'period',
         xlabel = 'Periods';
         periods = (2*pi)./freq;
         periods_n = 10;
         xticknums = linspace(freq(1),freq(end),periods_n);
         periods_ticks = linspace(periods(1),periods(end),periods_n);
         xticklabels = {num2str(periods_ticks')};
 end%switch

 figure;
 ii=0;
 for v = vars_to_plot,
     ii=ii+1;
     settings.title = varNamesJ(v);
     y_data = squeeze(spectra(:,v,:));
     y_data = squeeze(spectra_perc(:,v,:));
     if ii==N_plots,
         settings.legend  = ['all';ShockNames];
     end%if
    plotnserie(prows,pcols,ii,y_data,freq,settings);
end%for i


