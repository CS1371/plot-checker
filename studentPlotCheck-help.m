% This is the MATLAB CS 1371 plot checker **Student Version** 
%
% It will take in a function name as a string and inputs required by the
% function. 
%
% Format: studentPlotCheck('funName',input1,input2...) 
%
% Input: (string) name of function
% Input: inputs required by the function being tested
% Output: txt file of differences
%
% Example:
% x = 1:5;
% y = sin(x);
% studentPlotCheck('uniqueFit',x,y)
% --> Produces a txt file showing differences between your function and the 
% soln file function.
%
% Tips: 
% 1) The function name must be string format and don't include .m or .p!
% ALSO: The additional inputs for the function must be in the same order the
% function takes it in. Input the function name only, not the solution
% function's name.
%
% 2) If there are differences displayed in the txt file, even if the plots
% look the same, your plot is not exactly the same compared to the solution file.