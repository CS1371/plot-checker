function plotter3(plots, xdata, seed)
% plots = number of plots ex. 5
% xdata = vector of linear x data ex. 30:500
% seed = seed for rng
rng(seed);
randvec = (3-1).*rand(1,plots)+1;
colorvec = 'ymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwkymcrgbwk';
curColors = colorvec(1:plots);
hold on
for i = randperm(length(randvec))
    xdata = xdata;
    ydata = xdata.^randvec(i);
    plot(xdata,ydata,colorvec(i))
end
axis([-10 10 -10 10])
end