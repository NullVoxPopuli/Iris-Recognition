%Compareimgs

img1 = imread('image9.png');
img2 = imread('image10.png');
[im_1 FV1] = main(img1);
[im_2 FV2] = main(img2);

D = getDistanceCo(FV1,FV2);
disp(D);

imwrite(uint8(im_1),'image_e_iris.png');
imwrite(uint8(im_2),'image_f_iris.png');
imwrite(reshape(FV1 / max(FV1), 255, 96),'image_e_FV.png');
imwrite(reshape(FV2 / max(FV2), 255, 96),'image_f_FV.png');