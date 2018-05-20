function plotter2_soln(subplotdim, xdata, seed)
% subplotdim = vector of dimensions ex. [3, 4]
% xdata = vector of linear x data ex. 30:500
% seed = seed for rng
n = subplotdim(1);
m = subplotdim(2);
subSize = prod(subplotdim);
rng(seed);
randvec = rand(1,subSize)*10;
for i = 1:subSize
    ydata = xdata.^randvec(i);
    subplot(n,m,i)
    plot(xdata,ydata,'b')
end
end