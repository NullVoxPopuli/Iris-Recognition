clear

directory = dir('*.png');
for i = 1 : size(directory,1)
    filename = directory(i).name;
    if strcmp(filename(1:8),'unrolled') | strcmp(filename(1:6),'pseudo') | ...
            exist(['unrolled_' filename])
        %continue
    end
    filename
    
    % Read in original iris image
    img = rgb2gray(imread(filename));

    % Subsample by 2 to save computation
    img = img(1:2:size(img,1),1:2:size(img,2));

    % Get the voters
    [magnitude, direction] = getVoters(img);
    %figure;imshow(magnitude);
    %figure;imshow(direction);

    % Vote and determine winning circles for sclera and iris boundaries
    [pseudo, bin, sWinner, pWinner] = FindWinners(magnitude, direction, img);
    imwrite(pseudo, ['pseudo_' filename]);

    % Unroll Cartesian working area into doubly-dimensionless
    % pseudopolar coordinate system
    rectangle = unrollRing(img, pWinner, sWinner);
    %figure;imshow(rectangle);
    imwrite(rectangle, ['unrolled_' filename]);
end