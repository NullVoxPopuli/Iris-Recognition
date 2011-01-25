function X = classify(elong,circ)
    if((elong < 1.09) && (elong > 0.99))
        if(circ > 11)
            X=3;
        else
            X=1;
        end
    else
        if(elong/circ < .1)
            X=2;
        else
            X=4;
        end
    end

end
