function out = testCase1_soln()
r = 2;
x = linspace(-r,r);
y = sqrt(r.^2-x.^2);
y2 =-1*sqrt(r.^2-x.^2);
plot(x,y,'k');
hold on 
plot(x,y2,'k');
end