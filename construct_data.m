
Excelfile2    = 'Data US and euro area - update 2024.xlsx';
ExcelSheet    = 'Euro area update';
[data, names] = xlsread(Excelfile2,ExcelSheet,'B3:H57');
n_names       = size(names,2);
n_data        = size(data,1);
time          = data(:,1);
beg_est       = time(1);
end_est       = time(end);

% ****************
% Extracting data;
% ****************

data_dc   = data(:,1);
data_di   = data(:,2);
data_q    = data(:,3);
data_R    = data(:,4);
data_h    = data(:,5);
data_pi   = data(:,6);
data_pit  = data(:,7);

data_est = log([ data_dc, data_di, data_q, data_R, data_pi, data_h, data_pit ] );


save('data.mat','data_dc','data_di','data_q','data_R','data_pi','data_h','data_pit','-V6')

clc;