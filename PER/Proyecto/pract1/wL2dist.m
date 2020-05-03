function D = wL2dist(X,Y,W)

for j = 1:columns(X)
  XX(:,:)=W(:,j).*X(:,j).*X(:,j);
end

YY = W*(Y.*Y)';

%XY = 2*(W.*X)*Y';
%D = XX + (YY - XY);
D = XX + (YY - (2*(W.*X)*Y'));
endfunction