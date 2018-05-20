%% build: Build the plot checker
%
% build will build the plot checker
%
% build() builds the plot checker, zipping it as well

function build
    orig = cd(fileparts(mfilename('fullpath')));
    cleaner = onCleanup(@()(cd(orig)));
    
    status = tester();
    if ~all([status.status])
        throw(MException('PLOTCHECKER:build:testFailed', ...
            'Some unit tests fail'));
    end
    
    delete(['.' filesep 'release' filesep '*']);
    % pcode Plot
    pcode('Plot.m');
    pcode('checkPlots.m');
    movefile('*.p', ['.' filesep 'release']);
    
    % create docs
    fid = fopen('checkPlots.m', 'rt');
    code = char(fread(fid)');
    fclose(fid);
    data = mtree(code);
    code = strsplit(code, newline, 'CollapseDelimiters', false);
    code = code(1:(min(data.getlastexecutableline) - 1));
    fid = fopen(['.' filesep 'release' filesep 'checkPlots.m'], 'wt');
    fwrite(fid, strjoin(code, newline));
    fclose(fid);
    
    % zip up
    zip('release.zip', ['release' filesep '*']);
end