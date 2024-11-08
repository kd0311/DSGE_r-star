clear all;

clc;


load NRI_baseline_euro_area_results.mat;

% saving results hist_decomp            

hist_dec_NR = squeeze(oo_.shock_decomposition(45,:,:))';
hist_dec_RR = squeeze(oo_.shock_decomposition(13,:,:))';
hist_dec_dC = squeeze(oo_.shock_decomposition(20,:,:))';
hist_dec_dI = squeeze(oo_.shock_decomposition(21,:,:))';
 
% Saving results

xlswrite('results_hist_NR.xls',hist_dec_NR);

xlswrite('results_hist_RR.xls',hist_dec_RR);

xlswrite('results_hist_dC.xls',hist_dec_dC);

xlswrite('results_hist_dI.xls',hist_dec_dI);
