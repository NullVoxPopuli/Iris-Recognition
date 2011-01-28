function [ radius ] = findScleraSizeAndLocation( img, row_center, column_center )
%FINDPUPILCENTER Summary of this function goes here
%[ radius ] = findScleraSizeAndLocation( img, row_center, column_center )
%   Detailed explanation goes here
SCLERA_THREASHOLD1 = .65;
SCLERA_THREASHOLD2 = .09;
img_hsv = rgb2hsv(img);
%imtool(img_hsv);
value = img_hsv(:,:,3);
sat = img_hsv(:,:,2);
hue = img_hsv(:,:,1);



mask = zeros(size(img,1),size(img,2));

mask(find(value<SCLERA_THREASHOLD1)) = 1;
mask(find(hue<SCLERA_THREASHOLD2)) = 0;
mask(find(hue>(1-SCLERA_THREASHOLD2))) = 0;
mask(find(sat>(1-SCLERA_THREASHOLD2))) = 1;
mask = imopen(mask,strel('square',7));
%imtool(mask)
mask = Clean_Pupil(mask);

%imtool(mask)
[r c] = find(mask == 1);

max_r = max(r)-row_center;
min_r = -min(r)+row_center;
max_c = max(c)-column_center;
min_c = -min(c)+column_center;


radius =( max_r + min_r + max_c + min_c )/ 4;



end

