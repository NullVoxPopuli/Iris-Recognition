img = rgb2gray(imread('017L_1.png'));
out=unrollRing(img,[384 288 80],[384 288 255]);
figure;imshow(out);
img = rgb2gray(imread('017L_2.png'));
out=unrollRing(img,[384 288 80],[384 288 255]);
figure;imshow(out);
img = rgb2gray(imread('017L_3.png'));
out=unrollRing(img,[384 288 80],[384 288 255]);
figure;imshow(out);