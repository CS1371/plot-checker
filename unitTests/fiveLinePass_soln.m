%% One Line Pass
%
% One line, all passing
%
function fiveLinePass_soln
    hold on;
    plot(1:100, 1:100, 'b--');
    plot(2:200, 200:-1:2, 'k-');
    plot(5:-1:1, 10:-1:6, 'c*-.');
    plot(1:2:100, 1:2:100, 'kd');
    plot(1, 3, 'v');
end