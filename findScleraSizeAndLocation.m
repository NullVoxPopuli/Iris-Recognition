function [ radius ] = findScleraSizeAndLocation( img, row_center, column_center )
%FINDPUPILCENTER Summary of this function goes here
%[ radius ] = findScleraSizeAndLocation( img, row_center, column_center )
%   Detailed explanation goes here
SCLERA_THREASHOLD = .85;

img_hsv = rgb2hsv(img);
%imtool(img_hsv);
value = img_hsv(:,:,3);

[r c] = find(value<SCLERA_THREASHOLD);

max_r = max(r)-row_center;
min_r = -min(r)+row_center;
max_c = max(c)-column_center;
min_c = -min(c)+column_center;


radius =( max_r + min_r + max_c + min_c )/ 4;



end

