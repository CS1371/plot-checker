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
    generateTests();
    cleaner = onCleanup(@()(clean(orig)));
    if isempty(varargin)
        inputs = dir(['.' filesep 'unitTests' filesep '*_test.m']);
        inputs = {inputs.name};
    else
        inputs = varargin;
    end
    
    % add the right path
        
    isParallel = ~isempty(gcp('nocreate'));
    addpath(genpath(pwd));
        
    handles = cellfun(@converter, inputs, 'uni', false);
    
    status = struct('name', cell(1, numel(handles)), ...
        'status', cell(1, numel(handles)), ...
        'reason', cell(1, numel(handles)));
    for h = numel(handles):-1:1
        % set up call
        fun = handles{h};
        status(h).name = strtok(func2str(fun), '_');
        if isParallel
            workers(h) = parfeval(@runTest, 2, fun);
        else
            [status(h).status, status(h).reason] = runTest(fun);
        end
    end
    if isParallel
        while ~all([workers.Read])
            [idx, s, r] = workers.fetchNext();
            status(idx).status = s;
            status(idx).reason = r;
        end
    end
    
    if nargout == 0
        % for each test, print out
        for t = 1:numel(status)
            if status(t).status
                fprintf(1, 'Test %s: Passed\n', ...
                    status(t).name);
            else
                fprintf(2, 'Test %s: Failed - %s\n', ...
                    status(t).name, ...
                    status(t).reason);
            end
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
        if endsWith(inp, '.m')
            inp = inp(1:end-2);
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

function clean(orig)
    % delete p codes
    delete(['.' filesep 'unitTests' filesep '*_soln.p']);
    cd(orig);
end