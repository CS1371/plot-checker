function out = checkPlots(stud,soln)
studentFig = get(stud,'Children');
solnFig = get(soln,'Children'); 
for i = 1:length(studentFig)
    student(i).XData = get(get(studentFig(i),'Children'),'XData');
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

if exist('student','var')
    fields = fieldnames(student); 
    out = [];
    for i = 1:length(student)
        for j = 1:length(fieldnames(student))
            studProperty = student(i).(fields{j}); 
            solnProperty = solution(i).(fields{j}); 
            test = comparePlotProperties(studProperty,solnProperty); 
            if ~test
                out = [out {['The ' fields{j} ' in subplot #' num2str(length(student)-i+1) ' is/are different']}]; 
            end
        end
    end
else
    out = {'Empty file, please complete ABCs_plotting before continuing'};
end

end

function out = comparePlotProperties(studIN,solnIN)
out = true; 
if ~strcmp(class(studIN),class(solnIN))
    out = false; 
elseif iscell(studIN)
    maxLength=max(cellfun(@(x)numel(x),studIN));
    studMatrix = cell2mat(cellfun(@(x)cat(2,x,zeros(1,maxLength-length(x))),studIN,'UniformOutput',false));
    solnMatrix = cell2mat(cellfun(@(x)cat(2,x,zeros(1,maxLength-length(x))),solnIN,'UniformOutput',false));
    for i = 1:size(studMatrix,1)
        out = out && ismember(studMatrix(i,:),solnMatrix,'rows');
    end
else
    out = isequal(studIN,solnIN); 
end
end