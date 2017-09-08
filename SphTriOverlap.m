function result = SphTriOverlap(tri1, tri2)

% test whether there are overlap regions between two spherical triangles
% tri1: 3*3 matrix, each column represents a vertex of the triangle
% tri2: the second spherical triangle


%% intersection test
result = greatCircleArcIntersect(tri1(:,1), tri1(:,2), tri2(:,1), tri2(:,2));
if result == 1
    return;
end

result = greatCircleArcIntersect(tri1(:,1), tri1(:,2), tri2(:,2), tri2(:,3));
if result == 1
    return;
end

result = greatCircleArcIntersect(tri1(:,1), tri1(:,2), tri2(:,3), tri2(:,1));
if result == 1
    return;
end

result = greatCircleArcIntersect(tri1(:,2), tri1(:,3), tri2(:,1), tri2(:,2));
if result == 1
    return;
end

result = greatCircleArcIntersect(tri1(:,2), tri1(:,3), tri2(:,2), tri2(:,3));
if result == 1
    return;
end

result = greatCircleArcIntersect(tri1(:,2), tri1(:,3), tri2(:,3), tri2(:,1));
if result == 1
    return;
end
result = greatCircleArcIntersect(tri1(:,3), tri1(:,1), tri2(:,1), tri2(:,2));
if result == 1
    return;
end

result = greatCircleArcIntersect(tri1(:,3), tri1(:,1), tri2(:,2), tri2(:,3));
if result == 1
    return;
end

result = greatCircleArcIntersect(tri1(:,3), tri1(:,1), tri2(:,3), tri2(:,1));
if result == 1
    return;
end

%% inside test
result = PointInSphericalTriangle2(tri1, tri2(:,1), 1);
if result == 1
    return;
end

result = PointInSphericalTriangle2(tri1, tri2(:,2), 1);
if result == 1
    return;
end

result = PointInSphericalTriangle2(tri1, tri2(:,3), 1);
if result == 1
    return;
end

result = PointInSphericalTriangle2(tri2, tri1(:,1), 1);
if result == 1
    return;
end

result = PointInSphericalTriangle2(tri2, tri1(:,2), 1);
if result == 1
    return;
end

result = PointInSphericalTriangle2(tri2, tri1(:,3), 1);
if result == 1
    return;
end