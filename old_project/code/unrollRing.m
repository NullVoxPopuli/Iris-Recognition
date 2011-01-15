% project Cartesian iris image to doubly dimensionless pseudopolar coordinate system
function [retNormalImg] = unrollRing(sourceimg, cin, cout)
% example call:
% img = rgb2gray(imread('017L_1.png'));
% out=unrollRing(img,[384 288 80],[384 288 255]);imshow(out);

    % params:
    %   sourceimg: processed iris image that is ready to be normalized
    %   cin: array containing information about the iris-pupil boundary
    %       circle (centerX, centerY, radius)
    %   cout: array containing information about the iris-sclera boundary
    %       circle (centerX, centerY, radius)
    
    % algoritm description
    % In(X,Y) = Io(x,y)
    % x = xp(theta) + ((xi(theta) - xp(theta)))Y/M
    % y = yp(theta) + ((yi(theta) - yp(theta)))Y/M
    % theta = 2*PI*X/N
    % In = M x N (64 x 512) normalized image
    % (xp(theta),yp(theta)) and (xi(theta),yi(theta)) are coords of inner
    % and outer boundary points in the direction of theta in the orginal
    % image Io
    
    % target dimensions
    M = 64;
    N = 512;
    
    retNormalImg = uint8(zeros(M,N));
    
    for X = 1:N
        for Y = 1:M
            theta = 2*pi*X/N;
            [xin, yin] = ptOnCircle(cin(1), cin(2), cin(3), theta);
            [xout, yout] = ptOnCircle(cout(1), cout(2), cout(3), theta);
            x = xin + (xout - xin)*Y/M;
            y = yin + (yout - yin)*Y/M;
            if y >= 1 & y <= size(sourceimg,1) & x >= 1 & x <= size(sourceimg,2)
                retNormalImg(Y,X) = sourceimg(y,x);
            end
        end
    end