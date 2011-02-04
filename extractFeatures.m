function [ featureVector ] = extractFeatures( img )
%EXTRACTFEATURES Summary of this function goes here
%   Detailed explanation goes here

% find the areas to use
radStart = -pi / 3;
radFinish = pi / 3;
offset = 3 / 4;

[xDim, yDim, zDim] = size(img);
rowStep = xDim / 5;

start = int32([(radStart * (1 / (2 * pi)) + offset) * yDim, ((radStart - pi) * (1 / (2 * pi)) + offset) * yDim]);
finish = int32([(radFinish * (1 / (2 * pi)) + offset) * yDim, ((radFinish - pi) * (1 / (2 * pi)) + offset) * yDim]);

% find the features for the 7 sections
band1Features = extractStripFeatures(img(0:rowStep, :, :), 4);
band2LFeatures = extractStripFeatures(img(rowStep+1:rowStep*2, start(1):finish(1), :), 2);
band2RFeatures = extractStripFeatures(img(rowStep+1:rowStep*2, start(2):finish(2), :), 2);
band3LFeatures = extractStripFeatures(img(rowStep*2+1:rowStep*3, start(1):finish(1), :), 4);
band3RFeatures = extractStripFeatures(img(rowStep*2+1:rowStep*3, start(2):finish(2), :), 4);
band4LFeatures = extractStripFeatures(img(rowStep*3+1:rowStep*4, start(1):finish(1), :), 8);
band4RFeatures = extractStripFeatures(img(rowStep*3+1:rowStep*4, start(2):finish(2), :), 8);

featureVector = [band1Features, band2LFeatures, band2RFeatures, band3LFeatures, band3RFeatures, band4LFeatures, band4RFeatures];

end

function [featureVector] = extractStripFeatures(imgStrip, subDiv)
    % loop through and find histograms
    [xDim, yDim, zDim] = size(imgStrip);
    idxStep = int32(floor(yDim / (subDiv + 1)));
    
    featureIdx = 1;
    featureVector = zeros(1, subDiv * 15 * 3);
    
    for i = 1 : subDiv
        idxStart = idxStep * (i - 1) + 1;
        idxEnd = idxStep * i;
        for j = 1 : 3
            % find the histogram
            [counts, x] = imhist(uint8(imgStrip(:,idxStart:idxEnd,j)));
            
            % find the normalized samples from the histogram
            for k = 1 : 255/12
                featureVector(featureIdx) = counts(12 * k) / (xDim * double(idxStep));
                featureIdx = featureIdx + 1;
            end
        end
    end
end