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
% name of the function, or a function handle.
%
% You must ensure that the function and its solution (fun_soln.p) exist in
% the current folder.
%
%%% Exceptions
%
% Any exceptions thrown by the student are caught and re-issued as
% warnings.
%
