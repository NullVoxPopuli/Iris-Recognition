clear
clc

global GRAY
global RED
global BLUE
global GREEN
GRAY = 4;
RED = 1;
BLUE = 3;
GREEN = 2;

directory = dir('*.png');
%for i = 1 : size(directory,1)
   
    filename = 'Iris.png';
    
    % Read in original iris image
    img = imread(filename);
    imgs(:,:,GRAY) = rgb2gray(img);
    imgs(:,:,RED)  = img(:,:,RED);
    imgs(:,:,BLUE) = img(:,:,BLUE);
    imgs(:,:,GREEN) = img(:,:,GREEN);
  
    
    [ row, column, radius ] = findPupilSizeAndLocation( img );
    [radius_2 ] = findScleraSizeAndLocation( img,row,column );
    height = size(img,1)/2;
    width = (size(img,2)/2);
    dist = max(height,width);
    H = [1 0;
        0 1;
        -column+width -row+height;];
    T = maketform('affine',H);
    bounds = findbounds(T,[1 1; [size(img,2) size(img,1)]]);
    %bounds(1,:) = [1 1];
    img_m = imtransform(img,T,'XData',[1 size(img,2)],'YData',[1 size(img,1)]);
    for k = 1:3 
        img2(:,:,k) = ImToPolar(img_m(:,:,k),radius/dist,radius_2/dist,(radius_2-radius)*2,(radius_2-radius)*2*pi);
    end
    imshow(uint8(img2));
    
   
    
    % Subsample by 2 to save computation
   % img = img(1:2:size(img,1),1:2:size(img,2));

    % Get the voters
    
    %figure;imshow(magnitude);
    %figure;imshow(direction);

    % Vote and determine winning circles for sclera and iris boundaries
%     for k=1:4
%         
%         [magnitude, direction] = getVoters(imgs(:,:,k));
%         [pseudo, bin, sWinner, pWinner] = FindWinners(magnitude, direction, imgs(:,:,k));
%         %imwrite(pseudo, ['pseudo_' filename]);
%         
%     end
    

    % Unroll Cartesian working area into doubly-dimensionless
    % pseudopolar coordinate system
    %rectangle = unrollRing(img, pWinner, sWinner);
    %figure;imshow(rectangle);
    %imwrite(rectangle, ['unrolled_' filename]);
%end