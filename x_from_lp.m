function X = x_from_lp(line, plane)

% get the intersection point of a line and a plane
% line  -	the line specified by two 3D points
% plane -   the plane specified by three 3D points
% x     -   (output)the intersection point

line(end + 1 ,:) = 1;
L = line(:,1) * line(:,2)' - line(:,2) * line(:,1)';

PI = [cross(plane(:,1) - plane(:,3), plane(:,2) - plane(:,3)); ...
    -plane(:,3)'*cross(plane(:,1), plane(:,2))];

X = L * PI;

X = X ./ X(4);