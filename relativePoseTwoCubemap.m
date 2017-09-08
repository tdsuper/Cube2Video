function [P12, inliers] = relativePoseTwoCubemap(im1, im2, pt1, pt2)

% relativePoseTwoCubemap - estimate the relative pose of two cube maps
%
% Input  - im1  -> the first cube map
%        - im2  -> the second cube map
%        - pt1  -> the matching points in the first image
%        - pt2  -> the matching points in the second image
%
% Output - P12  -> 3x4 Correct camera matrix (rotation and translation)
%      inliers  -> the inlier matching points index


fHeight = size(im1,1) / 3;
fWidth = size(im1,2) / 4;
d = fHeight / 2;

T = zeros(3, 3, 6);
R = zeros(3, 3, 6);

frontPts1 = zeros(3, size(pt1,2));
frontPts2 = zeros(3, size(pt1,2));

TDPts1 = zeros(3, size(pt1,2));
TDPts2 = zeros(3, size(pt1,2));

K1 = [d 0 d; 0 d d; 0 0 1];
K2 = K1;
K = K1;

T(:,:,1) = [1 0 -d; 0 0 -d; 0 1 -d];
T(:,:,2) = [0 0 -d; 0 1 -d; 1 0 -d];
T(:,:,3) = [1 0 -d; 0 1 -d; 0 0 d];
T(:,:,4) = [0 0 d; 0 1 -d; -1 0 d];
T(:,:,5) = [-1 0 d; 0 1 -d; 0 0 -d];
T(:,:,6) = [1 0 -d; 0 0 d; 0 -1 d];

R(:,:,1) = [1 0 0; 0 0 1; 0 -1 0];
R(:,:,2) = [0 0 1; 0 1 0; -1 0 0];
R(:,:,3) = [1 0 0; 0 1 0; 0 0 1];
R(:,:,4) = [0 0 -1; 0 1 0; 1 0 0];
R(:,:,5) = [-1 0 0; 0 1 0; 0 0 -1];
R(:,:,6) = [1 0 0; 0 0 -1; 0 1 0];

% transform the feature points to the front face
for i=1:size(pt1,2)
    
    x = rem(pt1(2,i), fWidth);
    y = rem(pt1(1,i), fHeight);
    fIdx = pt1(3,i);
    frontPts1(:,i) = K * R(:,:,fIdx)' * inv(K) * [x;y;1];
    TDPts1(:,i) = T(:,:,fIdx) * [x;y;1];
    
    x = rem(pt2(2,i), fWidth);
    y = rem(pt2(1,i), fHeight);
    fIdx = pt2(3,i);
    frontPts2(:,i) = K * R(:,:,fIdx)' * inv(K) * [x;y;1];
    TDPts2(:,i) = T(:,:,fIdx) * [x;y;1];
end

t = .0005;
[F, inliers] = ransacfitfundmatrix(frontPts1, frontPts2, TDPts1, TDPts2, t, 0);

E = K' * F * K;

X_TestPoint = zeros(3,2);
for i=1:length(inliers)
    if pt1(3,inliers(i)) == 3 && pt2(3,inliers(i)) == 3
        X_TestPoint(:,1) = [pt1(2:-1:1,inliers(i))-[fWidth;fHeight];1];
        X_TestPoint(:,2) = [pt2(2:-1:1,inliers(i))-[fWidth;fHeight];1];
        break;
    end
end


[P12_4Possible] = getCameraMatrix(E);
[P12] = getCorrectCameraMatrix(P12_4Possible, K1,K2, X_TestPoint);

if P12(1,1)<0 && P12(2,2)<0 && P12(3,3)<0
    E = -E;
    [P12_4Possible] = getCameraMatrix(E);
    [P12] = getCorrectCameraMatrix(P12_4Possible, K1,K2, X_TestPoint);
end
