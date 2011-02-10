function D = getDistanceEu(Fv1, Fv2)
    A = (Fv1 - Fv2).^2;
    B = A*ones(length(A),1);
    
    D = sqrt(B);
end
    
