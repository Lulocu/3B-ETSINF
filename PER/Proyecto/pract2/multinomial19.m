% Computes the error rate of 
% of the test set Y with respect to training set X
% X  is a n x d training data matrix 
% xl is a n x 1 training label vector 
% Y is a m x d test data matrix
% yl is a m x 1 test label vector 
% epsilon is a value to use in Laplace
function [etr,edv]= multinomial(Xtr,xltr,Xdv,xldvl,epsilon)

%sacamos clases y numero de clases
etiquetas=unique(xltr);

%Aplicar suavizado Laplace a los datos

%sumamos epsilon
Xtr = Xtr + epsilon;
Xdv = Xdv + epsilon;

%normalizamos
Xtr = Xtr ./ sum(Xtr,2);
Xdv = Xdv ./ sum(Xdv,2);

for j = etiquetas'

    
    %Índices de la clase que estoy mirando
    mClase = find(j==xltr);
    %Estimar probabilidad a priori

    priori = length(mClase)/length(xltr);%priori = length(find(j==xltr))./length(xltr);%priori = length(mClase)/length(xltr);
    %Estimar función densidad

    %Me guardo solo los datos de la clase que estoy mirando
    matrizClase =Xtr(mClase,:);%matrizClase =Xtr(find(j==xltr),:);%
    
    denominador = sum(matrizClase(:));
    numerador = sum(Xtr(mClase,:));%numerador = sum(Xtr(find(j==xltr),:),2);%

    
    Wco(j + 1,:) = priori;
    Wc(j + 1,:) = numerador/denominador;

    %Clasificador en forma de producto escalar
end
    Wco = log(Wco);
    Wc = log(Wc);

%Error test
for k = 1 : rows(Xtr)
    for l = etiquetas
            Cx(l+1,:) = Wc(l+1,:) * Xtr(k,:)' + Wco(l+1,:);
    end
    Cx = Cx .* -1;
    [max, index] = min(Cx,[],1);
    
    ClasificacionTr(k,:) = index - 1;
end

% percentage of error
etr = mean(xltr!=ClasificacionTr)*100; % error validacion


%Error validacion
%for k = 1 : rows(Xdv)
%    for l = etiquetas
%            Cxv(l +1,:) = Wc(l+1,:) * Xdv(k,:)'' + Wco(l +1,:)
%    end
%    Cxv = Cxv .* -1;
%    [max, index] = min(Cxv,[],1);
%    Clasificacion(k,:) = index - 1;
%end
for k = 1 : rows(Xdv)
    for l = etiquetas
            Cx(l+1,:) = Wc(l+1,:) * Xdv(k,:)' + Wco(l+1,:);
    end
    Cx = Cx .* -1;
    [max, index] = min(Cx,[],1);
    
    Clasificacion(k,:) = index - 1;
end

% percentage of error
edv = mean(xldvl!=Clasificacion)*100; % error validacion Clasificacion'


endfunction
