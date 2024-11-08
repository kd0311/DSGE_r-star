% Replication file #1
%
% Creates the Tables with prior & posterior statistics


clear all
Resultfile = 'GeraliNeri_euro_area_full_sample_results.mat';
Excelfile  = 'GeraliNeri_euro_area_full_sample_results.xlsx';


%%
if isempty(regexp(Resultfile,'euro_area'))
    ExcelSheet = 'US_params'
else
    ExcelSheet = 'EA_params'
end
load(Resultfile)
EParamNames = M_.param_names(estim_params_.param_vals(:,1),:);
EExoNames   = M_.exo_names  (estim_params_.var_exo(:,1),:);
EStdNames   = [repmat('sigma',[size(EExoNames,1),1]),EExoNames(:,4:end)];

NumParams = size(EParamNames,1);
NumStd    = size(EExoNames,1);

PriorTypeCodes_params = estim_params_.param_vals(:,5);
PriorTypeCodes_std    = estim_params_.var_exo(:,5);

PriorType_params = cell(NumParams,1);
PriorType_std    = cell(NumStd,1);

for p = 1:numel(PriorTypeCodes_params)
    prior_this_param = PriorTypeCodes_params(p);
    switch prior_this_param
        case 1,
            PriorType_params{p} = 'beta';
        case 2,
            PriorType_params{p} = 'gamma';
        case 3,
            PriorType_params{p} = 'normal';
        case 4,
            PriorType_params{p} = 'inverse gamma';
    end%switch
end%for

for p = 1:numel(PriorTypeCodes_std)
    prior_this_std = PriorTypeCodes_std(p);
    switch prior_this_std
        case 1,
            PriorType_std{p} = 'beta';
        case 2,
            PriorType_std{p} = 'gamma';
        case 3,
            PriorType_std{p} = 'normal';
        case 4,
            PriorType_std{p} = 'inverse gamma';
    end%switch
end%for

PriorMean_params = oo_.prior.mean(NumStd+1:end);
PriorMean_std    = oo_.prior.mean(1:NumStd);

priors_std = sqrt(diag(oo_.prior.variance));
PriorStd_params = priors_std(NumStd+1:end);
PriorStd_std    = priors_std(1:NumStd);


PostMean_params = struct2cell(oo_.posterior_mean.parameters);
PostMean_std    = struct2cell(oo_.posterior_mean.shocks_std);

PosthpdInf_params = struct2cell(oo_.posterior_hpdinf.parameters);
PosthpdInf_std    = struct2cell(oo_.posterior_hpdinf.shocks_std);


PosthpdSup_params = struct2cell(oo_.posterior_hpdsup.parameters);
PosthpdSup_std    = struct2cell(oo_.posterior_hpdsup.shocks_std);


table_params = [cellstr(EParamNames), PriorType_params, num2cell(PriorMean_params), ...
                num2cell(PriorStd_params), PostMean_params, PosthpdInf_params, PosthpdSup_params];
table_std = [cellstr(EStdNames), PriorType_std, num2cell(PriorMean_std), ...
                num2cell(PriorStd_std), PostMean_std, PosthpdInf_std, PosthpdSup_std];

FinalTable = [table_params(9:end,:); ...
              table_params(1:8,:);  ...
              table_std]

% write it on Excel
disp(['... writing data to Excel ... please wait!'])
[success,theMessage] = xlswrite(Excelfile,{'Param name','Prior type','Prior mean','Prior std',...
                  'Posterior mean','Posterior HPD_inf','Posterior HPD_sup'},ExcelSheet,'A1');
[success,theMessage] = xlswrite(Excelfile,FinalTable, ExcelSheet,'A2');
% [success,theMessage] = xlswrite(Excelfile,freq',                'total','A2');
% [success,theMessage] = xlswrite(Excelfile,spectra(:,:,1),       'total','B2');

disp(['... done!'])


