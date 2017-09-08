function X = X_from_xP(c,P)

% Estimation of 3D point from image matches and camera matrices, linear.
% c -   the correspondence in 2D or 3D (homogeneous)
% P -   the camera matrices
% X -   (output) estimated 3D point

K = size(P,3);
%A = zeros(K*3, 4);
A = zeros(K*2, 4);

if size(c,1) ~= 2 && size(c,1) ~=3
    error('The points must be 2 or 3 dimensions!\n');
end

if size(c,1) == 2
    c(end+1,:) = 1;
end

for k = 1:K
%    crossM = [0         -c(3,k)     c(2,k)
%              c(3,k)    0           -c(1,k)
%              -c(2,k)   c(1,k)      0];
%    A((k-1)*3+1:(k-1)*3+3,:) = crossM * P(:,:,k);
    A((k-1)*2+1:(k-1)*2+2,:) = [c(1,k)*P(3,:,k) - c(3,k)*P(1,:,k);
                                c(2,k)*P(3,:,k) - c(3,k)*P(2,:,k);];
end

[dummy,dummy,X] = svd(A,0);
X = X(:,end);
X = X./X(4);