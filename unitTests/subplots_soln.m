function subplots_soln
    subplot(2, 2, 1)
    plot(1:100, 1:100, 'b--');
    subplot(2, 2, 2)
    plot(1:5:50, 1:5:50, 'g*');
    subplot(2, 2, 3)
    plot(80:-9:1, 1:9:80, 'r-*');
    subplot(2, 2, 4)
    plot(5:20, 5:20, 'k');
end