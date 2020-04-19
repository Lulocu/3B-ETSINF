function W = Md4cweight(X,xl,alpha)

  clases = unique(xl);
  for i = 0:9
  
    ind = find(xl==i);
    datos = X(ind,:);
    covarianza = cov(datos);
    varianza = alpha * covarianza + (1-alpha)*eye(columns(X));
    vari(:,i+1) = diag(varianza);
  end
  W = 1./vari(:,xl+1)';
  %printf("%d \t %d \n",rows(W),columns(W))
endfunction
