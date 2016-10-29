%% plotCheck compares the plot output of student and solution functions for equivalance
%
%   [same, details] = plotCheck(funcName, funcInputs ... )
%
%   Inputs:
%       (char) funcName: The name of the function you wish to check, as a
%           string (do NOT include '_soln')
%       (variable) funcInputs: The remaining inputs to this function are the
%           inputs that you would normally pass into the function that you
%           are checking
%
%   Outputs:
%       (logical) same: Whether or not your function produced a plot that is
%           visually the same as the solution function
%       (char) details: A string describing the differences (if any) that were
%           found between the plots
%
%   Example:
%       If you have a function called "testFunc" and the following test case:
%
%           testFunc(30, true, {'cats', 'dogs'})
%
%       Then to check the plot produced by "testFunc" against the solution
%       function "testFunc_soln" for this test case you would run:
%
%           [same, details] = plotCheck('testFunc', 30, true, {'cats', 'dogs'})
%
%       After this completed running, same would be a logical value of whether
%       or not the plots were the same and details will explain the differences
%       that were found, if any.
%
%   Notes:
%       Some things to watch out for that the plot checker occasionally has
%       difficulty identifying:
%
%       1.  Incorrect colors interfering with data comparison
%       2.  The order in which you plot overlapping elements interfering with
%           color comparison
%       3.  Small rounding errors causing axis ranges to be incorrect
%
%   Disclaimer:
%       This is the first semester we have used this function, so you will
%       likely come across cases where it does not work properly. In these
%       situations, you can run the solution function, then run your function
%       and look at the two plots. If you cannot identify ANY differences
%       between the two plots, then you will get full credit for your
%       submission. However, if you can see ANY differences between the plots,
%       your function output does not match the solution.
%
%       To make this function better in the future, if you do come across a
%       false negative or false positive, we ask that you email your solution
%       code as an attachment to efoyle3@gatech.edu with the subject line
%       "PLOT_CHECK_TEST_CASE". You can send multiple functions in one email if
%       you encounter a problem for multiple functions. Sending your code is
%       completely voluntary, but the more code we have to test the function on,
%       the better it will be in the future!

function [same, details] = plotCheck(funName,varargin)
VERSION = 1.0; % Do not change unless updating code

AXIS_TOL = .1; % The student's axis range can be off by this percent of the axis range and still be counted correct
FIG_SIZE = 1200; % FIG_SIZE x FIG_SIZE will be used as the fiure size. Even though we are downsampling, this is important to fully capture all data even if there are several subplots

%% check if user wants the version number
if strcmp(funName, '-version')
    same = VERSION;
    return;
end

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
close all % closes all the open figure windows.

%% store the solution plot and student plot in figure handles
% first save the student plot
if exist([funName, '.m'], 'file')
    set(0,'DefaultFigureVisible','off'); % hide newly created figures
    warning off; %#ok<*WNOFF>
    try 
        figure
        feval(funName, varargin{:}); %Execute the function and all inputs of that function
        stud = gcf;% Give current figure handle (the same as a file handle for figures)
    catch
        set(0,'DefaultFigureVisible','on'); % reset default figure visibility
        warning on; %#ok<*WNON>
        error('Your function produced an error');
    end
    set(0,'DefaultFigureVisible','on'); % reset default figure visibility
    warning on;
else
    error('Could not locate function %s.\nMake sure you are in the correct directory.', funName);
end

% next save the solution plot
if exist([funName, '_soln.m'], 'file')
    set(0,'DefaultFigureVisible','off'); % hide newly created figures
    warning off;
    try
        figure
        feval([funName '_soln'], varargin{:});% Execute the solution function
        soln = gcf;% get current figure handle
    catch
        set(0, 'DefaultFigureVisible', 'on');
        warning on;
        error('The solution function produced an error');
    end
    set(0,'DefaultFigureVisible','on'); % reset default figure visibility
    warning on;
else
    error('Could not locate solution function %s_soln.\nMake sure it is in your current directory.', funName);
end
set(0,'DefaultFigureVisible','on'); % make sure default visibility is reset
warning on;

%% now start checking stuff
same = true; % innocent until proven guilty
details = '';

% enlarge the figure size
set(stud, 'Position', [0, 0, FIG_SIZE, FIG_SIZE]);
set(stud, 'Color', [1 1 1]);
set(soln, 'Position', [0, 0, FIG_SIZE, FIG_SIZE]);
set(soln, 'Color', [1 1 1]);

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
    if mult
        details = sprintf('%s\n\nSubplot %d:', details, i);
    end
    soln_axis = soln_children(i);
    soln_axis.View = [0, 90]; % normalize the view
    
    stud_axis = stud_children(i);
    stud_axis.View = [0, 90];
    
    % check axis labels
    diffs = {};
    if ~isequal(stud_axis.XLabel.String, soln_axis.XLabel.String)
        same = false;
        diffs = [diffs, 'x-axis']; %#ok<*AGROW>
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
        details = sprintf('%s\nThe %s label(s) differ(s) from the solution.', details, strjoin(diffs, ', '));
    end
    
    % check the title
    if ~isequal(stud_axis.Title.String, soln_axis.Title.String)
        same = false;
        details = sprintf('%s\nThe title differs from the solution.', details);
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
        details = sprintf('%s\nThe %s range(s) differ(s) from the solution.', details, strjoin(diffs, ', '));
    end
    
    % visual compare
    [same, details] = visualCompare(soln_axis, stud_axis, same, details);
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
function [same, details] = visualCompare(soln_axis, stud_axis, same, details)
SCALE = [75, 75]; % smaller numbers increase tolerance; both numbers should be the same. [100, 100] is enough to detect a single point difference
DIFFERENCE_FACTOR = 20; % larger number increases tolerance. This is the number of pixels in the downsampled and filtered image that can be different
HIST_BINS = 16; % number of bins to use when creating color histograms
COLOR_TOL = .1; % angle in degrees by which any two histogram vectors may differ and still be considered equal
% first try to eliminate as many axis problems as possible
soln_axis.Visible = 'off';
stud_axis.Visible = 'off';

% sets both axis limits to the extrema of the two
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

% should probably expand the axies by a small percentage here so that
% the convolution doesn't get messed up around the edges

% convert the axis objects to images
soln_img = imresize(frame2im(getframe(soln_axis)), SCALE);
stud_img = imresize(frame2im(getframe(stud_axis)), SCALE);

% convert to black and white image
bw_soln = sum(soln_img, 3) == (255 * 3);
bw_stud = sum(stud_img, 3) == (255 * 3);

% debugging
% figure, imshow(bw_soln);
% figure, imshow(bw_stud);
% 
% figure, imshow(bw_soln ~= bw_stud);

% compare the plots "visually"
data_diff = sum(sum(bw_soln ~= bw_stud)); % calculate total difference
if data_diff > DIFFERENCE_FACTOR
    same = false;
    details = sprintf('%s\nThe data values differ from the solution.\nCannot check colors until data is the same.', details);
else
    for i = 1:size(soln_img, 3) % for each layer in the image
        soln_hist = imhist(soln_img(:, :, i), HIST_BINS);
        stud_hist = imhist(stud_img(:, :, i), HIST_BINS);
        % calculate angle between these two vectors
        th = acosd(dot(stud_hist, soln_hist) / (norm(stud_hist) * norm(soln_hist)));
        if th > COLOR_TOL
            same = false;
            details = sprintf('%s\nThe colors differ from the solution.', details);
            break; % once we find one channel that is wrong, we don't need to keep going
        end
    end
end
end