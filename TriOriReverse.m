function bReverse = TriOriReverse(tri1,tri2)

% test whether two triangles are orientation reversed
% tri1: n*3 matrix, each column represents a vertex of the triangle
% tri2: the second spherical triangle

if ~all(size(tri1)==size(tri2))
    error('Triangle must have the same dimension!!');
end

[rows, npts] = size(tri1);

if npts ~=3
    error('The number of the vertexs must be 3!!');
end

 if rows~=2 && rows~=3
     error('The vertex must be 2D or 3D!!');
 end

if rows == 2
    tri1 = [tri1; ones(1, 3)];
    tri2 = [tri2; ones(1 ,3)];
end


det1 = det(tri1);
det2 = det(tri2);
 
bReverse = (det1 * det2) <= eps;