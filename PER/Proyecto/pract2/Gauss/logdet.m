%Calcula el determinante de una matriz sumando valores propios y aplica el logaritmo natural
%covarianza: matriz de entrada
function [det] = logdet(covarianza)

[eigvec, eigval] = eig(covarianza);
eigval(eigval == 0) = realmin;
eigval = log(eigval);

det = sum(sum(eigval));


endfunction
