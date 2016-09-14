function out = testCase2_soln()

    subplot(2,2,1);
    plot([-1 1 1 -1 -1], [-1 -1 1 1 -1], 'r');
    subplot(2,2,2);
    plot([-2 2], [-2 -2], 'b');
    hold on
    plot([2 2], [-2 2], 'b');
    plot([2 -2], [2 2], 'b');
    plot([-2 -2], [2 -2], 'b');
end