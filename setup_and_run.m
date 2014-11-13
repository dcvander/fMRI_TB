% Author: Davy Vanderweyen
% This script sets the parameters for running all the parameters
% of the toolbox and then runs the function run_fMRI_ts for
% each of them
% modularity is omitted because consensus gives better results
% (Lancichinetti % Fortunado, 2012)
load('X');
opts.f_l=0.01;                                 % default settings 
opts.f_h=0.1;
opts.type='fir';
opts.null_model=true;
correlation=input('Correlation type?','s');    % user input
opts.corrType=sprintf('%s',correlation);

a.name='betweenness';
b.name='degrees';
c.name='clustering';
d.name='eigenvector';
e.name='consensus';
e.tau=0.5;
e.buffsz=150;
e.reps=1000;
% f.name='modularity';
g.name='strength';
h.name='rich_club';
h.threshold_type='absolute';
h.thr=0.5;
i.name='pagerank';
i.d=0.85;
j.name='diversity';
j.tau=0.5;
j.reps=1000;
l.name='participation';
l.tau=0.5;
l.reps=1000;

run_fMRI_ts(X,opts,a)
run_fMRI_ts(X,opts,b)
run_fMRI_ts(X,opts,c)
run_fMRI_ts(X,opts,d)
run_fMRI_ts(X,opts,e)
% run_fMRI_ts(X,opts,f)
run_fMRI_ts(X,opts,g)
run_fMRI_ts(X,opts,h)
run_fMRI_ts(X,opts,i)
run_fMRI_ts(X,opts,j)
run_fMRI_ts(X,opts,l)