#!/usr/bin/octave -qf

#{
Args:
    X: Datos de entrenamientos 

Calcula el vector media y la matriz de proyección a partir de X
Return:
    m: vector media de X
    W: matriz de proyección ordenada de mayor a menor
Var:
    m: vector media de X
    Xm: X - m
    covarianza: matriz de covarianza de Xm
    eigvec: vector de vectores propios de covarianza
    eigval: valores propios del vector
    S: Valores de la diagonal de los datos de entrenamiento ordenador de mayor a menor
    I: Índice de la fila
#}

function [m,W]=pca(X)
  m = mean(X);
  Xm = X - m;
  covarianza = (Xm' * Xm)/rows(X);
  [eigvec, eigval] = eig(covarianza);
  [S, I] = sort(diag(eigval),"descend");
  W = eigvec(:,I);
  
  #visualiza los datos
  #for i =1:5
  #  xr=reshape(W(:,i),28,28);
  #  imshow((xr - 255)',[]) #255 -xr
  #  pause(5);
  #end
endfunction
