function [descriptors, locations] = siftCubemap(imgCube)

% relativePoseTwoCubemap - extract SIFT feature for cubic panorama in 
%                           Horizontal Cross format
%
% Input  - imgCube  -> the input cubic panorama
%
% Output - descriptors  -> the sift descriptors
%        - locations -> the feature point locations '[row col faceIdx]'

[height, width, ~] = size(imgCube);
fHeight = height / 3;
fWidth = width / 4;
assert(fHeight == fWidth);

faceOffX = [1 0 1 2 3 1];
faceOffY = [0 1 1 1 1 2];
descriptors = [];
locations = [];

for f = 1:6
    offTX = faceOffX(f);
    offTY = faceOffY(f);
    
    [descFace, locaFace] = sift(imgCube(fHeight*offTY+1:fHeight*(offTY+1), fWidth*offTX+1:fWidth*(offTX+1),:));
    descriptors = [descriptors; descFace];
    locaFace(:,3) = f;
    locaFace = locaFace(:,1:3) + repmat([fHeight*offTY fWidth*offTX 0],size(locaFace,1),1);
    locations = [locations; locaFace];
end
