function [x] = proj2plane(X)

% project a surface on the unit sphere to a plane which is tangent to the
% sphere
%
% X - the boundary of the surface, 3-by-npts matrix
% x - (output)the coordinates of the points on the plane, 2-by-npts matrix

% the point of tangency
normal = [mean(X(1,:)); mean(X(2,:)); mean(X(3,:))];
normal = normal ./ norm(normal);

% the projection point
projX = zeros(size(X));
for i=1:size(X,2)
    projX(:,i) = X(:,i) / (dot(normal, X(:,i)));
end

% the rotation axis
z = normal;
x = (projX(:,1) - normal) / norm(projX(:,1) - normal);
y = cross(z,x);

projX = projX - repmat(normal,[1 size(X,2)]);
plnX = [x y z]'*projX;
x = plnX(1:2, :);

