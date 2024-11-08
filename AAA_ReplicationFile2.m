% Replication file #2
%
% IRFS numbers in the paper (Figs. 1-2)


clear all
Resultfile = 'GeraliNeri_euro_area_full_sample_results.mat';
Excelfile  = 'GeraliNeri_euro_area_full_sample_results.xlsx';


%% IRFS
if isempty(regexp(Resultfile,'euro_area'))
    ExcelSheet = 'US_irfs'
else
    ExcelSheet = 'EA_irfs'
end
load(Resultfile)
shocks  = {'eps_A', 'eps_rp', 'eps_C', 'eps_ei'};
vars    = {'RR_f','RR','d_c','d_I'};
irfsdata= NaN(40,5,numel(shocks));

figure;
for sh = 1:numel(shocks)
    plH=subplot(2,4,sh);
    irfsdata(:,1,sh) = oo_.PosteriorIRF.dsge.Mean.([vars{1},'_',shocks{sh}]);
    irfsdata(:,2,sh) = oo_.PosteriorIRF.dsge.Mean.([vars{2},'_',shocks{sh}]);
    irfsdata(:,3,sh) = oo_.PosteriorIRF.dsge.Mean.([vars{2},'_',shocks{sh}]) - ...
                       oo_.PosteriorIRF.dsge.Mean.([vars{1},'_',shocks{sh}]);
    irfsdata(:,4,sh) = oo_.PosteriorIRF.dsge.Mean.([vars{3},'_',shocks{sh}]);
    irfsdata(:,5,sh) = oo_.PosteriorIRF.dsge.Mean.([vars{4},'_',shocks{sh}]);
               
    plot(irfsdata(1:10,1,sh), 'b--','LineWidth',3)
    hold on;grid on
    plot(irfsdata(1:10,2,sh), 'r--','LineWidth',3)
    plot(irfsdata(1:10,3,sh), 'g',  'LineWidth',3)
    title(shocks{sh},'Interpreter','none')
    legend([vars(1:2),'gap'])
  
    subplot(2,4,4+sh);
    hold on; grid on
    plot(irfsdata(1:10,4,sh), 'b--','LineWidth',3)
    plot(irfsdata(1:10,5,sh), 'r--','LineWidth',3)
    legend(vars(3:4))  
end;%for

% write it on Excel
disp(['... writing data to Excel ... please wait!'])
cols = {'A','F','K','P','U'}
for sh = 1:numel(shocks)
    disp(shocks(sh))
    [success,theMessage] = xlswrite(Excelfile, {shocks{sh}}   ,ExcelSheet               ,[cols{sh},'1']);
    [success,theMessage] = xlswrite(Excelfile, [vars(1:2),'RR_gap',vars(3:4)],ExcelSheet,[cols{sh},'2']);
    [success,theMessage] = xlswrite(Excelfile, irfsdata(:,:,sh),ExcelSheet              ,[cols{sh},'3'])
end
disp(['... done!'])
