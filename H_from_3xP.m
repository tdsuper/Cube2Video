function [H, X] = H_from_3xP(c, P, CP)

% get the homography matrix from two matched triangles, camera matrixes and 
% the motion between cameras
% c  -   the matched triangles
% P  -   the camera matrixes
% CP -   the first camera's position
% H  -   the homography matrix (output)
% see-   "Image registration for image-based rendering."IEEE TIP 2005.

I = eye(3);

%{
if all(all(c(:,1,:) - c(:,2,:)))
    H = I;
    return;
end
%}

% get the 3D point of the plane in world coordinate
X1 = X_from_xP(c(:,:,1), P);
X2 = X_from_xP(c(:,:,2), P);
X3 = X_from_xP(c(:,:,3), P);

% the parameters of the plane
PI = [cross(X1(1:3) - X3(1:3), X2(1:3) - X3(1:3)); ...
    -X3(1:3)'*cross(X1(1:3), X2(1:3))];
PI = PI./PI(4);

% projective matrix
N = inv(P(1:3, 1:3, 1));

% H1 can transform the points in image 1 to the 3D points.
H1 = [( I - ( CP * PI(1:3)' ) ./ ( PI(1:3)' * CP + 1) ) * N;...
    -(PI(1:3)' * N) ./ ( PI(1:3)' * CP + 1)]; 

% H2 can transform the 3D points to the points in image 2.
H2 = P(:,:,2);

% the final homography matrix
H = H2 * H1;

% the 3D triangle
X = [X1(1:3), X2(1:3), X3(1:3)];

% affine matrix estimation
x1 = H*[c(:,1,1);1]; x1 = x1(1:2)/x1(3);
x2 = H*[c(:,1,2);1]; x2 = x2(1:2)/x2(3);
x3 = H*[c(:,1,3);1]; x3 = x3(1:2)/x3(3);

xp1 = c(:,2,1);
xp2 = c(:,2,2);
xp3 = c(:,2,3);

A = [0 0 0 -x1(1) -x1(2) -1
    x1(1) x1(2) 1 0 0 0
    0 0 0 -x2(1) -x2(2) -1
    x2(1) x2(2) 1 0 0 0
    0 0 0 -x3(1) -x3(2) -1
    x3(1) x3(2) 1 0 0 0];

b = [-xp1(2); xp1(1); -xp2(2); xp2(1); -xp3(2); xp3(1)];
affine = inv(A)*b;
affine = [affine(1) affine(2) affine(3);
    affine(4) affine(5) affine(6);
    0 0 1];
H = affine*H;




