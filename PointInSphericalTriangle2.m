function result = PointInSphericalTriangle2(tri, pt, lHand)

% test whether a point on unit sphere falls on a spherical triangle
% tri:      3*3 matrix, each column represents a vertex of the spherical triangle
% pt:       the point on the unit sphere to test
% lHand:    weather the coordinate system is left hand
% see       http://www.cs.brown.edu/~scd/facts.html

% test whether the point is on the inside of all three triangle edges
% be care of the orientation of the triangle (clockwise)

if lHand
    t1 = det([pt tri(:,1) tri(:,2)]);
    t2 = det([pt tri(:,2) tri(:,3)]);
    t3 = det([pt tri(:,3) tri(:,1)]);
else
    t1 = det([pt tri(:,2) tri(:,1)]);
    t2 = det([pt tri(:,3) tri(:,2)]);
    t3 = det([pt tri(:,1) tri(:,3)]);
end

% use 'eps' instead of 0 in case of floating point relative acuracy
if(t1>eps && t2>eps && t3>eps)
    result = 1;
else
    result = 0;
end