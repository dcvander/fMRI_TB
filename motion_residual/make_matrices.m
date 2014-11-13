% this script splits the subject matrix into two parts. One with
% the TSs and one with the  motion parameters; a behooving format 
% for analysis by the linRegSignalAndheadRotation.m function
% author: Davy Vanderweyen

in=input('Subject number?','s');
impo=importdata(in);              % import file
signalMatrix=impo.data(:,1:264);       % append TS files to signal matrix
motionMatrix=impo.data(:,265:270);     % append motion parameters to motion matrix
