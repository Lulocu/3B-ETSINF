#! /snap/bin/octave -qf

if (nargin!=6)
printf("Usage: bernoulli-eva.m <trdata> <trlabels> <tedata> <telabels> <epsilon> <threshold>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
epsilon=str2num(arg_list{5});
threshold=str2num(arg_list{6});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);

filename = "bernoulli-eva.out";
fid = fopen(filename,"w");

error = bernoulli(X,xl,Y,yl,epsilon,threshold);
fprintf(fid,"Error bernoulli con umbral = %f, epsilon = %d: %f \n",threshold,epsilon, error);
fclose(fid);