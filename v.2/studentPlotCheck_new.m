function [same, details] = studentPlotCheck_new(funName,varargin)
AXIS_TOL = .05; % The student's axis range can be off by this percent of the axis range and still be counted correct
%% initial set up
if verLessThan('matlab', 'R2015a')
    error('You must run the plot checker with MATLAB version R2015a or later.\nYou can visit software.oit.gatech.edu for the latest version of MATLAB.');
end
date = datevec(now);
if date(2)==4 && date(3)==1 && rand < .1 % if it's April Fools, play the rick-roll video 10% of the time
    if ispc
        ! start /max https://www.youtube.com/watch?v=dQw4w9WgXcQ
    elseif ismac
        ! open https://www.youtube.com/watch?v=dQw4w9WgXcQ
    else
        ! xdg-open https://www.youtube.com/watch?v=dQw4w9WgXcQ
    end
    fprintf('Happy April Fools Day!\n');
end
close all %closes all the open figure windows.
%% store the solution plot and student plot in figure handles
% first save the student plot
if exist([funName, '.m'], 'file')
    set(0,'DefaultFigureVisible','off'); % hide newly created figures
    try 
        figure
        feval(funName, varargin{:}); %Execute the function and all inputs of that function
        stud = gcf;% Give current figure handle (the same as a file handle for figures)
    catch
        set(0,'DefaultFigureVisible','on'); % reset default figure visibility
        error('Your function produced an error');
    end
    set(0,'DefaultFigureVisible','on'); % reset default figure visibility
else
    error('Could not locate function %s.\nMake sure you are in the correct directory.', funName);
end
set(0, 'DefaultFigureVisible', 'off')

% next save the solution plot
if exist([funName, '_soln.m'], 'file')
    try
        figure
        feval([funName '_soln'], varargin{:});% Execute the solution function
        soln = gcf;% get current figure handle
    catch
        set(0, 'DefaultFigureVisible', 'on');
        error('The solution function produced an error');
    end
    set(0,'DefaultFigureVisible','on'); % reset default figure visibility
else
    error('Could not locate solution function %s_soln.\nMake sure it is in your current directory.', funName);
end

%% now start checking stuff
same = true; % innocent until proven guilty
details = '';

% get a vector of solution axies and student axies
stud_children = stud.Children(:);
soln_children = soln.Children(:);

% make sure same number of subplots
if length(stud_children) ~= length(soln_children)
    same = false;
    details = sprintf('Your plot produced a different number of subplots than the solution.\nThe plot checker cannot continue.\n');
    return
end

% used to change output strings if there are multiple subplots
mult = length(soln_children) > 1;

% reorder subplots to follow the subplot numbering order
[~, idx] = sort(cellfun(@(x) -x(2) * 2 + x(1), {stud_children(:).Position}));
stud_children = stud_children(idx);

[~, idx] = sort(cellfun(@(x) -x(2) * 2 + x(1), {soln_children(:).Position}));
soln_children = soln_children(idx);
% check each subplot individually
for i = 1:length(soln_children)
    soln_axis = soln_children(i);
    soln_axis.View = [0, 90]; % normalize the view
    
    stud_axis = stud_children(i);
    stud_axis.View = [0, 90];
    
    % check axis labels
    diffs = {};
    if ~isequal(stud_axis.XLabel.String, soln_axis.XLabel.String)
        same = false;
        diffs = [diffs, 'x-axis'];
    end
    if ~isequal(stud_axis.YLabel.String, soln_axis.YLabel.String)
        same = false;
        diffs = [diffs, 'y-axis'];
    end
    if ~isequal(stud_axis.ZLabel.String, soln_axis.ZLabel.String)
        same = false;
        diffs = [diffs, 'z-axis'];
    end
    
    % format the details output string
    if ~isempty(diffs)
        if length(diffs) > 1
            diffs{end} = ['and ', diffs{end}];
        end
        if mult % if there are multiple subplots, add which one we are currently dealing with to the details
            details = sprintf('The %s label(s) in subplot %d differ(s) from the solution.', strjoin(diffs, ', '), i);
        else
            details = sprintf('The %s label(s) differ(s) from the solution.', strjoin(diffs, ', '));
        end
    end
    
    % check the title
    if ~isequal(stud_axis.Title.String, soln_axis.Title.String)
        same = false;
        if mult
            details = sprintf('%s\nThe title in subplot %d differs from the soluiton.', details, i);
        else
            details = sprintf('%s\nThe title differs from the soluiton.', details);
        end
    end
    
    diffs = {};
    % check x axis range
    range = AXIS_TOL * diff(soln_axis.XLim);
    if abs(stud_axis.XLim(1) - soln_axis.XLim(1)) > range || abs(stud_axis.XLim(2) - soln_axis.XLim(2)) > range
        same = false;
        diffs = [diffs, 'x-axis'];
    end
    
    % check y axis range
    range = AXIS_TOL * diff(soln_axis.YLim);
    if abs(stud_axis.YLim(1) - soln_axis.YLim(1)) > range || abs(stud_axis.YLim(2) - soln_axis.YLim(2)) > range
        same = false;
        diffs = [diffs, 'y-axis'];
    end
    
    % check z axis range
    range = AXIS_TOL * diff(soln_axis.ZLim);
    if abs(stud_axis.ZLim(1) - soln_axis.ZLim(1)) > range || abs(stud_axis.ZLim(2) - soln_axis.ZLim(2)) > range
        same = false;
        diffs = [diffs, 'z-axis'];
    end
    
    % format the details output string
    if ~isempty(diffs)
        if length(diffs) > 1
            diffs{end} = ['and ', diffs{end}];
        end
        if mult % if there are multiple subplots, add which one we are currently dealing with to the details
            details = sprintf('%s\nThe %s range(s) in subplot %d differ(s) from the solution.', details, strjoin(diffs, ', '), i);
        else
            details = sprintf('%s\nThe %s range(s) differ(s) from the solution.', details, strjoin(diffs, ', '));
        end
    end
    
    [same, details] = visualCompare(soln_axis, stud_axis, same, details, mult, i);
