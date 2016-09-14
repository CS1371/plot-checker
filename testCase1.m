function out = testCase1()

theta = linspace(0,2*pi);
r = 4;
x = r.*cos(theta);
y = r.*sin(theta);
plot(x,y,'k');
end