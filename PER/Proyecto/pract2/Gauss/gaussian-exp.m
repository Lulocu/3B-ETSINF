#! /snap/bin/octave -qf

if (nargin!=5)
  printf('%d \n',nargin);
  printf("Usage: Gaussian-exp.m <trdata> <trlabels> <alphas> <%%trper> <%%dvper>\n")
  exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
alphas=str2num(arg_list{3});
trper=str2num(arg_list{4});
dvper=str2num(arg_list{5});

load(trdata);
load(trlabs);

N=rows(X);
rand("seed",23); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);

filename = "gaussian-exp.out";
fid = fopen(filename,"w");

[etr, edv] = gaussian(Xtr,xltr,Xdv,xldv,alphas);
%%fprintf(fid,"%d \t %d \t %d \n",alpha(1,i), etr, edv);
for i = 1:length(alphas)
  fprintf(fid,"%d \t %d \t %d \n",alphas(i), etr(i), edv(i));
end

fclose(fid);

