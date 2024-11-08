% Replication file #3
%
% Plots of NRI         (Figs 3-4-5-6)
% Hist. decompositions (Figs 9-10-11-12)

clear all
Resultfile = 'GeraliNeri_euro_area_full_sample_results.mat';
Excelfile  = 'GeraliNeri_euro_area_full_sample_results.xlsx';


%% plots of NRI
if isempty(regexp(Resultfile,'euro_area'))
    ExcelSheet = 'US_nri_figs'
else
    ExcelSheet = 'EA_nri_figs'
end
load(Resultfile)

RR     = oo_.SmoothedVariables.Mean.RR;
RR_f   = oo_.SmoothedVariables.Mean.RR_f;
RR_gap = RR - RR_f;

initYear = 1971;
endYear  = 2016;
clear dates_plot
dates_plot(:,1) = floor((initYear:1:endYear)');
dates_plot(:,2) = repmat([1], (endYear-initYear)+1, 1);
TickEvery_n_Years = 2;
gray_color  = [0.4, 0.4, 0.4];
blue_color  = [0.4, 0.4, 1];
black_color = [0, 0, 0];

figure;
plot(RR,          'LineWidth',3,'Color',blue_color)
hold on;grid on
plot(RR_f, 'r--', 'LineWidth',3)
DatesTicks(dates_plot,TickEvery_n_Years,'long');
limitsY = ylim; axis tight; ylim(limitsY); % to compress ONLY the Xaxis
set(gca,'FontSize',12,'FontWeight','Demi','XColor',gray_color,'YColor',gray_color);

figure;
plot(RR_gap, 'LineWidth',3)
hold on;grid on
DatesTicks(dates_plot,TickEvery_n_Years,'long');
limitsY = ylim; axis tight; ylim(limitsY); % to compress ONLY the Xaxis
set(gca,'FontSize',12,'FontWeight','Demi','XColor',gray_color,'YColor',gray_color);




% write it on Excel
disp(['... writing data to Excel ... please wait!'])
[success,theMessage] = xlswrite(Excelfile, dates_plot(:,1)       ,ExcelSheet,'A2');
[success,theMessage] = xlswrite(Excelfile, {'RR','RR_f','RR_gap'},ExcelSheet,'B1');
[success,theMessage] = xlswrite(Excelfile,  [RR,  RR_f,  RR_gap] ,ExcelSheet,'B2');
disp(['... done!'])


%% Historical decompositions
if isempty(regexp(Resultfile,'euro_area'))
    ExcelSheet = 'US_histdecomp'
else
    ExcelSheet = 'EA_histdecomp'
end
% load(Resultfile)

