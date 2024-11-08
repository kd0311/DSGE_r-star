function [newTicks,newTicksLabel] = DatesTicks(DATES,YearsPerTick,YearLabel,Ax)
% The function  
% 
%       [newTicks,newTicksLabel] = DatesTicks(DATES,YearsPerTick,YearLabel)
% 
% returns a vector of indeces (newTicks) and a cell array of strings 
% (newTicksLabel) useful to print QUARTERLY dates on the X-axis of a graph.
% Inputs:
%
%     DATES        : 2-dimensional array of quarterly dates [1991, 1; 1992, 2; ... ]
%     YearsPerTick : how many years for every tick in the graph (2=biannual). 
%                    If set to ZERO, uses the Matlab-generated ticks.
%     YearLabel    : a string containing 'long' or 'short' (short prints '99' instead of '1999') 


if nargin<3, YearLabel = 'long'; end

if nargin<4, Ax = 'X'; end

switch lower(YearLabel)
    case 'long'
        i1 = 1;
    case 'short'
        i1 = 3;
    case 'noqrt'
        i1 = 3;
    otherwise %the default in case of misspelling
        i1 = 1;
end%case

if YearsPerTick > 0,
    %%%%%%%% print a Tick every YearsPerTick year %%%%%%%%%%%
    tmp=find(DATES(:,2)==1);
    if YearsPerTick <= 1/4,
        firstQ1 = 1;
    elseif (YearsPerTick == 1/2) & (tmp(1) > 2),
        firstQ1 = tmp(1) - 2;
    else
        firstQ1 = tmp(1);
    end
    newTicks = (firstQ1:4*YearsPerTick:length(DATES));
else
    %%%%%%%% USE Matlab-calculated Ticks %%%%%%%%%%%
    newTicks = get(gca,[Ax 'Tick']);
    if newTicks(1) == 0, newTicks(1) = 1; end
    if newTicks(1) > 2,  newTicks = [1, newTicks]; end
    if newTicks(end) > rows(DATES), newTicks(end) = rows(DATES); end
end%if

DatesTick     = DATES(newTicks,:);
newTicksLabel = cell(0);
for jj=1:length(newTicks),
    anno = num2str(DatesTick(jj,1));
    if strcmpi(YearLabel,'noqrt'),
        newTicksLabel{jj} = anno(i1:4);
    else
        newTicksLabel{jj} = [anno(i1:4),'q',num2str(DatesTick(jj,2))];
    end%if
end%for


if nargout==0, %Apply the new Ticks to the current graph
    set(gca,[Ax 'Tick'],newTicks);
    set(gca,[Ax 'TickLabel'],newTicksLabel);
end%if
