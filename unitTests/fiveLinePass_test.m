%% Five Line Pass
%
% five lines, all passing
function [passed, msg] = fiveLinePass_test
    [passed, msg] = plotChecker(@fiveLinePass);
    if ~passed
        msg = sprintf('Expected passing; got %s', msg);
    end