function D = wL2dist(X,Y,W)

    for i=1 : rows(X)
    D(i,:) = W(i,:) * (X(i,:) - Y(i,:) * X(i,:) - Y(i,:))
    D(i,:) = sqrt(D,(i,:))

    end

endfunction