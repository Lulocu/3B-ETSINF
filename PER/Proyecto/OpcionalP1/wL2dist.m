function D = wL2dist(X,Y,W)

XX = sum(W.*X.*X,2);
YY = W*(Y.*Y)';
D = XX + (YY - (2*(W.*X)*Y'));
endfunction