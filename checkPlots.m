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
%%% Remarks
%
% F is flexible. You can pass in a character vector that represents the
% name of the function or a function handle to the student code.
%
% You must ensure that the function and its solution (fun_soln.p) exist in
% the current folder.
%
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
ERROR_COLOR = [.45 0 0];
BAD_MARKER_SIZE = 12;
BAD_LINE_WIDTH = 2;
BAD_FONT_FACTOR = 3;
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
        figure('Visible','off')
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
        figure('Visible','off')
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
        solutionFigure = figure('Visible', 'off', ...
            'NumberTitle', 'off', ...
            'Name', 'Solution Plot(s)');
        studentFigure = figure('Visible', 'off', ...
            'NumberTitle', 'off', ...
            'Name', 'Student Plot(s)');
        msg = cell(1, numel(solns));
        % same number of plots; now loop through layers
        
        i = numel(solns);
        % First, find any plots that are exactly equal:
        for n = numel(solns):-1:1
            msg{n} = cell(0);
            solnPlot = solns(n);
            for s = numel(studs):-1:1
                studPlot = studs(s);
                if solnPlot.equals(studPlot)
                   solnsOrdered(i) = solns(n);
                   studsOrdered(i) = studs(s);
                   solns(n) = [];
                   studs(s) = [];
                   i = i - 1;
                end
            end
            
        end
        
        % Layer 2: for any unmatched plots, find where the data is equal,
        % ignoring other elements
        for n = numel(solns):-1:1
            solnPlot = solns(n);
            for s = numel(studs):-1:1
                studPlot = studs(s);
                if solnPlot.dataEquals(studPlot)
                   solnsOrdered(i) = solns(n);
                   studsOrdered(i) = studs(s);
                   solns(n) = [];
                   studs(s) = [];
                   i = i - 1;
                end
            end 
        end
        
         % Layer 3: for any unmatched plots, find where the points are
         % equal, ignoring other elements
        for n = numel(solns):-1:1
            solnPlot = solns(n);
            for s = numel(studs):-1:1
                studPlot = studs(s);
                if solnPlot.pointEquals(studPlot)
                   solnsOrdered(i) = solns(n);
                   studsOrdered(i) = studs(s);
                   solns(n) = [];
                   studs(s) = [];
                   i = i - 1;
                end
            end 
        end
     
          
        % Layer 4: or any unmatched plots, find where the data is close,
        % still ignoring other elements
        for n = numel(solns):-1:1
          solnPlot = solns(n);
            for s = numel(studs):-1:1
                studPlot = studs(s);
                
                pMatch = 0;
                for p = solnPlot.Points
                    if ismember(p,studPlot.Points)
                        pMatch = pMatch + 1;
                    end
                end
                if pMatch > (numel(solnPlot.Points) - 0.1 * numel(solnPlot.Points))
                   solnsOrdered(i) = solns(n);
                   studsOrdered(i) = studs(s);
                   solns(n) = [];
                   studs(s) = [];
                   i = i - 1;
                end
            end 
        end
        
        % Layer 5: or any unmatched plots, find if any plot is remaining in
        % the same position
        for n = numel(solns):-1:1
            solnPlot = solns(n);
            for s = numel(studs):-1:1
                studPlot = studs(s);
                if isequal(solnPlot.Position,studPlot.Position)
                   solnsOrdered(i) = solns(n);
                   studsOrdered(i) = studs(s);
                   solns(n) = [];
                   studs(s) = [];
                   i = i - 1;
                end
            end 
        end
        
        % Layer 5: or any unmatched plots, find if any plot remaining has
        % the same title
        for n = numel(solns):-1:1
            solnPlot = solns(n);
            for s = numel(studs):-1:1
                studPlot = studs(s);
                if isequal(solnPlot.Title,studPlot.Title)
                   solnsOrdered(i) = solns(n);
                   studsOrdered(i) = studs(s);
                   solns(n) = [];
                   studs(s) = [];
                   i = i - 1;
                end
            end 
        end
        
 
                %
                % Feedback is given as bolding and/or changing colors. The
                % following should be considered:
                %   * Title
                %   * Labels
                %   * Line Colors
                %   * Point Colors
                %   * Point Markers
                %   * Line Styles
                %   * Points that exist in one, but not other
                %   * Segments that exist in one, but not other
                %
                % Do the following:
                %
                %   1. If the title is messed up, color with ERROR_COLOR;
                %   2. If the labels are messed up, color with ERROR_COLOR;
                %   3. If a line is otherwise equal except for style or
                %   color, expand line width to BAD_SEGMENT_WIDTH
                %   4. If a point is otherwise equal except for marker or
                %   color, expand marker size to BAD_MARKER_SIZE
                %   5. If a point exists in only one, plot with
                %   BAD_MARKER_SIZE.
                %   6. If a segment exists in only one, plot with
                %   BAD_LINE_WIDTH.
                %   7. If the position is wrong, add text in middle of axes
                %   8. If the axis style is wrong, add text in middle of axes
                %   9. If the axis limits are wrong, color the Axis itself
                %   10. If alien, add text in middle of axes
                % 
                % Start by creating two plots.
                %%% Title
                solutionAxes = axes(solutionFigure, ...
                    'Position', solnPlot.Position, ...
                    'XLim', solnPlot.Limits(1:2), ...
                    'YLim', solnPlot.Limits(3:4), ...
                    'ZLim', solnPlot.Limits(5:6), ...
                    'PlotBoxAspectRatio', solnPlot.PlotBox);
                solutionAxes.XLabel.String = solnPlot.XLabel;
                solutionAxes.YLabel.String = solnPlot.YLabel;
                solutionAxes.ZLabel.String = solnPlot.ZLabel;
                solutionAxes.Title.String = sprintf('[%d] %s', n, solnPlot.Title);
                hold(solutionAxes, 'on');
                studentAxes = axes(studentFigure, ...
                    'Position', solnPlot.Position, ...
                    'XLim', studPlot.Limits(1:2), ...
                    'YLim', studPlot.Limits(3:4), ...
                    'ZLim', studPlot.Limits(5:6), ...
                    'PlotBoxAspectRatio', studPlot.PlotBox);
                studentAxes.XLabel.String = studPlot.XLabel;
                studentAxes.YLabel.String = studPlot.YLabel;
                studentAxes.ZLabel.String = studPlot.ZLabel;
                studentAxes.Title.String = studPlot.Title;
                hold(studentAxes, 'on');
                if ~studPlot.dataEquals(solnPlot)
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect Data', n);
                end
                %%% Title
                if ~isequal(studPlot.Title, solnPlot.Title)
                    studentAxes.Title.Color = ERROR_COLOR;
                    studentAxes.TitleFontSizeMultiplier = BAD_FONT_FACTOR;
                    solutionAxes.TitleFontSizeMultiplier = BAD_FONT_FACTOR;
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect Title', n);
                end
                if ~isequal(studPlot.XLabel, solnPlot.XLabel)
                    studentAxes.XLabel.Color = ERROR_COLOR;
                    studentAxes.XLabel.FontSize = ...
                        studentAxes.XLabel.FontSize * BAD_FONT_FACTOR;
                    solutionAxes.XLabel.FontSize = ...
                        solutionAxes.XLabel.FontSize * BAD_FONT_FACTOR;
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect XLabel', n);
                end
                if ~isequal(studPlot.YLabel, solnPlot.YLabel)
                    studentAxes.YLabel.Color = ERROR_COLOR;
                    studentAxes.YLabel.FontSize = ...
                        studentAxes.YLabel.FontSize * BAD_FONT_FACTOR;
                    solutionAxes.YLabel.FontSize = ...
                        solutionAxes.YLabel.FontSize * BAD_FONT_FACTOR;
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect YLabel', n);
                end
                if ~isequal(studPlot.ZLabel, solnPlot.ZLabel)
                    studentAxes.ZLabel.Color = ERROR_COLOR;
                    studentAxes.ZLabel.FontSize = ...
                        studentAxes.Label.FontSize * BAD_FONT_FACTOR;
                    solutionAxes.ZLabel.FontSize = ...
                        solutionAxes.Label.FontSize * BAD_FONT_FACTOR;
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect ZLabel', n);
                end
                
                % We can first plot lines on both that are same. Use
                % ismember to determine!
                segs = solnPlot.Segments;
                segs = segs(ismember(segs, studPlot.Segments));
                for s = numel(segs):-1:1
                    seg = segs(s);
                    pts = [seg.Start seg.Stop];
                    if any([pts.Z] ~= 0)
                        solnLine = plot3(solutionAxes, [pts.X], [pts.Y], [pts.Z]);
                        studLine = plot3(studentAxes, [pts.X], [pts.Y], [pts.Z]);
                    else
                        solnLine = plot(solutionAxes, [pts.X], [pts.Y]);
                        studLine = plot3(studentAxes, [pts.X], [pts.Y]);
                    end
                    solnLine.Color = seg.Color;
                    studLine.Color = seg.Color;
                    solnLine.LineStyle = seg.Style;
                    studLine.LineStyle = seg.Style;
                end
                
                pts = solnPlot.Points;
                pts = pts(ismember(pts, studPlot.Points));
                for p = numel(pts):-1:1
                    pt = pts(p);
                    if pt.Z ~= 0
                        solnPt = plot3(solutionAxes, pt.X, pt.Y, pt.Z);
                        studPt = plot3(studentAxes, pt.X, pt.Y, pt.Z);
                    else
                        solnPt = plot(solutionAxes, pt.X, pt.Y);
                        studPt = plot(studentAxes, pt.X, pt.Y);
                    end
                    solnPt.Marker = pt.Marker;
                    studPt.Marker = pt.Marker;
                    solnPt.Color = pt.Color;
                    studPt.Color = pt.Color;
                end
                
                % now, it differs. First we'll plot everything on SOLUTION
                % that isn't found in STUDENTS
                segs = solnPlot.Segments;
                segs = segs(~ismember(segs, studPlot.Segments));
                for s = numel(segs):-1:1
                    seg = segs(s);
                    pts = [seg.Start seg.Stop];
                    if any([pts.Z] ~= 0)
                        solnLine = plot3(solutionAxes, [pts.X], [pts.Y], [pts.Z]);
                    else
                        solnLine = plot(solutionAxes, [pts.X], [pts.Y]);
                    end
                    solnLine.Color = seg.Color;
                    solnLine.LineStyle = seg.Style;
                    solnLine.LineWidth = BAD_LINE_WIDTH;
                end
                
                segs = studPlot.Segments;
                segs = segs(~ismember(segs, solnPlot.Segments));
                for s = numel(segs):-1:1
                    seg = segs(s);
                    pts = [seg.Start seg.Stop];
                    if any([pts.Z] ~= 0)
                        studLine = plot3(studentAxes, [pts.X], [pts.Y], [pts.Z]);
                    else
                        studLine = plot(studentAxes, [pts.X], [pts.Y]);
                    end
                    studLine.Color = seg.Color;
                    studLine.LineStyle = seg.Style;
                    studLine.LineWidth = BAD_LINE_WIDTH;
                end
                
                pts = solnPlot.Points;
                pts = pts(~ismember(pts, studPlot.Points));
                for p = numel(pts):-1:1
                    pt = pts(p);
                    if pt.Z ~= 0
                        solnPt = plot3(solutionAxes, pt.X, pt.Y, pt.Z);
                    else
                        solnPt = plot(solutionAxes, pt.X, pt.Y);
                    end
                    solnPt.Marker = pt.Marker;
                    solnPt.Color = pt.Color;
                    solnPt.MarkerSize = BAD_MARKER_SIZE;
                end
                
                pts = studPlot.Points;
                pts = pts(~ismember(pts, solnPlot.Points));
                for p = numel(pts):-1:1
                    pt = pts(p);
                    if pt.Z ~= 0
                        studPt = plot3(studentAxes, pt.X, pt.Y, pt.Z);
                    else
                        studPt = plot(studentAxes, pt.X, pt.Y);
                    end
                    studPt.Marker = pt.Marker;
                    studPt.Color = pt.Color;
                    studPt.MarkerSize = BAD_MARKER_SIZE;
                end
                
                if ~isequal(studPlot.Limits(1:2), solnPlot.Limits(1:2))
                    studentAxes.XColor = ERROR_COLOR;
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect XLimits', n);
                end
                if ~isequal(studPlot.Limits(3:4), solnPlot.Limits(3:4))
                    studentAxes.YColor = ERROR_COLOR;
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect YLimits', n);
                end
                if ~isequal(studPlot.Limits(5:6), solnPlot.Limits(5:6))
                    studentAxes.ZColor = ERROR_COLOR;
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect ZLimits', n);
                end
                txtHelper = cell(3, 1);
                if any(solnPlot.Position < (studPlot.Position - Plot.POSITION_MARGIN)) ...
                    || any(solnPlot.Position > (studPlot.Position + Plot.POSITION_MARGIN))
                    txtHelper{1} = ...
                        'Subplot Incorrect';
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect Position (did you remember to call subplot?)', n);
                end
                if any(solnPlot.PlotBox < (studPlot.PlotBox - Plot.POSITION_MARGIN)) ...
                    || any(solnPlot.PlotBox > (studPlot.PlotBox + Plot.POSITION_MARGIN))
                    txtHelper{2} = ...
                        'Axis Incorrect';
                    msg{n}{end+1} = sprintf('Plot %d: Incorrect Aspect Ratio (did you forget to call axis square, or axis equal?)', n);
                end
                if studPlot.isAlien
                    txtHelper{3} = 'Invalid Data';
                    msg{n}{end+1} = sprintf('Plot %d: You have invalid data - make sure you stick to plot and plot3 for plotting data!', n);
                end
                txtHelper(cellfun(@isempty, txtHelper)) = [];
                if ~isempty(txtHelper)
                    txtHelper = text(mean(studPlot.Limits(1:2)), ...
                        mean(studPlot.Limits(3:4)), ...
                        txtHelper);
                    txtHelper.HorizontalAlignment = 'center';
                    txtHelper.VerticalAlignment = 'middle';
                    txtHelper.Color = ERROR_COLOR;
                    txtHelper.BackgroundColor = [1 1 1];
                    txtHelper.FontUnits = 'normalized';
                    drawnow;
                    txtHelper.FontSize = 2 * txtHelper.FontSize;
                end
            end
        end
        msg = [msg{:}];
        if ~isempty(msg)
            msg = strjoin(msg, newline);
            solutionFigure.Visible = 'on';
            studentFigure.Visible = 'on';
        end
    end


function plots = populatePlots()
    % Get all handles; since the Position is captured, that can be used
    % for the subplot checking
    pHandles = findobj(0, 'type', 'axes');
    if numel(pHandles) ~= 0
        figure('Visible','off')
        plots(numel(pHandles)) = Plot(pHandles(end));
        for i = 1:(numel(pHandles) - 1)
            figure('Visible','off')
            plots(i) = Plot(pHandles(i));
        end
    else
        plots = [];
    end
end
    
    