close all
clear
clc

addpath('cvt')
addpath('MatlabTools')

weight = 0.5;

im1 = imread('cube3_1.jpg');
im2 = imread('cube3_2.jpg');
pano1 = imread('sphere3_1.jpg');
pano2 = imread('sphere3_2.jpg');

height = size(im1,1);
width = size(im1,2);
fWidth = width/4;
fHeight = height/3;

%% extract features
[descriptors1, locations1] = siftCubemap(im1);
[descriptors2, locations2] = siftCubemap(im2);

fprintf('\nThere are %d feature points in the first image.\n', length(locations1));
fprintf('There are %d feature points in the second image.\n', length(locations2));

%show(im1,1), hold on, plot(locations1(:,2),locations1(:,1),'r+');
%show(im2,2), hold on, plot(locations2(:,2),locations2(:,1),'r+');

%% feature matching

% putative matching
[m1, m2] = siftMatch2(descriptors1, descriptors2, locations1, locations2);
%drawMatches(im1, im2, m1, m2, 3, 'Putative matches');
fprintf('\n%d matching points\n', length(m2));

% use ransac to remove outliers
[P12, inliers] = relativePoseTwoCubemap(im1, im2, m1, m2);
fprintf('%d inliers\n', length(inliers));

im1Inliers = m1(:,inliers);
im2Inliers = m2(:,inliers);
%drawMatches(im1, im2, im1Inliers, im2Inliers, 4, 'Inlier matches');

%% triangulation

spherePos1 = zeros(3, size(im1Inliers, 2));
spherePos2 = zeros(3, size(im2Inliers, 2));

for i=1:size(im1Inliers,2)
    [fIdx, x, y] = getFaceInfo(im1, im1Inliers(2,i), im1Inliers(1,i));
    spherePos1(:, i) = cube2sphere(fIdx, floor(size(im1,1) / 3 / 2), x, y);
    
    [fIdx, x, y] = getFaceInfo(im2, im2Inliers(2,i), im2Inliers(1,i));
    spherePos2(:, i) = cube2sphere(fIdx, floor(size(im2,1) / 3  / 2), x, y);
end

[face] = triangulatePanorama(spherePos1, spherePos2);

%% compute warping matrix

% parameters of novel view
CP1 = zeros(3,1);
CP2 = -inv(P12(:, 1:3)) * P12(:, 4);
CPN = CP1*weight + CP2*(1-weight);

R1 = eye(3); q1 = dcm2quat(R1);
R2 = P12(:,1:3); q2 = dcm2quat(R2);
qn = slerp(q1, q2, 1-weight, eps);
RN = quat2dcm(qn);

spherePosN = zeros(size(spherePos1));

% the warping matrix
H1 = zeros(3, 3, size(face, 1));
H2 = zeros(3, 3, size(face, 1));

% the vertex position of the triangle in the local coordinate system
localPos1 = zeros(2, 3, size(face, 1));
localPos2 = zeros(2, 3, size(face, 1));
localPosN = zeros(2, 3, size(face, 1));

c = zeros(2, 2, 3);
P = zeros(3, 4, 2);

% coordinate system transform
spherePos1 = [spherePos1(2,:); -spherePos1(3,:); spherePos1(1,:)];
spherePos2 = [spherePos2(2,:); -spherePos2(3,:); spherePos2(1,:)];
spherePosN = [spherePosN(2,:); -spherePosN(3,:); spherePosN(1,:)];

