%% Different Number of plots
%
% Student plots 1, solution plots 2
% Student plots 2, solution plots 1
% Student has no plots, solution plots 1
% Student has 1 plot, solution has no plots
% Student has no plots, solution has no plots
function [passed, msg] = differentNum_test
    [passed, msg] = plotChecker(@differentNum_stud0soln0);
    if ~passed
        msg = sprintf('Expected passing for both 0; got %s', msg);
        return;
    end
    passed = plotChecker(@differentNum_stud1soln0);
    if passed
        msg = 'Expected failure for student 1 solution 0; got passing';
        passed = false;
        return;
    end
    
    passed = plotChecker(@differentNum_stud0soln1);
    if passed
        msg = 'Expected failure for student 0 solution 1; got passing';
        passed = false;
        return;
    end
    passed = plotChecker(@differentNum_stud1soln2);
    if passed
        msg = 'Expected failure for student 1 solution 2; got passing';
        passed = false;
        return;
    end
    passed = plotChecker(@differentNum_stud2soln1);
    if passed
        msg = 'Expected failure for student 2 solution 1; got passing';
        passed = false;
        return;
    end
    passed = true;
    msg = '';
end