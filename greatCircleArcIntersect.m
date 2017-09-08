function result = greatCircleArcIntersect(l1p1, l1p2, l2p1, l2p2)

% test whether a great circle arc interacts with other arc
% l1p1: the first vertex of the first arc
% l1p2:	the second vertex of the first arc
% l2p1:	the first vertex of the second arc
% l2p2:	the second vertex of the second arc
% see	http://geospatialmethods.org/spheres/GCIntersect.html#GCIGC

% the normal of the two plans which the great circles lie in
normal1 = cross(l1p1, l1p2);
normal1 = normal1 / norm(normal1);
normal2 = cross(l2p1, l2p2);
normal2 = normal2 / norm(normal2);

% lie in the same plane, which means the two arcs belong to the same great
% circle
if all(normal2 == normal1) || all(normal2 == -normal1)
    result = -1;
    return;
end

% solve equations
a = normal1(1);
b = normal1(2);
c = normal1(3);

d = normal2(1);
e = normal2(2);
f = normal2(3);

h = (d*c - f*a) / (e*a - d*b);
g = (-b*h - c) / a;

z = sqrt(1/(g*g + h*h + 1));

intPt1 = [g*z h*z z];
intPt2 = -intPt1;

% test whether the interaction point is on the arc
angleT = acos( (l1p1 * l1p2') / ( norm(l1p1) * norm(l1p2)) );
angle1 = acos( (intPt1 * l1p1) / ( norm(intPt1) * norm(l1p1)) );
angle2 = acos( (intPt1 * l1p2) / ( norm(intPt1) * norm(l1p2)) );

if angle1 + angle2 == angleT
    result = 1;
    %intPt1
    return;
end

angle1 = acos( (intPt2 * l1p1) / ( norm(intPt2) * norm(l1p1)) );
angle2 = acos( (intPt2 * l1p2) / ( norm(intPt2) * norm(l1p2)) );

if angle1 + angle2 == angleT
    result = 1;
    %intPt2
    return;
end

result = 0;