%% plotChecker: Check Student plots against Solutions
%
% plotChecker will return a logical and description, representing if it
% passed or not. If the plots aren't equal, then it will describe why.
%
% E = plotChecker(F, I1, I2, ...) will use the function F and input
% arguments I1, I2, ... to check if the student's code produces the same
% plots as the solution. E is true if they're equal, false otherwise.
%
% [E, M] = plotChecker(___) will do the same as above, and also return why
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
% The function will report as soon as it finds something - it is not
% comprehensive. For example, if your plot is wrong in color AND
% coordinates, then the first time you check it will ONLY say "expected
% color to be ___, but got ____". You should run it after every fix to
% ensure you've fixed all problems.
%
% The offending plot will always be shown side-by-side with its
% corresponding solution in a new figure window.
%
%%% Exceptions
%
% Any exceptions thrown by the student are caught and re-issued as
% warnings.
%
function [eq, msg] = plotChecker(fun, varargin)
    % try to convert to function handle
    if ischar(fun)
        % if has extension, remove
        if endsWith(fun, '.m')
            fun = fun(1:end-3);
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
                end
            end
            if ~isFound
                % we couldn't find an equal one. Loop through and find
                % "closest" one, compare and report
                
                % Priorities:
                %   Position (subplot)
                %   XData, YData, ZData (exact)
                %   Colors (Exact)
                %   XData, YData, ZData (amount)
                %   Number of lines (Exact)
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
                
                if ~isempty(studPlot)
                    % positions never matched; try next (X, Y, Z exact)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        % compare X Data exact (BUT not if both empty!)
                        if isequal(studPlot.XData, solnPlot.XData) && ...
                                ~all(cellfun(@isempty, studPlot.XData))
                            isFound = true;
                            break;
                        end
                        if isequal(studPlot.YData, solnPlot.YData) && ...
                                ~all(cellfun(@isempty, studPlot.YData))
                            isFound = true;
                            break;
                        end
                        if isequal(studPlot.YData, solnPlot.YData) && ...
                                ~all(cellfun(@isempty, studPlot.YData))
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % X, Y, Z exact never matched; try next (Colors, exact)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        if isequal(studPlot.Color, solnPlot.Color)
                            isFound = true;
                            break;
                        end
                    end
                end
                
                if ~isFound
                    % Colors never matched; try next (X, Y, Z amount)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        % get numels of XData
                        if all(...
                                cellfun(@numel, studPlot.Xdata) == ...
                                cellfun(@numel, solnPlot.XData)) && ...
                                all(cellfun(@numel, studPlot.XData) ~= 0)
                            % all numels are the same; engage
                            isFound = true;
                            break;
                        end
                        if all(...
                                cellfun(@numel, studPlot.Ydata) == ...
                                cellfun(@numel, solnPlot.YData)) && ...
                                all(cellfun(@numel, studPlot.YData) ~= 0)
                            % all numels are the same; engage
                            isFound = true;
                            break;
                        end
                        if all(...
                                cellfun(@numel, studPlot.Zdata) == ...
                                cellfun(@numel, solnPlot.ZData)) && ...
                                all(cellfun(@numel, studPlot.ZData) ~= 0)
                            % all numels are the same; engage
                            isFound = true;
                            break;
                        end
                    end     
                end
                
                if ~isFound
                    % X, Y, Z amount exact never matched; try next (# of lines)
                    for s = numel(studs):-1:1
                        studPlot = studs(s);
                        if numel(studPlot.LineStyle) == numel(solnPlot.LineStyle)
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
                if ~isequal(studPlot.Position, solnPlot.Position)
                    msg = 'Your plot is wrongly positioned (did you remember to call subplot?)';
                elseif ~isequal(studPlot.XData, solnPlot.XData)
                    msg = 'Your X values are not correct';
                elseif ~isequal(studPlot.YData, solnPlot.YData)
                    msg = 'Your Y values are not correct';
                elseif ~isequal(studPlot.ZData, solnPlot.ZData)
                    msg = 'Your Z values are not correct';
                elseif ~isequal(studPlot.LineStyle, solnPlot.LineStyle)
                    msg = ['Your Line Styles are not correct ', ...
                        '(line styles are dashed, solid, none, etc. ', ...
                        'Run help plot for more information'];
                elseif ~isequal(studPlot.Marker, solnPlot.Marker)
                    msg = ['Your markers are not correct ', ...
                        '(markers are asterisk, pentagram, point, etc. ', ...
                        'Run help plot for more information'];
                elseif ~isequal(studPlot.PlotBox, solnPlot.PlotBox)
                    msg = ['Your axes (limits and/or scaling) aren''t correct ', ...
                        '(axes limits and scaling are affected by things ', ...
                        '"axis square", "axis equal", and "axes([#, #, #, #]). "', ...
                        'You might want to make sure you''ve set the axes correctly)'];
                elseif ~isequal(studPlot.Title, solnPlot.Title)
                    msg = 'Your title is incorrect';
                elseif ~isequal(studPlot.XLabel, solnPlot.XLabel)
                    msg = 'Your x label is incorrect';
                elseif ~isequal(studPlot.YLabel, solnPlot.YLabel)
                    msg = 'Your y label is incorrect';
                elseif ~isequal(studPlot.ZLabel, solnPlot.ZLabel)
                    msg = 'Your z label is incorrect';
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
                subplot(1, 2, 1);
                imshow(studPlot.Image);
                title('Student Plot');
                subplot(1, 2, 2);
                imshow(solnPlot.Image);
                title('Solution Plot');
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
    end
end
    
    