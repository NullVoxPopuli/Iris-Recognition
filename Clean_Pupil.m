function Mask_fixed = Clean_Pupil(Mask_In)
%
%
%
image = Mask_In;
[image_labeled num] = bwlabel(image);
%imtool(image_labeled);

Data = zeros(num,4);

    for i=1:num
        [r c]  = find(image_labeled==i);
        if(length(r) < .02*size(Mask_In,1)*size(Mask_In,2))
            image(find(image_labeled == i))=0;
            continue;
        end
        cMean = mean(c);
        cNorm = c-cMean;
        rMean = mean(r);
        rNorm = r-rMean;
        M = [cNorm, rNorm];
        cov = M'*M;
        [evec eval] = eig(cov);
        Data(i,1) = i;
        Data(i,2) = max(max(eval));
        I = zeros(size(image,1),size(image,2));
        I(find(image_labeled==i))=1;
        [r c] = find(I>0);
        [boundary] = bwtraceBoundary(I,[r(1) c(1)],'E');
        perimeter_size=0;
        for k=1:size(boundary,1)-1
            r1 = boundary(k,1);
            c1 = boundary(k,2);
            r2 = boundary(k+1,1);
            c2 = boundary(k+1,2);
            if(r1==r2 || c1==c2)
                perimeter_size = perimeter_size + 1;
            else
                perimeter_size = perimeter_size + sqrt(2);
            end
        end 

        

        Data(i,1) = sqrt(max(max(eval))/min(max(eval)));
        Data(i,2) =  perimeter_size^2/sum(sum(I>0));%%sum(sum(I>0))*4*pi / perimeter_size^2 ;%4*Pi*A / P^2 1 is circle 0 is line
        shape = classify(Data(i,1),Data(i,2));
        if(~(shape==3))
             image(find(image_labeled == i))=0;
        end
        disp(shape);

    end
    disp(Data);
    %imtool(image)
Mask_fixed = image;
end