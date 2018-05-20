%% Snake Slightly Off
%
% Both produces *slightly* different snakes (but not enough to trigger
% ROUNDOFF_ERROR). Pass should fail
%
%
function [passed, msg] = snakeSlightlyOff_test
    coeffs = {1, 2, 3, 4, 5};
    [passed, msg] = plotChecker(@snakeSlightlyOff, coeffs);
    if passed
        msg = 'Expected failure; got passing';
    end
    passed = ~passed;
end