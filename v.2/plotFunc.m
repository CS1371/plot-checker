function plotFunc
x1 = 1:10;
y1 = sin(x1);

x2 = 1:.2:10;
y2 = 4*x2;
subplot(1, 2, 1)
plot(x1, y1, 'k');
subplot(1, 2, 2)
plot(x2, y2, 'r');
end