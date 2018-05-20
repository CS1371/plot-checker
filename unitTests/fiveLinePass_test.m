%% Five Line Pass
%
% five lines, all passing
function [passed, msg] = fiveLinePass_test
    [passed, msg] = checkPlots(@fiveLinePass);
    if ~passed
        msg = sprintf('Expected passing; got %s', msg);
    end