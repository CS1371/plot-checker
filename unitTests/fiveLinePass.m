%% One Line Pass
%
% One line, all passing
%
function fiveLinePass
    hold on;
    plot(1:120, 1:120, 'b--');
    plot(2:200, 200:-1:2, 'k-');
    plot(5:-1:1, 10:-1:6, 'c*-.');
    plot(1:2:104, 1:2:104, 'kd');
    plot(1, 3, 'v');
end