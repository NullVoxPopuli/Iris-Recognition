%Compareimgs

img1 = imread('image6.png');
img2 = imread('image6.png');
[im_1 FV1] = main(img1);
[im_2 FV2] = main(img2);

D = getDistanceCo(FV1,FV2);
disp(D);