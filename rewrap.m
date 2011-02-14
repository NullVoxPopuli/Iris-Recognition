function [ wrappedImg, sectionedImg ] = rewrap( img )
%REWRAP Summary of this function goes here
%   Detailed explanation goes here

% find the areas to use
radStart = -pi / 3;
radFinish = pi / 3;
offset = 3 / 4;

[xDim, yDim, zDim] = size(img);
rowStep = int32(floor(xDim / 5));

start = int32([(radStart * (1 / (2 * pi)) + offset) * yDim, ((radStart - pi) * (1 / (2 * pi)) + offset) * yDim]);
finish = int32([(radFinish * (1 / (2 * pi)) + offset) * yDim, ((radFinish - pi) * (1 / (2 * pi)) + offset) * yDim]);

img(1:rowStep, :, :) = drawSections(img(1:rowStep, :, :), 4);
img(rowStep+1:rowStep*2, start(1):finish(1), :) = drawSections(img(rowStep+1:rowStep*2, start(1):finish(1), :), 2);
img(rowStep+1:rowStep*2, start(2):finish(2), :) = drawSections(img(rowStep+1:rowStep*2, start(2):finish(2), :), 2);
img(rowStep*2+1:rowStep*3, start(1):finish(1), :) = drawSections(img(rowStep*2+1:rowStep*3, start(1):finish(1), :), 4);
img(rowStep*2+1:rowStep*3, start(2):finish(2), :) = drawSections(img(rowStep*2+1:rowStep*3, start(2):finish(2), :), 4);
img(rowStep*3+1:rowStep*4, start(1):finish(1), :) = drawSections(img(rowStep*3+1:rowStep*4, start(1):finish(1), :), 8);
img(rowStep*3+1:rowStep*4, start(2):finish(2), :) = drawSections(img(rowStep*3+1:rowStep*4, start(2):finish(2), :), 8);

sectionedImg = img;

for i = 1 : 3
    wrappedImg(:,:,i) = PolarToIm(img(:,:,i), 0.2, 0.8, 800, 800);
end

%wrappedImg = img;

end

function [ drawnImg ] = drawSections( imgStrip, subDiv )

    [xDim, yDim, zDim] = size(imgStrip);
    idxStep = int32(floor(yDim / (subDiv + 1)));

    for i = 1 : subDiv + 1
        idxStart = idxStep * (i - 1) + 1;
        idxEnd = idxStep * i;
        
        imgStrip(:, idxStart: idxStart + 2, 1:3) = 0;
        imgStrip(:, idxStart: idxStart + 2, 2) = 1;
        imgStrip(:, idxEnd-2:idxEnd, 1:3) = 0;
        imgStrip(:, idxEnd-2:idxEnd, 2) = 1;
        imgStrip(xDim-2:xDim, :, 1:3) = 0;
        imgStrip(xDim-2:xDim, :, 2) = 1;
    end
    
    drawnImg = imgStrip;
end