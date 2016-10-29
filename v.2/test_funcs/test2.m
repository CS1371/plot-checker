function test2
th = linspace(1, 2*pi + 1);
r = 2;
x = r*cos(th);
y = r*sin(th);
plot(x, y, 'r');
hold on
plot(x + 2, y - 3, 'b');
end