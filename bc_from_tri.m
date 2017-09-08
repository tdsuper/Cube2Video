function bc = bc_from_tri(tri,x)

% get the barycentric coordinates of a given point
% tri - the three points, which are represented by column vectors
% x   - the given point
% bc  - (output) the barycentric coordinates

if size(tri, 1) ~= size(x, 1)
    error('different dimensions!');
end

if size(tri, 1) ~= 2 && size(tri, 1) ~= 3
    error('The dimension must be 2 or 3!');
end

if size(tri, 1) == 2
    tri(end+1,:) = 1;
end

if size(x, 1) == 2
    x(end+1,:) = 1;
end

BA = tri(:, 2) - tri(:, 1);
CA = tri(:, 3) - tri(:, 1);

N = cross(BA, CA);
SNN = sum(N.^2);

NA = cross(tri(:, 3) - tri(:, 2), x - tri(:, 2));
NB = cross(tri(:, 1) - tri(:, 3), x - tri(:, 3));
% NC = cross(tri(:, 2) - tri(:, 1), x - tri(:, 1));
alpha = N' * NA / SNN;
beta = N' * NB / SNN;
gamma = 1 - alpha - beta;
bc = [alpha; beta; gamma];