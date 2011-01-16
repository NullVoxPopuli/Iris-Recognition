function [retHMask, retVMask, retSum, retGradMagnitude, retGradDirect] = sobel(grayimg)
    %define edge masks
    hMask = [-1 0 1;
             -2 0 2;
             -1 0 1];
    
    vMask = [-1 -2 -1;
              0  0  0;
              1  2  1];
          
    %calculations go here…
	retHMask = filter2(hMask, grayimg, 'same');
    retVMask = filter2(vMask, grayimg, 'same');
    retSum = retHMask + retVMask;
    retGradMagnitude = sqrt(double(retHMask).^2+double(retVMask).^2);
    
    %normalize grad magnitude
    retGradMagnitude = retGradMagnitude - min(min(retGradMagnitude));
    retGradMagnitude = retGradMagnitude./max(max(retGradMagnitude));
    
    retGradDirect = atan2(double(retVMask),double(retHMask));