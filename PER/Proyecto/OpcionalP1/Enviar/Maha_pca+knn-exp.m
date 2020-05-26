#! /snap/bin/octave -qf

if (nargin!=6)
printf("Usage: pca+knn-exp.m <trdata> <trlabels> <ks> <%%trper> <%%dvper> <alpha>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
ks=str2num(arg_list{3});
trper=str2num(arg_list{4});
dvper=str2num(arg_list{5});
alpha=str2num(arg_list{6});

load(trdata);
load(trlabs);

N=rows(X);
rand("seed",23); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);

filename = "Mahapca+knn-exp.out";
fid = fopen(filename,"w");


[m,trDataPCA] = pca(Xtr);

for j = ks
  for i = alpha
    proyX = (Xtr -m) * trDataPCA(:,1:j);
    proyY = (Xdv-m)*trDataPCA(:,1:j);
    error = knnMaha(proyX,xltr,proyY,xldv,1,i);
    fprintf(fid,"%d \t %d \t %d \n",j, i, error);

  end
end;

fclose(fid);