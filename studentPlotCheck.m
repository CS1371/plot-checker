%% studentPlotCheck This is the 2016 CS 1371 MATLAB Student Plot Checker
%
% studentPlotCheck(funcName, input1, input2, ...)
%
% Inputs:
%   funcName (string): the name of the function to test, as a string
%   Remaining Inputs: the inputs required to run the function
%
% Output:
%   A text file of differences between your function's plot and the solution.
%   The contents of the text file are also printed to the Command Window.
%
% Example:
% Function to test: cellGrowth
% Test case 1 using inputs: cell1 and time1
%
% studentPlotCheck('cellGrowth', cell1, time1);
%
% --> Produces a txt file called differences_uniqueFit.txt
%     showing differences between your function and the soln file function.
%     This content will also be printed to the Command Window.
%
% Notes:
% 1) The function name must be a string and should not include .m or .p!
% 2) The additional inputs for the function must be in the same order the
%       function takes it in.
% 3) Input the function name only, not the solution function's name.
% 4) If there are differences displayed in the txt file, even if the plots
%       look the same, your plot is not exactly the same compared to the solution file.
%
function studentPlotCheck(funName,varargin)
if verLessThan('matlab', 'R2015a')
    error('You must run the plot checker with MATLAB version R2015a or later.\nYou can visit software.oit.gatech.edu for the latest version of MATLAB.');
end
date = datevec(now);
if date(2)==4 && date(3)==1 % if it's april fools
    if ispc
        ! start /max https://www.youtube.com/watch?v=dQw4w9WgXcQ
    elseif ismac
        ! open https://www.youtube.com/watch?v=dQw4w9WgXcQ
    else
        ! xdg-open https://www.youtube.com/watch?v=dQw4w9WgXcQ
    end
end
out = []; %intiate out vector, see below in comparePlotProperties
close all %closes all the open figure windows.

%% This function executes and stores the plotted figure of both student and solution as "figure handles"
figure;% Create new figure
funExits = exist(funName); %Check for the existence of the function in your directory
feval(funName, varargin{:}); %Execute the function and all inputs of that function
stud = gcf;% Give current figure handle (the same as a file handle for figures)
set(stud,'Visible','off'); % Turns off the plot so it is not shown while the code is running
figure;% Create new figure
feval([funName '_soln'], varargin{:});% Execute the solution function
soln = gcf;% get current figure handle
set(soln,'Visible','off');%Same as above, turn off the viewing of the figure
%% Gather all the data and properties for each figure, stud and soln

studentFig = get(stud,'Children'); %get the handle of all the students figure prop.
solnFig = get(soln,'Children');%get the handle of all the solution figure properties
%set(studentFig(1),'XLim',[1 1000]); %I don't know what this part does??

% The for loop obtains the handles of all of the different parts of a plot
% and then stores them in their respective properties names, as a structure
% array. The properties of a plot and thusly the fields of the structure array are:
% Xdata, Ydata, Zdata, The labels of those axis, the colors and markers for each of the subplots, the XYZ limits of
% plotting, and the Titles.

for i = 1:length(studentFig) %length of studentFig is number of plots
    if isa(get(studentFig(i), 'Children'), 'matlab.graphics.chart.primitive.Bar')
        student(i).XData = get(get(studentFig(i),'Children'),'XData');
        student(i).YData = get(get(studentFig(i),'Children'),'YData');
    else
        student(i).XData = get(get(studentFig(i),'Children'),'XData');
        student(i).YData = get(get(studentFig(i),'Children'),'YData');
        student(i).ZData = get(get(studentFig(i),'Children'),'ZData');
        student(i).XLabels = get(get(studentFig(i),'XLabel'), 'String');
        student(i).YLabels = get(get(studentFig(i),'YLabel'), 'String');
        student(i).ZLabels = get(get(studentFig(i),'ZLabel'), 'String');
        student(i).Colors = get(get(studentFig(i),'Children'),'Color');
        student(i).Marker = get(get(studentFig(i),'Children'),'Marker');
        student(i).LineStyle = get(get(studentFig(i),'Children'),'LineStyle');
        student(i).Title = get(get(studentFig(i),'Title'),'String');
    end
end

% Now do the same thing as above, but for the solution plot

for i = 1:length(solnFig)
    if isa(get(studentFig(i), 'Children'), 'matlab.graphics.chart.primitive.Bar')
        solution(i).XData = get(get(solnFig(i),'Children'),'XData');
        solution(i).YData = get(get(solnFig(i),'Children'),'YData');
    else
        solution(i).XData = get(get(solnFig(i),'Children'),'XData');
        solution(i).YData = get(get(solnFig(i),'Children'),'YData');
        solution(i).ZData = get(get(solnFig(i),'Children'),'ZData');
        solution(i).XLabels = get(get(solnFig(i),'XLabel'), 'String');
        solution(i).YLabels = get(get(solnFig(i),'YLabel'), 'String');
        solution(i).ZLabels = get(get(solnFig(i),'ZLabel'), 'String');
        solution(i).Colors = get(get(solnFig(i),'Children'),'Color');
        solution(i).Marker = get(get(solnFig(i),'Children'),'Marker');
        solution(i).LineStyle = get(get(solnFig(i),'Children'),'LineStyle');
        solution(i).Title = get(get(solnFig(i),'Title'),'String');
    end