% computation of the homography matrix
for i=1:size(face, 1)
    
    % local coordinate for input images
    [P1, x1] = xP_from_X(spherePos1(:,face(i,:)), [eye(3) zeros(3,1)]);
    [P2, x2] = xP_from_X(spherePos2(:,face(i,:)), P12);
    
    % find the feature point on the novel sphere
    c(:, 1, 1) = x1(:,1); c(:, 2, 1) = x2(:,1);
    c(:, 1, 2) = x1(:,2); c(:, 2, 2) = x2(:,2);
    c(:, 1, 3) = x1(:,3); c(:, 2, 3) = x2(:,3);
    P(:, :, 1) = P1; P(:, :, 2) = P2;
    
    [H, X] = H_from_3xP(c, P, CP1);
    
    X = X - repmat(CPN, 1, 3);
    X = [X(:,1)./norm(X(:,1)), X(:,2)./norm(X(:,2)), X(:,3)./norm(X(:,3))];
    X = RN * X;
    if dot(X(:,1), spherePos1(:,face(i,1))) <=0 && dot(X(:,1), spherePos2(:,face(i,1))) <=0
        X(:,1) = -X(:, 1);
    end
    if dot(X(:,2), spherePos1(:,face(i,2))) <=0 && dot(X(:,2), spherePos2(:,face(i,2))) <=0
        X(:,2) = -X(:,2);
    end
    if dot(X(:,3), spherePos1(:,face(i,3))) <=0 && dot(X(:,3), spherePos2(:,face(i,3))) <=0
        X(:,3) = -X(:,3);
    end
    
    spherePosN(:,face(i,:)) = X;    
    
     % local coordinate for novel view
    [PN, xN] = xP_from_X(spherePosN(:,face(i,:)), [RN, -RN*CPN]);
    
    localPos1(:,:,i) = x1;
    localPos2(:,:,i) = x2;
    localPosN(:,:,i) = xN;
    
    % homography matrix from novel sphere to sphere1
    
    % the correspondence points
    c(:, 1, 1) = xN(:,1); c(:, 2, 1) = x1(:,1);
    c(:, 1, 2) = xN(:,2); c(:, 2, 2) = x1(:,2);
    c(:, 1, 3) = xN(:,3); c(:, 2, 3) = x1(:,3);
    
    % the two camera matrix
    P(:, :, 1) = PN; P(:, :, 2) = P1;
    
    % the homography matrix
    [H, X] = H_from_3xP(c, P, CPN);
    H1(:,:,i) = H;
    
    % homography matrix from novel sphere to sphere2
    
    % the correspondence points
    c(:, 1, 1) = xN(:,1); c(:, 2, 1) = x2(:,1);
    c(:, 1, 2) = xN(:,2); c(:, 2, 2) = x2(:,2);
    c(:, 1, 3) = xN(:,3); c(:, 2, 3) = x2(:,3);
    
    % the two camera matrix
    P(:, :, 1) = PN; P(:, :, 2) = P2;
    
    % the homography matrix
    [H, X] = H_from_3xP(c, P, CPN);
    H2(:,:,i) = H;
end

%% interpolation
fprintf('\npanorama interpolation\n');
offset = [fWidth     0      fWidth    fWidth*2   fWidth*3    fWidth;
             0    fHeight   fHeight   fHeight     fHeight  fHeight*2];
outImg = zeros(fHeight*3, fWidth*4, 3);

for f = 1:6
    fprintf('face %d \n', f);
    for r = 1:fHeight
        if rem(r,50) == 0
            fprintf('y %d \n', r);
        end
        for c = 1:fWidth
            
            intSpherePoint = cube2sphere(f, ceil(fHeight / 2), c, r);
            intSpherePoint = [intSpherePoint(2); -intSpherePoint(3); intSpherePoint(1)];
            
            % get the triangle index in which the interpolation point lie
            inTriangle = 0;
            for t = 1:size(face,1)
                if PointInSphericalTriangle2(spherePosN(:,face(t,:)), intSpherePoint, 0)
                    inTriangle = 1;
                    break;
                end                    
            end
            
            if inTriangle
                
                intPlanepoint = x_from_lp([zeros(3,1) intSpherePoint], spherePosN(:,face(t,:)));
                x = localPosN(:, :, t) * inv(spherePosN(:,face(t,:))) * intPlanepoint(1:3);
                
                xp1 = H1(:,:,t)*[x;1];
                xp2 = H2(:,:,t)*[x;1];

                bc = bc_from_tri(localPos1(:,:,t), xp1(1:2)./xp1(3));
                
                X1 = spherePos1(:,face(t,:)) * bc;
                X1 = X1 ./ norm(X1);
                X1 = [X1(3); X1(1); -X1(2)];
                
                bc = bc_from_tri(localPos2(:,:,t), xp2(1:2)./xp2(3));
                X2 = spherePos2(:,face(t,:)) * bc;
                X2 = X2 ./ norm(X2);                
                X2 = [X2(3); X2(1); -X2(2)];
                
                theta = acos(X1(3));
                phi = atan2(X1(2), X1(1));
                phi = mod(phi + pi, 2*pi);
                theta = pi - theta;
                
                y = int32(theta*512/pi);
                x = int32(phi*512/pi);

                if ~y
                    y = y + 1;
                end

                if ~x
                    x = x + 1;
                end
                
                color1 = pano1(y, x,:);
                                
                theta = acos(X2(3));
                phi = atan2(X2(2), X2(1));
                phi = mod(phi + pi, 2*pi);
                theta = pi - theta;
                
                y = int32(theta*512/pi);
                x = int32(phi*512/pi);

                if ~y
                    y = y + 1;
                end

                if ~x
                    x = x + 1;
                end
                
                color2 = pano2(y, x, :);
                
                outImg(offset(2, f) + r, offset(1, f) + c, :) = ...
                        weight*color1 + (1-weight)*color2;
            end
            
        end
    end
    imwrite(uint8(outImg), 'inter.jpg');
end





