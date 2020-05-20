% Computes the error rate of 
% of the test set Y with respect to training set X
% X  is a n x d training data matrix 
% xl is a n x 1 training label vector 
% Y is a m x d test data matrix
% yl is a m x 1 test label vector 
% alphas is a value to use in flat smoothing
function [ert, erv] = gaussian(Xtr, xltr, Xdv, xldv, alphas)

etiquetas=unique(xltr);

for j = etiquetas'
    MatrizClase = Xtr(find(j==xltr),:);
    ElementosC = length(MatrizClase);
    medias(j+1,:) = mean(MatrizClase);
    %auxVar = MatrizClase - medias(j+1,:);

    priori = ElementosC/length(xltr);
    probPrio(j + 1) = priori;
    
    covarianzas{j + 1} = cov(MatrizClase,1);%1/ElementosC * sum((auxVar * auxVar'));
    

end
aux = 1;
    %suavizado
for k = alphas


    for j = etiquetas'
        covSuavizada{j+1} = k * covarianzas{j + 1} + (1 - k) * eye(rows(covarianzas{j + 1}));
        %printf('\n covarianza\n')
        %rows(covarianzas{j+1})
        %columns(covarianzas{j+1})
        %printf('\n covarianzasSUAViZADA\n')
        %rows(covSuavizada{j+1})
        %columns(covSuavizada{j+1})
    end

   



    %Funcion discriminante datos entrenamientos
    for i = etiquetas'
        gE(:,i + 1) = calcularDisc(probPrio(i+1),medias(i+ 1,:),covSuavizada{i + 1}, Xtr);
    end
    %Funcion discriminante datos validacion
    for i = etiquetas'
        gV(:,i + 1) = calcularDisc(probPrio(i+1),medias(i+ 1,:),covSuavizada{i + 1}, Xdv);
    end


    %Clasificacion datos entrenamiento
    for i = etiquetas'
        [valor, indice] = max(gE,[],2);  %Si fuera por columnas max(gE)
        ert(aux) = mean((indice -1)!=xltr)*100; 
    end

    %Clasificacion datos validacion
    for i = etiquetas'
        [valor, indice] = max(gV,[],2);  %Si fuera por columnas max(gE)
        erv(aux) = mean((indice -1)!=xldv)*100; 
    end
    aux = aux + 1;
end   
endfunction
