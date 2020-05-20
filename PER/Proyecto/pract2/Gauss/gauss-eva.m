#! /snap/bin/octave -qf

if (nargin!=5)
printf("Usage: gauss-eva.m <trdata> <trlabels> <tedata> <telabels> <alpha>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
alpha=str2num(arg_list{5});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);

filename = "gauss-eva.out";
fid = fopen(filename,"w");

[etr, edv] = gaussian(X,xl,Y,yl,alpha);
fprintf(fid,"Error gauss con alpha = %f: %f \n", alpha,edv);
fclose(fid);