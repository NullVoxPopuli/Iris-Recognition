function [ radius ] = findScleraSizeAndLocation( img, row_center, column_center )
%FINDPUPILCENTER Summary of this function goes here
%[ radius ] = findScleraSizeAndLocation( img, row_center, column_center )
%   Detailed explanation goes here
SCLERA_THREASHOLD = .65;

img_hsv = rgb2hsv(img);
%imtool(img_hsv);
value = img_hsv(:,:,3);



mask = zeros(size(img,1),size(img,2));

mask(find(value<SCLERA_THREASHOLD)) = 1;
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

