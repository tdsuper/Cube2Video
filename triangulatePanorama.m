function [face] = triangulatePanorama(spherePos1, spherePos2)

[face_num, face] = sphere_delaunay(size(spherePos1, 2), spherePos1);

% sort triangle
face = sortTriangular(face');

% topological constraints checking
i = 2;
reduceCount = 0;
while 1
    sample = spherePos2(:, face(i,:)); 
    srcTri = spherePos1(:, face(i,:)); 
    if ~SphTriTopoConsist(face(1:i-1,:), spherePos2, sample, srcTri)
        face(i, :) = [];
        reduceCount = reduceCount + 1;
    else
        i = i + 1;
    end
    
    if i > size(face, 1)
        break;
    end
end

fprintf('Number of mis-matches: %d \n', reduceCount );

% rematching
preRegions = [];

[regions, boundary] = getOverlapRegions(face, spherePos1);

while ~isequal(preRegions, regions)
    
    preRegions = regions;
    
    % re-triangulation these regions using constrained Delaunay triangulation
    for i=1:size(regions,2)
        pos = proj2plane(regions(i).pts);
        npts = size(pos, 2);
        constrain = zeros(npts, 2);
        constrain(:,1) = 1:npts;
        constrain(:,2) = constrain(:,1) + 1;
        constrain(npts,2) = 1;
        DT = DelaunayTri(pos(1,:)', pos(2,:)', constrain);
        inside = inOutStatus(DT);
        newFace = DT.Triangulation(inside,:);

        while size(newFace,1) ~= 0
            sample = spherePos2(:, regions(i).ptIdx(newFace(1, :))); 
            srcTri = spherePos1(:, regions(i).ptIdx(newFace(1, :))); 
            if SphTriTopoConsist(face(:,:), spherePos2, sample, srcTri)
                face = [face; regions(i).ptIdx(newFace(1, :))];
            end
            newFace(1, :) = [];
        end
    end
    [regions, boundary] = getOverlapRegions(face, spherePos1);
end