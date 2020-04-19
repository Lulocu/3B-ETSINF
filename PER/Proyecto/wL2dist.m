function D = wL2dist(X,Y,W)
% 
  %  for i=1 : rows(X)
  %  printf(" RowsX: %d \n ColumnsX: %d \n\n RowsY: %d \n ColumnsY: %d \n\n RowsW: %d \n ColumnsW: %d \n",rows(X),columns(X),rows(Y),columns(Y),rows(W),columns(W))
  %    %D(:,i) = sum(sqrt(W *(X(i,:)-Y).^2), 2);
  %    D(:,i) = sum(sqrt(W *X(i,:)-Y), 2);
  %    %D(:,i) = sum(sqrt(W.*(X(i,:)-Y)'.^2), 2);
  %    %D(:,i) = sum(abs(W.*((X(i,:)-Y)*(X(i,:)-Y))), 2);
  % end
 printf("TUS MUERTOS EN VINAGRE \n")


  for j = 1:columns(X)
    XX(:,:)=W(:,j).*X(:,j).*X(:,j);
  end
  %XX = sum(W.*X.*X,2);
 % %YY = sum(W*(Y.*Y)',2);
  YY = W*(Y.*Y)';
 % %D = XX + (YY'*(W*Y') - 2*X*Y');
 XY = 2*(W.*X)*Y';
 D = XX + (YY - XY);
  %D = XX + (YY - 2*(W.*X)*Y');
  printf(" RowsX: %d \n ColumnsX: %d \n\n RowsY: %d \n ColumnsY: %d \n\n ",rows(XX),columns(XX),rows(YY),columns(YY))
endfunction



%function D = wL2dist(X,Y,W)
%   XX = sum(W.*X.*X,2);
%
%    YY = W*(Y.*Y)';
%    XY = 2*(W.*X)*Y';
%
%    D = XX + (YY - XY);
%end