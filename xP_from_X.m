function [P, x] = xP_from_X(X, NP)

% get camera matrix and 2D points define in image coordinate from the 3D
% points, and the normalized camera matrix
% X  -      the 3D points, represented by column vectors
% NP -      the 3x4 normalized camera matrix
% P  -      (output) the camera matrix
% x  -      (output) the 2D points define in local coordinate system

BA = X(:, 2) - X(:, 1);
CA = X(:, 3) - X(:, 1);

% local coordinates
cos_theta = dot(BA, CA) / (norm(BA)*norm(CA));
theta = acos(cos_theta);

x = zeros(2, 3);
x(1, 2) = norm(BA);
x(1, 3) = norm(CA) * cos_theta;
x(2, 3) = -norm(CA) * sin(theta);

% compute the 3D position of the point D which satisfy OD is perpendicular
% to the plane define by the 3D points.
PI = [cross(BA, CA); -X(:,1)'*cross(X(:,2), X(:,3))];
PI = -PI;
% the distance between original O and the plane PI
d = abs(PI(4)) / norm(PI(1:3));
% scaling
D = PI(1:3) .* d ./ norm(PI(1:3));

% compute the barycenter coordinate of the point D
SNN = sum(PI(1:3).^2); % norm of the normal
%NA = cross(X(:, 3) - X(:, 2), D - X(:, 2));
NB = cross(X(:, 1) - X(:, 3), D - X(:, 3));
NC = cross(X(:, 2) - X(:, 1), D - X(:, 1));
%alpha = PI(1:3)' * NA / SNN;
beta = PI(1:3)' * NB / SNN;
gamma = PI(1:3)' * NC / SNN;
beta = -beta;
gamma = -gamma;

% if abs(alpha + beta + gamma - 1.0) > eps
%     error('Error happens when calculating the barycenter coordinates!');
% end

% local coordinate
% lD = alpha * x(:,1) + beta * x(:,2) + gamma * x(:,3);
lD = beta * x(:,2) + gamma * x(:,3);

% intrinsic matrix
K = [d 0 lD(1);
     0 d lD(2);
     0 0 1];
 
 % rotation matrix
 Right = BA ./ norm(BA);
 Look = PI(1:3) ./ norm(PI(1:3));
 Up = cross(Look, Right);
 R = [Right Up Look]';
 
 % the camera matrix
 P = K * R * NP;



