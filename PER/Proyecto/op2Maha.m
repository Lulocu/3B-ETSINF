function W = Md4cweight(X,xl,alpha)
  clases = unique(xl);
  for i = clases
    ind = find(xl==i);
    datos = X(ind,:);
    varianza = var(datos)
    varianza = alpha * diag(cov(varianza)) + (1 - alpha) * eye(rows(varianza))
    W(ind,:) = 1/varianza
endfunction