%% hundred point test
%
% One hundred points, all pass
function [passed, msg] = hundredPointPass_test
    [passed, msg] = plotChecker(@hundredPointPass);
    if ~passed
        msg = sprintf('Expected passing, but got %s', msg);
    end
end