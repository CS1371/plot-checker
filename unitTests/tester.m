%% tester: Automatically run all unit tests.
%
% tester will run the unit tests, and report as to which ones passed.
%
% P = tester() will run all unit tests, and return structure array P with
% the test name and its status
%
% P = tester(T1, T2, ...) will run the specified unit tests, specified as
% either character vectors or function handles.
%
% tester(___) will do the same as above, but will instead print the results
% onto the display
%
%%% Remarks
%
% Test names are the name of the function, with or without the .m.
%
