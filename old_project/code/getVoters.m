function [retVotersMag, retVotersGradDirect] = getVoters(grayimg)
    % set constants
    votingThreshHigh = 0.1;
    votingThreshLow = 0.045;
    
    % perform the edge detection
    [HMask, VMask, Sum, GradMagnitude, GradDirect]=sobel(grayimg);
    
    % get the voters
    retVotersMag = zeros(size(grayimg));
    retVotersMag(find(GradMagnitude > votingThreshLow & GradMagnitude < votingThreshHigh)) = 1;
    retVotersMag = cleanVoters(retVotersMag);
    %figure;imshow(retVotersMag);
    retVotersMag(find(retVotersMag == 1)) = GradMagnitude(find(retVotersMag == 1));
    
    % get the gradient directions of the voters
    retVotersGradDirect = zeros(size(grayimg));
    retVotersGradDirect(find(retVotersMag > 0)) = GradDirect(find(retVotersMag > 0));
    
    %figure;imshow(retVotersMag);
    %figure;imshow(uint8(1*(255/(2*pi))*retVotersGradDirect));
    %imshow(uint8(255*GradMagnitude));figure;
    %imshow(uint8(1*(255/(2*pi))*GradDirect));