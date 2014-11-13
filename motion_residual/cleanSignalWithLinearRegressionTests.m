clear all; 
%Author: Derek Novo
%10/8/2014
%Examples for subtracting predictor residuals from source signal using linear
%regression test.

t = 0:0.01:10;

%----------- PREDICTORS -------------
a = sin(2*pi*1*t) + 1;
b = sin(2*pi*2*t) + 1;
c = sin(2*pi*3*t) + 6; %+1*randn(1,length(t));

target = sin(2*pi*4*t);
source = target + a + b + 0.2*c;

target2 = sin(2*pi*0.5*t);
source2 = target2 + 0.5*a + 0.5*b + 0.5*c + 10;

normSource = source/max(source);
normSource2 = source2/max(source2);
%sumofmeans = mean(a) + mean(b) + mean(c)
figure; plot(t,source2);
%b = regress(source2(:),[a;b;c]');
%[r,m,p] = regress(source2(:),[a;b;c]');
%figure; plot(t,p,'r');
figure; plot(t, linRegSignalAndHeadRotation_version_3(source2(:),[a;b;c]'));
%figure; plot(t,linRegSignalAndHeadRotation(source(:),[a;b;c]'),'k');
%figure; plot(t,target' - linRegSignalAndHeadRotation(source(:),[a;b;c]'));