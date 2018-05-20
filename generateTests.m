%% generateTests: Generate tests in UnitTests folder
%
% This function correctly formats tests in the UnitTests Folder.
%
% generateTests() will generate all tests in the UnitTests folder.
%
%%% Remarks
%
% generateTests will create the right p-code and rename accordingly for
% each unit test
%
function generateTests
    orig = cd(fileparts(mfilename('fullpath')));
    cleaner = onCleanup(@()(cd(orig)));
    delete(['.' filesep 'unitTests' filesep '*_soln.p']);
    pcode(['.' filesep 'unitTests' filesep '*_soln.p'], '-inplace');
end