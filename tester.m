%% tester: Automatically run all unit tests.
%
% tester will run the unit tests, and report as to which ones passed.
%
% S = tester() will run all unit tests, and return structure array S with
% the test name and its status
%
% S = tester(T1, T2, ...) will run the specified unit tests, specified as
% either character vectors or function handles, and their status will be in
% array S, wich has the same number of elements as the number of inputs.
%
% tester(___) will do the same as above, but will instead print the results
% onto the display
%
%%% Remarks
%
% Test names are the name of the test function, with or without the .m.
%
%%% Exceptions
%
% If a function evaluates with an error, the exception is caused and given
% as the reason

function status = tester(varargin)
    % change to our current dir for testing;
    orig = cd(fileparts(mfilename('fullpath')));
    cleaner = onCleanup(@()(cd(orig)));
    if isempty(varargin)
        inputs = [dir('*.m'); dir('*.p')];
        inputs = {inputs.name};
    else
        inputs = varargin;
    end
    
    handles = cellfun(@converter, inputs, 'uni', false);
    
    isParallel = ~isempty(gcp('nocreate'));
    
    status = struct('name', cell(1, numel(handles)), ...
        'status', cell(1, numel(handles)), ...
        'reason', cell(1, numel(handles)));
    for h = numel(handles):-1:1
        % set up call
        fun = handles(h);
        status(h).name = func2str(fun);
        if isParallel
            workers(h) = parfeval(@runTest, 2, fun);
        else
            [status(h).status, status(h).reason] = fun();
        end
    end
    if isParallel
        workers.wait();
        outs = workers.fetchOutputs();
        for h = 1:size(outs, 1)
            status(h).status = outs{h, 2};
            status(h).reason = outs{h, 3};
        end
    end
    
    if nargout == 0
        STATUS = {'Passed', 'Failed'};
        % for each test, print out
        for t = 1:numel(status)
            if status(t).status
                fid = 1;
            else
                fid = 2;
            end
            fprintf(fid, 'Test %s:\n\tStatus: %s\n\tReason: %s\n', ...
                status(t).name, ...
                STATUS{status(t).status + 1}, ...
                status(t).reason);
        end
        clear('status');
    end
end

function [passed, msg] = runTest(fun)
    close('all', 'force');
    try
        [passed, msg] = fun();
    catch e
        passed = false;
        msg = sprintf('Test Error: %s (%s)', e.identifier, e.message);
    end
end

function h = converter(inp)
    if isstring(inp)
        inp = char(inp);
    end
    if ischar(inp)
        if endsWith(inp, '.m') || endsWith(inp, '.p')
            inp = inp(1:end-3);
        end
        h = str2func(inp);
    elseif isa(inp, 'function_handle')
        h = inp;
    else
        throw(MException('TESTER:invalidInput', ...
            sprintf('Expected a string or function_handle; got %s', ...
            class(inp))));
    end
end