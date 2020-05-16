%Calcula el determinante de una matriz sumando valores propios y aplica el logaritmo natural
%covarianza: matriz de entrada
function [det] = logdet(covarianza)
%rows(covarianza)
%columns(covarianza)
[eigvec, eigval] = eig(covarianza);
det = sum(log(eigval));

endfunction