end
if same
    details = 'Your plot is identical to the solution function!';
else
    details = strtrim(details);
end
end

%% "visually" compare two plots
% converts to b/w images to compare data
% then compares histograms to determine color differences
function [same, details] = visualCompare(soln_axis, stud_axis, same, details, mult, sub)
SCALE = [100, 100]; % smaller numbers increase tolerance; both numbers should be the same. [100, 100] is enough to detect a single point difference
DIFFERENCE_FACTOR = 10; % larger number increases tolerance. Approximately equals the number of points allowed to be different
COLOR_TOL = 50; % larger number increase tolerance. Probably won't need to adjust this number

% first try to eliminate as many axis problems as possible
soln_axis.Visible = 'off';
stud_axis.Visible = 'off';

if soln_axis.XLim(1) < stud_axis.XLim(1)
    stud_axis.XLim(1) = soln_axis.XLim(1);
else
    soln_axis.XLim(1) = stud_axis.XLim(1);
end
if soln_axis.YLim(1) < stud_axis.YLim(1)
    stud_axis.YLim(1) = soln_axis.YLim(1);
else
    soln_axis.YLim(1) = stud_axis.YLim(1);
end
if soln_axis.ZLim(1) < stud_axis.ZLim(1)
    stud_axis.ZLim(1) = soln_axis.ZLim(1);
else
    soln_axis.ZLim(1) = stud_axis.ZLim(1);
end
if soln_axis.XLim(2) > stud_axis.XLim(2)
    stud_axis.XLim(2) = soln_axis.XLim(2);
else
    soln_axis.XLim(2) = stud_axis.XLim(2);
end
if soln_axis.YLim(2) > stud_axis.YLim(2)
    stud_axis.YLim(2) = soln_axis.YLim(2);
else
    soln_axis.YLim(2) = stud_axis.YLim(2);
end
if soln_axis.ZLim(2) > stud_axis.ZLim(2)
    stud_axis.ZLim(2) = soln_axis.ZLim(2);
else
    soln_axis.ZLim(2) = stud_axis.ZLim(2);
end

% convert the axis objects to images
soln_img = imresize(frame2im(getframe(soln_axis)), SCALE);
stud_img = imresize(frame2im(getframe(stud_axis)), SCALE);

% compute the background color of the solution plot to get a threshold for converting to black and white
intimg = soln_img(:, :, 1) + soln_img(:, :, 2) * 256 + soln_img(:, :, 3) * 256 ^ 2;
most = mode(mode(intimg));
[r, c] = find(intimg==most, 1); % look up the most common color
pix = soln_img(r, c, :);
SOLN_BW_THRESH = mean(pix) / 255;

% do the same thing for the student plot
intimg = stud_img(:, :, 1) + soln_img(:, :, 2) * 256 + soln_img(:, :, 3) * 256 ^ 2;
most = mode(mode(intimg));
[r, c] = find(intimg==most, 1); % look up the most common color
pix = stud_img(r, c, :);
STUD_BW_THRESH = mean(pix) / 255;

% compare the plots visually
fh = figure;
set(fh, 'Visible', 'off');
data_diff = sum(sum(im2bw(soln_img, SOLN_BW_THRESH) ~= im2bw(stud_img, STUD_BW_THRESH))); % calculate total difference
if data_diff > DIFFERENCE_FACTOR
    same = false;
    if mult % if there are multiple subplots, add which one we are currently dealing with to the details
        details = sprintf('%s\nThe data in subplot %d differs from the solution.', details, sub);
    else
        details = sprintf('%s\nThe data differs from the solution.', details);
    end
else
    for i = 1:size(soln_img, 3) % for each layer in the image
        soln_hist = imhist(soln_img(:, :, i));
        stud_hist = imhist(stud_img(:, :, i));
        if sum(abs(soln_hist - stud_hist)) > COLOR_TOL
            same = false;
            if mult % if there are multiple subplots, add which one we are currently dealing with to the details
                details = sprintf('%s\nThe plot colors in subplot %d differs from the solution.', details, sub);
            else
                details = sprintf('%s\nThe plot colors differ from the solution.', details);
            end
            break; % once we find one channel that is wrong, we don't need to keep going
        end
    end
end
end