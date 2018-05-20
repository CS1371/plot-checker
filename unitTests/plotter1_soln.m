function plotter1_soln(coeffs)
hold on
for i = 1:length(coeffs)
    curpoly = coeffs{i};
    x = 1:100;
    y = polyval(curpoly, x);
    plot(x,y,'k');
end
title('I am darkness');
xlabel('snek evilness');
ylabel('snek niceness');
axis([-20 20 -20 20])
hold off
end