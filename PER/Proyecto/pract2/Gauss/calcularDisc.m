%probPrio: probabilidad a priori de g(x) de la clase
%media: media de la clase
%covarianza: matriz de covarianza de la clase
%Xdv:conjunto de datos a clasificar
function [probC] = calcularDisc(probPrio,media,covarianza, Xdv);


covarianza(covarianza == 0) = realmin;

proy = -1/2 .* pinv(covarianza);
vecLinealW= pinv(covarianza) * media';


vecPesos = log(probPrio) - 1/2 * logdet(covarianza) - 1/2 * media * pinv(covarianza) * media';


probC = sum((Xdv * proy) .* Xdv,2) +  (vecLinealW' * Xdv')' + vecPesos;
endfunction

