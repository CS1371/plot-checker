%% Stress Test: stress test the plot checker
%
% generate 100 plots, all equal
function [passed, msg] = stressTest_test
    [passed, msg] = plotChecker(@stressTest, [10 10], 30:500, 1);
    if ~passed
        msg = sprintf('Expected passing; got %s', msg);
    end
end