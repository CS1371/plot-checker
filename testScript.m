function testScript
%TEST CASE 1
Copy_of_studentPlotCheck('testPlot');
plot(1:5,6:10); % Should expect a plot to appear automatically 
                % on the plot call but nothing appears
                
%TEST CASE 2
Copy_of_studentPlotCheck('testPlot2'); % Output file should display no errors but
                                       % shows errors on one of the subplots
                                
%TEST CASE 3
Copy_of_studentPlotCheck('testPlot3'); % Output file should display errors for 
                                       % subplot 4 but shows errors for subplot 1
end

function testPlot()
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'b');
    hold on
    plot([-2 2 2 -2 -2], [-2 -2 2 2 -2], 'b');
end

function testPlot_soln()
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'b'); 
    hold on;
    plot([-2 2], [-2 -2], 'b');
    plot([2 2], [-2 2], 'b');
    plot([2 -2], [2 2], 'b');
    plot([-2 -2], [2 -2], 'b');
end

function testPlot2()
    subplot(2,2,1);
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'r');
    subplot(2,2,2);
    plot([-2 2 2 -2 -2], [-2 -2 2 2 -2], 'r');

end

function testPlot2_soln()
    subplot(2,2,1);
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'r');
    subplot(2,2,2);
    plot([-2 2], [-2 -2], 'b');
    hold on
    plot([2 2], [-2 2], 'b');
    plot([2 -2], [2 2], 'b');
    plot([-2 -2], [2 -2], 'b');
end

function testPlot3()
    subplot(2,2,1);
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'r');
    subplot(2,2,2);
    plot([-2 2 2 -2 -2], [-2 -2 2 2 -2], 'r');
    
    subplot(2,2,3);
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'g');
    subplot(2,2,4);
    plot([-2 2 2 -2 -2], [-2 -2 2 2 -2], 'b');

end

function testPlot3_soln()
    subplot(2,2,1);
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'r');
    subplot(2,2,2);
    plot([-2 2 2 -2 -2], [-2 -2 2 2 -2], 'r');
    
    subplot(2,2,3);
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'g');
    subplot(2,2,4);
    plot([-2 2 2 -2 -2], [-2 -2 2 2 -2], 'g');
end

function [] = Copy_of_studentPlotCheck(funName,varargin)

out = []; %intiate out vector, see below in comparePlotProperties
close all %closes all the open figure windows.

%% This function executes and stores the plotted figure of both student and solution as "figure handles" 
     %nargin number of input arguments 
    figure;
    feval(funName, varargin{:}); %Execute the function and in1 input, so on and so forth
    stud = gcf;
    set(stud,'Visible','off');
    figure;
    feval([funName '_soln'], varargin{:});
    soln = gcf;
    set(soln,'Visible','off');
%% Gather all the data and properties for each figure, stud and soln

studentFig = get(stud,'Children'); %get the handle of all the figure prop.
solnFig = get(soln,'Children');
%set(studentFig(1),'XLim',[1 1000]); %I don't know what this part does??
for i = 1:length(studentFig) %length of studentFig is number of plots
    student(i).XData = get(get(studentFig(i),'Children'),'XData'); %#ok<*AGROW>
    student(i).YData = get(get(studentFig(i),'Children'),'YData');
    student(i).ZData = get(get(studentFig(i),'Children'),'ZData');
    student(i).XLabels = get(get(studentFig(i),'XLabel'), 'String');
    student(i).YLabels = get(get(studentFig(i),'YLabel'), 'String');
    student(i).ZLabels = get(get(studentFig(i),'ZLabel'), 'String');
    student(i).Colors = get(get(studentFig(i),'Children'),'Color');
    student(i).Marker = get(get(studentFig(i),'Children'),'Marker');
    student(i).XLimits = get(studentFig(i), 'XLim');
    student(i).YLimits = get(studentFig(i), 'YLim');
    student(i).ZLimits = get(studentFig(i), 'ZLim');
    student(i).Title = get(get(studentFig(i),'Title'),'String');
end
% loop through the cell array 
% sorting the cell array
% .p file for students to check

for i = 1:length(solnFig)
    solution(i).XData = get(get(solnFig(i),'Children'),'XData');
    solution(i).YData = get(get(solnFig(i),'Children'),'YData');
    solution(i).ZData = get(get(solnFig(i),'Children'),'ZData');
    solution(i).XLabels = get(get(solnFig(i),'XLabel'), 'String');
    solution(i).YLabels = get(get(solnFig(i),'YLabel'), 'String');
    solution(i).ZLabels = get(get(solnFig(i),'ZLabel'), 'String');
    solution(i).Colors = get(get(solnFig(i),'Children'),'Color');
    solution(i).Marker = get(get(solnFig(i),'Children'),'Marker');
    solution(i).XLimits = get(solnFig(i), 'XLim');
    solution(i).YLimits = get(solnFig(i), 'YLim');
    solution(i).ZLimits = get(solnFig(i), 'ZLim');
    solution(i).Title = get(get(solnFig(i),'Title'),'String');