end
%close all

%% Determine point values for different componenent of plots
%This part is optional. It assigns
%point values to each of the properties of the plot, which can be used
%later to give a student partial credit on a plot question.

problem = 100; %total point value for Test Case
subPlot = problem / length(solnFig); %individual plot value points
properties = length(fieldnames(student)); %number of properties evaluated
%Enter percentage of weight for each property
xData = subPlot/properties;
yData = subPlot/properties;
zData = subPlot/properties;
xLabels = subPlot/properties;
yLabels = subPlot/properties;
zLabels = subPlot/properties;
xLimits = subPlot/properties;
yLimits = subPlot/properties;
zLimits = subPlot/properties;
colors = subPlot/properties;
marker = subPlot/properties;
lineStyle = subPlot/properties;
title = subPlot/properties;
score = 0;

%% This part of the function compares plot properties between solution and student plots
fields = fieldnames(student); %fieldnames of the structure involved in grading
for i = 1:length(student) % i represent the current subplot of comparison
    for j = 1:length(fieldnames(student)) % go through all properties in the structure
        switch fields{j}
            %if the fields are 'simple' as in Xlabels Ylabels Title etc.
            %then you can simply get their string values from the
            %structure. For the X,Y,and Z points of the graph, you will use
            %the parser helper function to organize the points into usable
            %double arrays, that can be checked for equivalency later.
            case {'XLabels','YLabels','ZLabels','Title','Marker','LineStyle','Colors'}
                studProperty = student(i).(fields{j});
                solnProperty = solution(i).(fields{j});
            otherwise
                [studProperty, solnProperty] = parser(student, solution, i, fields{j});
        end
        %This helper function will compare the student graph property
        %(i.e. the X points, Y points Xlabels, Markers, etc.) to the
        %solution graph property. It utilizes the helper function to do
        %this (see helper function explanation in helper function below.
        test = comparePlotProperties(studProperty,solnProperty); %comparer function
        %The next switch statment assigns each  of the parts of the graph a
        %point value assigned in the point assignment statement above.
        switch fields{j}
            case {'XData'}
                subValue = xData;
            case {'YData'}
                subValue = yData;
            case {'ZData'}
                subValue = zData;
            case {'XLabels'}
                subValue = xLabels;
            case {'YLabels'}
                subValue = yLabels;
            case {'ZLabels'}
                subValue = zLabels;
                %             case {'XLimits'}
                subValue = xLimits;
                %             case {'YLimits'}
                subValue = yLimits;
                %             case {'ZLimits'}
                subValue = zLimits;
            case {'Colors'}
                subValue = colors;
            case {'Marker'}
                subValue = marker;
            case {'LineStyle'}
                subValue = lineStyle;
            case {'Title'}
                subValue = title;
        end
        %The next if statment is checking to see if the two compared
        %properties are the same. If they are, nothing will print. If they are not,
        %it will print out the property and in which subplot the property is different
        if ~test
            out = [out {['The ' fields{j} ' in plot #' num2str(length(student)-i+1) ' is/are different']}];
        else
            score = score + subValue;
        end
        %The next few statements are simple low level for outputting a
        %document that describes the differences between the two plots.
        fname = ['differences_' funName '.txt'];
        fh = fopen(fname,'w');
        if ~isempty(out)
            fprintf(fh,['Differences between ' funName ' and ' funName '_soln' '\n']);
        end
        for l = 1:length(out)
            fprintf(fh,[out{l} '\n']);
        end
        if isempty(out)
            fprintf(fh,'Your code produced the same plot as the solution file!\n');
        end
        fclose(fh);
    end
end
%Finally, close all open figures
a = 1;
figHandles = findall(0,'Type','figure');
close(figHandles);
% display stuff at the end
% this is the jankest thing I have ever done (not really)
fprintf(fileread(fname));
end

function [studProperty, solnProperty] = parser(student, solution,i, property)
%This is the parser. It takes X,Y,and Z points from the above function,
%as well as the position of the property (i), and which property you
%are checking for.
switch property
    case {'XData','YData','ZData'}
        studPropX = student(i).XData;
        studPropY = student(i).YData;
        if isfield(student(i), 'ZData')
            studPropZ = student(i).ZData;
        else
            studPropZ = zeros(1, length(studPropX));
        end
        studProperty = [0 0 0];
        %if the property is a cell, the function will take the
        %doubles out of the cell, and put them in a cell array. If
        %they are not in a cell, it simply puts them in a double
        %array.
        if iscell(studPropX)
            for k = 1:length(studPropX)
                if isempty(studPropZ{k})
                    studPropZtemp = zeros(1,length(studPropX{k}));
                    studProptemp = [studPropX{k}' studPropY{k}' studPropZtemp';];
                    studProperty = [studProperty; 0 0 0; studProptemp];
                else
                    studPropZtemp = studPropZ{k};
                    studProptemp = [studPropX{k}' studPropY{k}' studPropZtemp';];
                    studProperty = [studProperty; 0 0 0; studProptemp];
                end
            end
            studProperty(1,:) = [];
        else
            if isempty(studPropZ)
                studPropZ = zeros(1,length(studPropX));
            end
            studProperty = [studProperty; studPropX' studPropY' studPropZ'];
        end
        studProperty(end+1,:) = [0 0 0];
        %Below is the same as above, but this is for the solution
        %array.
        solnPropX = solution(i).XData;
        solnPropY = solution(i).YData;
        if isfield(solution(i), 'ZData')
            solnPropZ = solution(i).ZData;
        else
            solnPropZ = zeros(1, length(solnPropX));
        end
        solnProperty = [0 0 0];
        if iscell(solnPropX)
            for k = 1:length(solnPropX)
                if isempty(solnPropZ{k})
                    solnPropZtemp = zeros(1,length(solnPropX{k}));
                    solnProptemp = [solnPropX{k}' solnPropY{k}' solnPropZtemp';];
                    solnProperty = [solnProperty; 0 0 0; solnProptemp];
                else
                    solnPropZtemp = solnPropZ{k};
                    solnProptemp = [solnPropX{k}' solnPropY{k}' solnPropZtemp';];
                    solnProperty = [solnProperty; 0 0 0; solnProptemp];
                end
            end
            solnProperty(1,:) = [];
        else
            if isempty(solnPropZ)
                solnPropZ = zeros(1,length(solnPropX));
            end
            solnProperty = [solnProperty; solnPropX' solnPropY' solnPropZ'];
        end
        solnProperty(end+1,:) = [0 0 0];
        %The otherwise case is for anything not an X,Y, or Z point. So
        %things like Xlimits and Ylimits etc.
    otherwise
        studProperty = student(i).(property);
        if iscell(studProperty)
            studProperty = cell2mat(studProperty);
        end
        solnProperty = solution(i).(property);
        if iscell(solnProperty)
            solnProperty = cell2mat(solnProperty);
        end
end
end

function out = comparePlotProperties(studIN,solnIN) %student of property interest to compare
%Compare plot properties is the meat of the plot checker. everything is
%already arranged in an array format, so now if they are both char, you can
%use simple isequal (since order matters). If it is a cell array, you can
%compare them using an ismember function. This function checks the array of
%both and checks to see if the rows of each array "are members" of the
%other array. It is not always accurate, but by overlaying multiple
%ismember checks, you can obtain a right answer always when the answer is
%correct, and sometimes (but rarely) obtain the correct answer if it is
%wrong.

%If it is a double it uses the same ismember function, but this time with
%even more ways to compare. By comparing the slope between the different
%points, and then using ismember, you cna obtain a result that is correct
%even if the points are in different order, which is the biggest challenge
%of this plot checker.

%There are ways to get around ismember though. If a student were to input
%all 0's as their function, it would be marked correct, because all of the
%solutions have a row of [0,0,0] in them to allow for the ability to take
%a slope.
if ischar(studIN) && ischar(solnIN) %if not cell class, then just compare using isequal
    out = isequal(studIN,solnIN);
elseif iscell(studIN) || iscell(solnIN)
    if isnumeric(solnIN{1}) %indicates that we are checking colors {[1 0 1], [0 0 0]}, etc...
        solnIN = cell2mat(solnIN);
        studIN = cell2mat(studIN); %since ismember can only take cell array of strings, or double array
        out1 = all(ismember(solnIN,studIN,'rows'));
        out2 = all(ismember(studIN,solnIN,'rows'));
    else
        out1 = all(ismember(solnIN,studIN));
        out2 = all(ismember(studIN,solnIN));
    end
    out = out1 & out2;
elseif isnumeric(studIN) && isnumeric(solnIN)
    out1 = all(ismembertol(solnIN,studIN,'ByRows', true));
    out2 = all(ismembertol(studIN,solnIN,'ByRows',true));
    [r,c] = size(studIN);
    [r2,~] = size(solnIN);
    %only run the slope check if there is more than one point to check in
    %both plots
    if r > 1 && r2 > 1
        studINdiff = [];
        for i = 1:c
            studINdiff = [studINdiff abs(diff(studIN(:,i)))];
        end
        [~,c] = size(solnIN);
        solnINdiff = [];
        for i = 1:c
            solnINdiff = [solnINdiff abs(diff(solnIN(:,i)))];
        end
        %here is the all ismember check, which can only be true if all of
        %the slopes match up between the student and the solution file.
        out3 = all(ismembertol(solnINdiff,studINdiff,'ByRows',true));
        out4 = all(ismembertol(studINdiff,solnINdiff,'ByRows',true));
    else
        out3 = true;
        out4 = true;
    end
    %if all of the checks are true, output true for the test variable
    %above.
    out = out1 & out2 & out4;
end
end