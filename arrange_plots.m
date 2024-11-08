function [prows,pcols] = arrange_plots(N_plots)
% Calculate how to arrange N plots in a nice subplot() command.
% Returns the # of rows and cols to be used in the subplot() command
%
switch N_plots
    case {1,2,3,4,5},
        prows = N_plots;
        pcols = 1;
    otherwise,
        n0 = floor(sqrt(N_plots));
        n1 = ceil(sqrt(N_plots));
        if n0*n1 >= N_plots
            prows = n1;
            pcols = n0;
        else
            prows = n1;
            pcols = n1;
        end%if
end%switch-case
