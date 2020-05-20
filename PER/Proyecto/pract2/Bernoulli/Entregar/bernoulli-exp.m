#! /snap/bin/octave -qf

if (nargin!=6)
printf('%d \n',nargin);
printf("Usage: bernoulli-exp.m <trdata> <trlabels> <epsilons> <threshold> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
epsilons=str2num(arg_list{3});
threshold=str2num(arg_list{4});
trper=str2num(arg_list{5});
dvper=str2num(arg_list{6});

load(trdata);
load(trlabs);

N=rows(X);
rand("seed",23); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);

filename = "bernoulli-exp.out";
fid = fopen(filename,"w");

for i = epsilons
  for j = threshold
    [etr, edv] = bernoulli(Xtr,xltr,Xdv,xldv,i,j);
    fprintf(fid,"%d\t%d\t%d\t%d \n",i,j, etr, edv);
    end
end;

fclose(fid);