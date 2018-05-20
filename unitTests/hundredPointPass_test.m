%% hundred point test
%
% One hundred points, all pass
function [passed, msg] = hundredPointPass_test
    [passed, msg] = checkPlots(@hundredPointPass);
    if ~passed
        msg = sprintf('Expected passing, but got %s', msg);
    end
end