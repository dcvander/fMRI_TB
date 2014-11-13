function [interpolatedTS]=interpolateTS(filename)

% This function interpolates data points in between each TS with 
% a cubic aproximation. It finds how many brain regions there are 
% and apply interpolation for each!
% author: Davy vanderweyen

impo=importdata(filename);             % import data
a=impo.data(:,1:264);                  % extract TS values
[m,l]=size(a);                         % get the number of rows and columns 
interpolatedTS=zeros(2*m-1,l);         % pre-allocate matrix
for i=1:l
    x=1:m;
    y=a(:,i);
    xp=1:0.5:m;
    yi=interp1(x,y,xp,'spline');
    interpolatedTS(:,i)=yi;                         % each brain region is stored in column of the matrix
end

end