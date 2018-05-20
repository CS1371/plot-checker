function plotter32_soln(plots, xdata, seed)
% plots = number of plots ex. 5
% xdata = vector of linear x data ex. 30:500
% seed = seed for rng
rng(seed);
randvec = (3-1).*rand(1,plots)+1;
rng(seed+1);
xshift = (2-(-2)).*rand(1,plots)-2;
rng(seed+2);
yshift = (2-(-2)).*rand(1,plots)-2;
colorvec = 'ymcrgbkymcrgbkymcrgbkymcrgbkymcrgbkymcrgbkymcrgbkymcrgbkymcrgbkymcrgbkymcrgbkymcrgbk';
curColors = colorvec(1:plots);
hold on
for i = 1:plots
    ydata = xdata.^randvec(i) + yshift(i);
    tempxdata = xdata + xshift(i);
    plot(tempxdata,ydata,colorvec(i))
end
axis([-10 10 -10 10])
end