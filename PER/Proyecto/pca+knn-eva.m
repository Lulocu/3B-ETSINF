#! /snap/bin/octave -qf

if (nargin!=5)
printf("Usage: pca+knn-eva.m <trdata> <trlabels> <tedata> <telabels> <k>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
tedata=arg_list{3};
telabs=arg_list{4};
k=str2num(arg_list{5});

load(trdata);
load(trlabs);
load(tedata);
load(telabs);
%
%%
%% HERE YOUR CODE
%%
%[m W] = pca(Xtr);
%for j=alpha
%    errsin = knn_opc2m(Xtr,xltr,Xdv,xldv,1,j);
%    printf("error sin pca amb alpha: %f %f\n",errsin, j);
%    for i=ks
%        XtrR = (Xtr-m)*W(:,1:i);
%        XdvR = (Xdv-m)*W(:,1:i);
%        err = knn_opc2m(XtrR,xltr,XdvR,xldv,1,j);
%        printf("error amb pca amb alpha amb i: %f %f %f\n",err,j, i);
%    end
%end
%
filename = "pca+knn-eva.out";
fid = fopen(filename,"w");


[m,trDataPCA] = pca(X);

proyX = (X -m) * trDataPCA(:,1:k);
proyY = (Y-m)*trDataPCA(:,1:k);


  errorPCA = knn(proyX,xl,proyY,yl,1);
  error = knn(X,xl,Y,yl,1);
  fprintf(fid,"Error PCA: %f \n Error no PCA: %f",errorPCA, error);
fclose(fid);