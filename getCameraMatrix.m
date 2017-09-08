function [PXcam] = getCameraMatrix(E)

% get the camera matrix based on essential matrix
%
% E:    the essential matrix
% PXcam 3x4x4 Camera matrices(output)
% see   Multiple View Geometry in Computer Vision


[U,S,V] = svd(E);

W = [0,-1,0;1,0,0;0,0,1];

PXcam = zeros(3,4,4);

PXcam(:,:,1) = [U*W*V',U(:,3)];
PXcam(:,:,2) = [U*W*V',-U(:,3)];
PXcam(:,:,3) = [U*W'*V',U(:,3)];
PXcam(:,:,4) = [U*W'*V',-U(:,3)];