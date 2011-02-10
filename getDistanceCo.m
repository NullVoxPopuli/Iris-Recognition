function D = getDistanceCo(Fv1, Fv2)
    A = dot(Fv1, Fv2);
    B = sqrt((Fv1.^2)*ones(length(Fv1),1));
    C = sqrt((Fv2.^2)*ones(length(Fv2),1));
    
    
    D = A/(B*C);
end
    
