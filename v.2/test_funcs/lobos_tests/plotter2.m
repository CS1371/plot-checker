function plotter2(subplotdim, xdata, seed)
% subplotdim = vector of dimensions ex. [3, 4]
% xdata = vector of linear x data ex. 30:500
% seed = seed for rng
n = subplotdim(1);
m = subplotdim(2);
subSize = prod(subplotdim);
rng(seed);
randvec = rand(1,subSize)*10;
for i = randperm(length(randvec))
    xdata = linspace(xdata(1),xdata(end),round((2000-100)*rand(1)+100));
    ydata = xdata.^randvec(i) + rand(1)*10;
    subplot(n,m,i)
    plot(xdata,ydata,'b')
end
end