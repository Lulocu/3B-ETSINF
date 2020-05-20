% Computes the error rate of 
% of the test set Y with respect to training set X
% X  is a n x d training data matrix 
% xl is a n x 1 training label vector 
% Y is a m x d test data matrix
% yl is a m x 1 test label vector 
% epsilon is a value to use in Laplace
function [etr,edv]= bernoulli(Xtr,xltr,Xdv,xldvl,epsilon,threshold)

%sacamos clases y numero de clases
etiquetas=unique(xltr);

maxX=max(max(Xtr));
minX=min(min(Xtr));
Xtr=(Xtr>(minX+(maxX-minX)*threshold));
Xdv=(Xdv>(minX+(maxX-minX)*threshold));

for j = etiquetas'
    numerador = sum(Xtr(find(j==xltr),:));
    total = numerador / length(find(j==xltr));

    total = min(total,(1-epsilon));
    total = max(total,epsilon);

    Wc(j+1,:) = log(total) - log(1-total);
    priori = length(find(j==xltr))/length(Xtr);
    Wco(1, j+1) = log(priori) + sum(log(1-total));
end

    
%Wc = (Wc +epsilon) ./ sum(Wc +epsilon);

%Wco = log(Wco);
%Wc = log(Wc);

%Error test
gx =  Xtr * Wc'  + Wco;
[valor, ind] = max(gx,[],2);
% percentage of error
etr = mean((ind -1)!=xltr)*100; 


%Error validacion
gx = Xdv * Wc'  + Wco;
[valor, ind] = max(gx,[],2);
% percentage of error
edv = mean((ind -1)!=xldvl)*100; 


endfunction
