function L = delEdgeLaplace(L, i, j)

    L(i,j) = 0;
    L(j,i) = 0;
    L(i,i) = L(i,i)-1;
    L(j,j) = L(j,j) -1;

end