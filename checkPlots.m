%% checkPlots: Check Student plots against Solutions
%
% checkPlots will return a logical and description, representing if it
% passed or not. If the plots aren't equal, then it will describe why.
%
% E = checkPlots(F, I1, I2, ...) will use the function F and input
% arguments I1, I2, ... to check if the student's code produces the same
% plots as the solution. E is true if they're equal, false otherwise.
%
% [E, M] = checkPlots(___) will do the same as above, and also return why
% the plots were incorrect as a character vector in M. If E is true, M is
% empty.
%
% [E, M, D] = checkPlots(___) will do the same as above, and also return
% the differing data, if possible. Data is given if it's possible to
% quantitatively differentiate; XData, titles, etc.
%
%%% Remarks
%
% F is flexible. You can pass in a character vector that represents the
% name of the function or a function handle to the student code.
%
% You must ensure that the function and its solution (fun_soln.p) exist in
% the current folder.
%
% The function will report as soon as it finds something - it is not
% comprehensive. For example, if your plot is wrong in color AND
% coordinates, then the first time you check it will ONLY say "expected
% color to be ___, but got ____". You should run it after every fix to
% ensure you've fixed all problems.
%
% The offending plot will be shown side-by-side with its
% corresponding solution in a new figure window.
%
%%% Exceptions
%
% Any exceptions thrown by the student are caught and re-issued as
% warnings.
%
function [eq, msg, data] = checkPlots(fun, varargin)
%#ok<*LAXES>
    % try to convert to function handle
    if ischar(fun)
        % if has extension, remove
        % can't use endsWith because students might not have 2016 or
        % later... UGHHHHH
        if length(fun) > 2 && strcmp(fun(end-2:end), '.m')
            fun = fun(1:end-2);
        end
        fun = str2func(fun);
    end
    % get soln handle
    soln = str2func([func2str(fun) '_soln']);
    
    % close all plots
    % don't worry about plots we can't see; since we only look at plots we
    % CAN see, if they hide the handle, they still fail
    close('all', 'force');
    
    % run solution function
    try
        soln(varargin{:});
    catch e
        warning(e.message);
        warning('Are you sure you gave the right inputs?');
        eq = false;
        msg = 'Solution errored; Are you sure you gave the right inputs?';
        return;
    end
    solns = populatePlots();
    
    close('all', 'force');
    % run student function and collect PLOT
    try
        fun(varargin{:});
    catch e
        warning(e.message);
        eq = false;
        msg = 'Student code errored while running';
        return;
    end
    studs = populatePlots();
    close('all', 'force');
    
    % compare time!
    % first compare # of plots; if not equal then error
    if numel(solns) == 0 && numel(studs) == 0
        % no plots were expected or given.
        eq = true;
        msg = ['No plots were produced by your function OR the solution, ', ...
            'but outputs and/or files might be different!'];
    elseif numel(solns) == 0
        % no plots expected
        eq = false;
        msg = sprintf(['The solution produced no plots, but your function', ...
            'produced %d. Are you sure you''re supposed to be plotting?'], ...
            numel(studs));
    elseif numel(solns) ~= numel(studs)
        % X num expected, but Y num given
        eq = false;
        msg = sprintf('Expected %d plots, but you produced %d plots', ...
            numel(solns), numel(studs));
    else
       % same number of plots; now loop through
        for n = numel(solns):-1:1
            solnPlot = solns(n);
            isFound = false;
            for s = numel(studs):-1:1
                studPlot = studs(s);
                % if we find an equal one, remove from both
                if studPlot.equals(solnPlot)
                    solns(n) = [];
                    studs(s) = [];
                    isFound = true;
                    eq = true;
                    msg = '';
                    data.student = [];
                    data.solution = [];
                end
            end
            if ~isFound
                % we couldn't find an equal one. Loop through and find
                % "closest" one, compare and report
                
                % Priorities:
                %   Position (subplot)
                %   PointData
                %   SegmentData
                %   # Points
                %   # Segments
                %   PlotBox
                %   Title
                %   Xlabel, Ylabel, Zlabel
                % if all fail, then just pick one at random
                isFound = false;
                for s = numel(studs):-1:1
                    studPlot = studs(s);
                    if isequal(studPlot.Position, solnPlot.Position)
                        isFound = true;
                        break;
                    end
                end
                
                if ~isFound
                    % positions never matched; try next (Segments exact)
                    % Roll Call
                    % for each line segment in that, see if found in this
                    
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        that = solnPlot;
                        thatSegments = that.Segments;
                        thisSegments = studPlot.Segments;
                        for i = 1:numel(thatSegments)
                            % for each in this, go until we have found it. Cannot
                            % delete (for now) because not necessarily unique!!
                            areEqual = false;
                            for j = 1:numel(thisSegments)
                                if isequal(thatSegments(i), thisSegments(j))
                                    areEqual = true;
                                    break;
                                end
                            end
                            if ~areEqual
                                % not found; not equal!
                                break;
                            end
                        end
                        if areEqual
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % Segments (Exact) never matched; try next (Points exact)
                    % Point Call
                    % for each point set, see if found in this
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        that = solnPlot;
                        thatPoints = that.Points;
                        thisPoints = studPlot.Points;
                        for i = 1:numel(thatPoints)
                            % for each in this, go until we have found it. Cannot
                            % delete (for now) because not necessarily unique!!
                            areEqual = false;
                            for j = 1:numel(thisPoints)
                                if isequal(thatPoints(i), thisPoints(j))
                                    areEqual = true;
                                    break;
                                end
                            end
                            if ~areEqual
                                % not found; not equal!
                                break;
                            end
                        end
                        if areEqual
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % Points (Exact) never matched; try next (# segs)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        if numel(studPlot.Segments) == numel(solnPlot.Segments)
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % # segments never matched; try next (# points)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        if numel(studPlot.Points) == numel(solnPlot.Points)
                            isFound = true;
                            break;
                        end
                    end
                end
                
                
                
                if ~isFound
                    % # of lines never matched; try next (PlotBox)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        if isequal(studPlot.PlotBox, solnPlot.PlotBox)
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % PlotBox never matched; try next (Title)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        if strcmpi(studPlot.Title, solnPlot.Title)
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % Title never matched; try next (X, Y, Z label)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        if strcmpi(studPlot.XLabel, solnPlot.XLabel)
                            isFound = true;
                            break;
                        end
                        if strcmpi(studPlot.YLabel, solnPlot.YLabel)
                            isFound = true;
                            break;
                        end
                        if strcmpi(studPlot.ZLabel, solnPlot.ZLabel)
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % we can't find anything. Just get first and engage
                    studPlot = studs(1);
                    warning('We couldn''t find a good match for this plot, so take any feedback with a grain of salt');
                end
                eq = false;
                
                segmentMismatch = false;
                thatSegments = solnPlot.Segments;
                thisSegments = studPlot.Segments;
                for i = 1:numel(thatSegments)
                    % for each in this, go until we have found it. Cannot
                    % delete (for now) because not necessarily unique!!
                    areEqual = false;
                    for j = 1:numel(thisSegments)
                        if isequal(thatSegments(i), thisSegments(j))
                            areEqual = true;
                            break;
                        end
                    end
                    if ~areEqual
                        % not found; not equal!
                        data.student = [];
                        data.solution = thatSegments(i);
                        segmentMismatch = true;
                        break;
                    else

                    end
                end
                pointMismatch = false;
                thatPoints = solnPlot.Points;
                thisPoints = studPlot.Points;
                for i = 1:numel(thatPoints)
                    % for each in this, go until we have found it. Cannot
                    % delete (for now) because not necessarily unique!!
                    areEqual = false;
                    for j = 1:numel(thatPoints)
                        if isequal(thatPoints(i), thisPoints(j))
                            areEqual = true;
                            break;
                        end
                    end
                    if ~areEqual
                        % not found; not equal!
                        data.student = [];
                        data.solution = thatPoints(i);
                        pointMismatch = true;
                        break;
                    else

                    end
                end
                % get right message
                % Priority for checking:
                %   Position
                %   Data mismatch
                %   Colors
                %   Linestyles
                %   Marker Styles
                %   axes
                %   Title
                %   Labels
                data.student = [];
                data.solution = [];
                if ~isequal(studPlot.Position, solnPlot.Position)
                    msg = 'Your plot is wrongly positioned (did you remember to call subplot?)';
                elseif segmentMismatch
                    msg = 'A line segment was not found';
                elseif pointMismatch
                    msg = 'A Point Segment was not found';
                elseif ~isequal(studPlot.PlotBox, solnPlot.PlotBox)
                    msg = ['Your axes (limits and/or scaling) aren''t correct ', ...
                        '(axes limits and scaling are affected by things ', ...
                        '"axis square", "axis equal", and "axes([#, #, #, #]). "', ...
                        'You might want to make sure you''ve set the axes correctly)'];
                elseif ~isequal(studPlot.Title, solnPlot.Title)
                    msg = 'Your title is incorrect';
                    data.student = studPlot.Title;
                    data.solution = solnPlot.Title;
                elseif ~isequal(studPlot.XLabel, solnPlot.XLabel)
                    msg = 'Your x label is incorrect';
                    data.student = studPlot.XLabel;
                    data.solution = solnPlot.XLabel;
                elseif ~isequal(studPlot.YLabel, solnPlot.YLabel)
                    msg = 'Your y label is incorrect';
                    data.student = studPlot.YLabel;
                    data.solution = solnPlot.YLabel;
                elseif ~isequal(studPlot.ZLabel, solnPlot.ZLabel)
                    msg = 'Your z label is incorrect';
                    data.student = studPlot.ZLabel;
                    data.solution = solnPlot.ZLabel;
                elseif studPlot.IsAlien
                    msg = ['Your plots are nearly identical; however, you''ve ', ...
                        'Plotted something that isn''t a line and/or point. (', ...
                        'functions like bar(), pie(), imshow(), and area() ', ...
                        'can plot things that are not lines. Ensure you ', ...
                        'haven''t used anything like that. In general, ', ...
                        'plot() and plot3() should be all you need!)'];
                else
                    % we can't find anything wrong; tell them to talk to a
                    % TA!
                    msg = ['We can''t seem to find anything wrong with your', ...
                        'plot, but we know they''re not equal. Please go ', ...
                        'to a TA at helpdesk OR email your TA with your code'];
                end
                % show the two plots
                f = figure('Name', 'Student''s Plot', 'NumberTitle', 'off');
                ax = axes(f);
                hold(ax, 'on');
                % recreate plot
                title(ax, studPlot.Title);
                xlabel(ax, studPlot.XLabel);
                ylabel(ax, studPlot.YLabel);
                zlabel(ax, studPlot.ZLabel);
                
                % for each set of data, plot.
                % for each point, plot
                for pt = 1:numel(studPlot.Points)
                    point = studPlot.Points(pt);
                    x = point.XData;
                    y = point.YData;
                    z = point.ZData;
                    if isempty(z)
                        p = plot(ax, x, y, ...
                            [point.Marker point.LineStyle]);
                    else
                        p = plot3(ax, x, y, z, ...
                            [point.Marker point.LineStyle]);
                    end
                    p.Color = point.Color;
                end
                
                % for each segment, plot
                for s = 1:numel(studPlot.Segments)
                    seg = studPlot.Segments(s);
                    xx = seg.Segment{1};
                    yy = seg.Segment{2};
                    zz = seg.Segment{3};
                    if isempty(zz)
                        p = plot(ax, xx, yy, ...
                            [seg.Marker seg.LineStyle]);
                    else
                        p = plot(ax, xx, yy, zz, ...
                            [seg.Marker seg.LineStyle]);
                    end
                    p.Color = seg.Color;
                end
                
                
                ax.XLim = studPlot.Limits(1:2);
                ax.YLim = studPlot.Limits(3:4);
                ax.ZLim = studPlot.Limits(5:6);
                ax.Position = studPlot.Position;
                ax.PlotBoxAspectRatio = studPlot.PlotBox;
                
                f = figure('Name', 'Solution''s Plot', 'NumberTitle', 'off');
                ax = axes(f);
                hold(ax, 'on');
                % recreate plot
                title(ax, solnPlot.Title);
                xlabel(ax, solnPlot.XLabel);
                ylabel(ax, solnPlot.YLabel);
                zlabel(ax, solnPlot.ZLabel);
                % for each point, plot
                for pt = 1:numel(solnPlot.Points)
                    point = solnPlot.Points(pt);
                    x = point.XData;
                    y = point.YData;
                    z = point.ZData;
                    if isempty(z)
                        p = plot(ax, x, y, ...
                            [point.Marker point.LineStyle]);
                    else
                        p = plot3(ax, x, y, z, ...
                            [point.Marker point.LineStyle]);
                    end
                    p.Color = point.Color;
                end
                
                % for each segment, plot
                for s = 1:numel(solnPlot.Segments)
                    seg = solnPlot.Segments(s);
                    xx = seg.Segment{1};
                    yy = seg.Segment{2};
                    zz = seg.Segment{3};
                    if isempty(zz)
                        p = plot(ax, xx, yy, ...
                            [seg.Marker seg.LineStyle]);
                    else
                        p = plot(ax, xx, yy, zz, ...
                            [seg.Marker seg.LineStyle]);
                    end
                    p.Color = seg.Color;
                end
                
                ax.XLim = solnPlot.Limits(1:2);
                ax.YLim = solnPlot.Limits(3:4);
                ax.ZLim = solnPlot.Limits(5:6);
                ax.Position = solnPlot.Position;
                ax.PlotBoxAspectRatio = solnPlot.PlotBox;
                return;
            end
        end
    end
            
end

function plots = populatePlots()
    % Get all handles; since the Position is captured, that can be used
    % for the subplot checking
    pHandles = findobj(0, 'type', 'axes');
    if numel(pHandles) ~= 0
        plots(numel(pHandles)) = Plot(pHandles(end));
        for i = 1:(numel(pHandles) - 1)
            plots(i) = Plot(pHandles(i));
        end
    else
        plots = [];
    end
end
    
    