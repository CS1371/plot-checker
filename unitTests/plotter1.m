% plots is num plots
% varargin is cell array of same length of polynomial coefficients
function plotter1(coeffs)
hold on
for a = coeffs(randperm(length(coeffs)));
    curpoly = a{1};
    x = 1:100+(rand(1)/10);
    y = polyval(curpoly, x)+(rand(1)/10);
    plot(x,y,'k');
    title('I am darkness','Color','r');
    xlabel('snek evilness');
    ylabel('snek niceness','Color','blue');
    axis([-20 20 -20 20])
end
hold off
end