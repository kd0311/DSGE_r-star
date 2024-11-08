function  plotnserie(prows,pcols,i,y_matrix,x_vector,settings)
% general purpose function for plotting n time series together

%read the following fields from settings:
%       legend      ->  plotlegend
%       title       ->  plottitle
%       ylabel      ->  y_label
%       xlabel      ->  x_label
%       xticklabels ->  x_ticklabels
%       xticknums   ->  x_ticknums
%       linewidth   ->  lw
%       fontsize    ->  fs
%       gridon      ->  grid on
%       plottype    ->  isacf or isspectra or isanova 

if isfield(settings,'legend'), 
    plotlegend = settings.legend;
else
    plotlegend = [];
end%if
if isfield(settings,'title'), 
    plottitle = settings.title;
else
    plottitle = [];
end%if
if isfield(settings,'ylabel'), 
    y_label = settings.ylabel;
else
    y_label = [];
end%if
if isfield(settings,'xlabel'), 
    x_label = settings.xlabel;
else
    x_label = [];
end%if
isacf=0;isspectra=0;
if isfield(settings,'plottype'), 
    if strcmpi(settings.plottype,'acf'), 
        isacf=1;
    elseif strcmpi(settings.plottype,'spectra'), 
        isspectra=1;
    end%if
end%if
if isfield(settings,'xticklabels') & iscell(settings.xticklabels),   
    x_ticklabels=settings.xticklabels;
    my_x_ticklabels = 1;
else
    my_x_ticklabels = 0;
end;%if
if isfield(settings,'xticknums'), 
    x_ticknums=settings.xticknums;
    my_x_ticknums = 1;
    if settings.xticknums==1, my_x_ticknums = 0; end  
else
    my_x_ticknums = 0;
end%if

%calculate how thick lines should be
if isfield(settings,'linewidth'), 
    lw = settings.linewidth;
elseif prows*pcols > 4
    lw = settings.thin_lines;
else
    lw = settings.thick_lines;
end%if isfield(

%calculate which fonts to use
if isfield(settings,'fontsize'), 
    fs = settings.fontsize;
    fs1 = fs;
elseif prows*pcols > 4
    fs = settings.small_fonts;
    fs1 = fs;
else
    fs = settings.big_fonts;
    fs1 = fs-1;
end%if isfield(

%set a gray color for the axis and the numbers on the axes
gray_c = [0.4,0.4,0.4];

subplot(prows,pcols,i)
plotH = plot(x_vector,y_matrix,'LineWidth',lw);

if ~isempty(plotlegend), 
    legH=legend(plotlegend,0);
    set(legH,'Color','none','Box','off','FontSize',fs);
    legend boxoff;
end

if isfield(settings,'gridon'), grid on; end;

if isacf | isspectra,
    Y_lim = get(gca,'YLim');
    set(gca,'XLim',[min(x_vector),max(x_vector)],'YLim',[min(min(y_matrix)),Y_lim(2)]);
else
    set(gca,'XLim',[min(x_vector),max(x_vector)]);
end%if

if my_x_ticklabels,
    %set x axis ticks labels
    set(gca,'XTickLabel',x_ticklabels);
end%if
if my_x_ticknums,
    %set x axis ticks numbers
    set(gca,'XTick',x_ticknums);
end%if

xlabel(x_label,'FontSize',fs1);
ylabel(y_label,'FontSize',fs1);
set(gca,'FontSize',fs1,'XColor',gray_c,'YColor',gray_c);
title(plottitle,'Fontsize',fs);
