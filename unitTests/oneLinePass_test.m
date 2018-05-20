%% One Line Pass
%
% One line, all passing
%
function [passed, msg] = oneLinePass_test
    [passed, msg] = checkPlots(@oneLinePass);
    if ~passed
        msg = sprintf('Expected pass; got %s', msg);
    end
end