end
%close all

%% Determine point values for different componenent of plots

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
title = subPlot/properties;
score = 0;

%% This part of the function compares plot properties between solution and student plots 
fields = fieldnames(student); %fieldnames of structure
for i = 1:length(student) % i represent the current plot of comparison
    for j = 1:length(fieldnames(student)) %go through all properties in the structure
        if strcmp(fields{j},'XData') || strcmp(fields{j},'YData') || strcmp(fields{j},'ZData')
            studPropX = student(i).XData;
            studPropY = student(i).YData;
            studPropZ = student(i).ZData;
            studProperty = [0 0 0];
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
            else
                if isempty(studPropZ)
                    studPropZ = zeros(1,length(studPropX));
                end
                studProperty = [studProperty; studPropX' studPropY' studPropZ'];
            end
            studProperty(end+1,:) = [0 0 0];
            solnPropX = solution(i).XData;
            solnPropY = solution(i).YData;
            solnPropZ = solution(i).ZData;
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
            else
                if isempty(solnPropZ)
                    solnPropZ = zeros(1,length(solnPropX));
                end
                solnProperty = [solnProperty; solnPropX' solnPropY' solnPropZ'];
            end
            solnProperty(end+1,:) = [0 0 0];
            if length(solnPropX) > length(studPropX) %account for different number of lines plotted
                plotLines = length(solnPropX) - length(studPropX);
                added = zeros(2.*plotLines, 3);
                studProperty = [studProperty; added];
            elseif length(studPropX) > length(solnPropX)
                plotLines = length(studPropX) - length(solnPropX);
                added = zeros(2.*plotLines, 3);
                solnProperty = [solnProperty; added];                
            end
        else
            studProperty = student(i).(fields{j}); 
            solnProperty = solution(i).(fields{j}); 
        end        
        test = comparePlotProperties(studProperty,solnProperty,fields{j}); %comparer function
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
            case {'XLimits'}
                subValue = xLimits;                
            case {'YLimits'}
                subValue = yLimits;                
            case {'ZLimits'}
                subValue = zLimits;             
            case {'Colors'}
                subValue = colors;
            case {'Marker'}
                subValue = marker;
            case {'Title'}
                subValue = title;
        end
        if ~test
            out = [out {['The ' fields{j} ' in plot #' num2str(i) ' is/are different']}];
        else
            score = score + subValue;
        end
        fh = fopen(['differences_' funName '.txt'],'w'); 
        fprintf(fh,['Differences between ' funName ' and ' funName '_soln' '\n']);
        for l = 1:length(out)
            fprintf(fh,[out{l} '\n']);
        end
        if isempty(out)
            fprintf(fh,'Your code produced the same plot as the solution file!');
        end
        fclose(fh);
    end
end
end


function out = comparePlotProperties(studIN,solnIN, property) %student of property interest to compare
if ~strcmp(class(studIN),class(solnIN)) %check first if the properties are same class
    out = false;
elseif strcmp(property,'XData') || strcmp(property,'YData') || strcmp(property,'ZData')
    out1 = all(ismember(solnIN,studIN,'rows')); %account for one to one prop.
    out2 = all(ismember(studIN,solnIN,'rows'));
    studINdiff = [abs(diff(studIN(:,1))) abs(diff(studIN(:,2))) abs(diff(studIN(:,3)))];
    solnINdiff = [abs(diff(solnIN(:,1))) abs(diff(solnIN(:,2))) abs(diff(solnIN(:,3)))];
    out3 = all(ismember(solnINdiff,studINdiff,'rows'));
    out4 = all(ismember(studINdiff,solnINdiff,'rows'));
    out5 = length(studIN) == length(solnIN);
    out = out1 & out2 & out3 & out4 & out5;
elseif iscell(studIN) %compare the cells
    for i = 1:length(studIN)
        studIN{i} = num2str(studIN{i},100);
    end
    for i = 1:length(solnIN)
        solnIN{i} = num2str(solnIN{i},100);
    end
    out = all(ismember(solnIN,studIN));
else %if not cell class, then just compare using isequal
    out = isequal(studIN,solnIN); 
end
end