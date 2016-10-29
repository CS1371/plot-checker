function test2_soln
th = linspace(0, 2*pi, 75);
r = 2;
x = r*cos(th);
y = r*sin(th);
plot(x, y, 'r');
hold on
plot(x + 2, y - 3, 'b');
end