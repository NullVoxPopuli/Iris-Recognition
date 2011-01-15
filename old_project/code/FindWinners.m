function [pseudo, bin, sWinner, pWinner] = FindWinners(magImg, dirImg, img)
% Subsample
%magImg = magImg(1:2:size(magImg,1),1:2:size(magImg,2));
%dirImg = dirImg(1:2:size(dirImg,1),1:2:size(dirImg,2));
%img = img(1:2:size(img,1),1:2:size(img,2));

% Define constants
radii = int16(0.4*size(magImg,1)): 2 : int16(0.49*size(magImg,1));
radii2 = int16(20:45);
border = 10;
thk = 1;
thk2 = 7;

% Create voting bins
bin = zeros(size(magImg,1),size(magImg,2),size(radii,2));
bin2 = zeros(size(magImg,1),size(magImg,2),size(radii2,2));

% Vote for iris/pupil boundary
for rIndex = 1 : size(radii2,2) % For each possible radius being considered
	radius = radii2(rIndex);
    for r = border : size(magImg,1)-border
        for c = border : size(magImg,2)-border
            if magImg(r,c) > 0 % If this pixel was determined to be a voter
                % Compute proposed centers of circles in both directions
                r1 = int16(r) + int16(radius*sin(dirImg(r,c)));
                c1 = int16(c) + int16(radius*cos(dirImg(r,c)));
                r2 = int16(r) - int16(radius*sin(dirImg(r,c)));
                c2 = int16(c) - int16(radius*cos(dirImg(r,c)));

                % Cast votes if proposed center is near image center
                if sqrt(double((r1-size(magImg,1)/2))^2+double((c1-size(magImg,2)/2)^2)) <= 50
                    bin2(r1-thk:r1+thk,c1-thk:c1+thk,rIndex) = ...
                        bin2(r1-thk:r1+thk,c1-thk:c1+thk,rIndex) + 1;
                end
                % Cast votes in other direction too
                if sqrt(double(r2-size(magImg,1)/2)^2+double((c2-size(magImg,2)/2)^2)) <= 50
                    bin2(r2-thk:r2+thk,c2-thk:c2+thk,rIndex) = ...
                        bin2(r2-thk:r2+thk,c2-thk:c2+thk,rIndex) + 1;
                end
            end
        end
    end
end

% Find local maxima for iris/pupil boundary
pWinners = [];
mostVotes = max(max(max(bin2)));
for rIndex = 1 : size(radii2,2)
    radius = radii2(rIndex);
    %binThresh = uint8(sqrt(double(radius)));
    binThresh = mostVotes - 1;
    for r = border : size(magImg,1) - border
       for c = border : size(magImg,2) - border
           maximum =  bin2(r,c,rIndex) > binThresh;
%            if maximum
%                 for rr = -thk2 : thk2
%                     for cc = -thk2 : thk2
%                         maximum = maximum & ((0==rr & 0==cc) | ...
%                             bin2(r,c,rIndex) > bin2(r+rr,c+cc,rIndex));
%                     end
%                 end
%             end
            if maximum
                pWinners = [pWinners transpose([r c radius bin2(r,c,rIndex)])];
            end
        end
    end
end

if size(pWinners,2) == 0
   error('No winners elected during voting for pupil boundary.');
end

% Vote for iris/sclera boundary
for rIndex = 1 : size(radii,2) % For each possible radius being considered
	radius = radii(rIndex);
    for r = border : size(magImg,1)-border
        for c = border : size(magImg,2)-border
            if magImg(r,c) > 0 % If this pixel was determined to be a voter
                % Compute proposed centers of circles in both directions
                r1 = int16(r) + int16(radius*sin(dirImg(r,c)));
                c1 = int16(c) + int16(radius*cos(dirImg(r,c)));
                r2 = int16(r) - int16(radius*sin(dirImg(r,c)));
                c2 = int16(c) - int16(radius*cos(dirImg(r,c)));

                % Cast votes if proposed center is within image bounds
 %               if r1 >= border & r1 <= size(magImg,1)-border & ...
  %                      c1 >= border & c1 <= size(magImg,2)-border
   %                 bin(r1-thk:r1+thk,c1-thk:c1+thk,rIndex) = ...
    %                    bin(r1-thk:r1+thk,c1-thk:c1+thk,rIndex) + 1;
     %           end
                % Cast votes in other direction too
                 if r2 >= border & r2 <= size(magImg,1)-border & ...
                         c2 >= border & c2 <= size(magImg,2)-border
                     bin(r2-thk:r2+thk,c2-thk:c2+thk,rIndex) = ...
                         bin(r2-thk:r2+thk,c2-thk:c2+thk,rIndex) + 1;
                 end
            end
        end
    end
end

% Find local maxima for iris/sclera boundary
sWinners = [];
mostVotes = max(max(max(bin)));
for rIndex = 1 : size(radii,2)
    radius = radii(rIndex);
    %binThresh = uint8(sqrt(double(radius)));
    binThresh = mostVotes - 1;
    %binThresh = 18;
    for r = border : size(magImg,1) - border
       for c = border : size(magImg,2) - border
           maximum =  bin(r,c,rIndex) > binThresh;
%            if maximum
%                 for rr = -thk2 : thk2
%                     for cc = -thk2 : thk2
%                         maximum = maximum & ((0==rr & 0==cc) | ...
%                             bin(r,c,rIndex) > bin(r+rr,c+cc,rIndex));
%                     end
%                 end
%             end
            if maximum
                sWinners = [sWinners transpose([r c radius bin(r,c,rIndex)])];
            end
        end
    end
end
size(sWinners,2)
if size(sWinners,2) == 0
    error('No winners elected during voting for sclera boundary.');
end

for i = 1 : size(sWinners,2)
    distances(i) = sqrt(double(pWinners(1,1)-sWinners(1,i))^2+double(pWinners(2,1)-sWinners(2,i))^2);
end
best = find(distances==min(distances));

% Draw circles over image
for i = 1 : 3
    pseudo(:,:,i) = im2double(img);
end
numPoints = 480;
for wIndex = 1 : size(sWinners,2)
    r1 = int16(sWinners(1,wIndex));
    c1 = int16(sWinners(2,wIndex));
    radius = int16(sWinners(3,wIndex));
    for i = 1 : numPoints
        angle = 2*pi*i/numPoints;
        r = (r1 + int16(radius*sin(angle)));
        c = (c1 + int16(radius*cos(angle)));
        if r >=1 & r <= size(pseudo,1) & c >= 1 & c <= size(pseudo,2)
            if wIndex == best(1)
                pseudo(r,c,2) = 1;
                pseudo(r,c,[1 3]) = 0;
            else
                pseudo(r,c,1) = 1;
                pseudo(r,c,2:3) = 0;
            end
        end
    end
end
numPoints = 240;
for wIndex = 1 : size(pWinners,2)
    r1 = int16(pWinners(1,wIndex));
    c1 = int16(pWinners(2,wIndex));
    radius = int16(pWinners(3,wIndex));
    for i = 1 : numPoints
        angle = 2*pi*i/numPoints;
        r = (r1 + int16(radius*sin(angle)));
        c = (c1 + int16(radius*cos(angle)));
        if r >=1 & r <= size(pseudo,1) & c >= 1 & c <= size(pseudo,2)
            pseudo(r,c,1) = 1;
            pseudo(r,c,2:3) = 0;
        end
    end
end

pWinner = pWinners([2 1 3],1);
if size(pWinners,2) > 1
    disp('More than one potential winner identified for pupil boundary');
end
sWinner = sWinners([2 1 3],best);

%figure;imshow(pseudo);