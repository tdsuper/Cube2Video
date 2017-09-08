function [regions, boundaryEdge] = getOverlapRegions(face, spherePoint)

regions = [];
npts = size(spherePoint, 2);

edges = zeros(npts, npts);
for i=1:size(face, 1)
    startP = face(i,1);
    endP = face(i,2);
    if edges(endP,startP) == 1
        edges(endP,startP) = 2;
        edges(startP,endP) = 2;
    else
        edges(startP,endP) = 1;
    end
    
    startP = face(i,2);
    endP = face(i,3);
    if edges(endP,startP) == 1
        edges(endP,startP) = 2;
        edges(startP,endP) = 2;
    else
        edges(startP,endP) = 1;
    end
    
    startP = face(i,3);
    endP = face(i,1);
    if edges(endP,startP) == 1
        edges(endP,startP) = 2;
        edges(startP,endP) = 2;
    else
        edges(startP,endP) = 1;
    end
end

[row, col] = find(edges == 1);

boundary = [row col];
boundaryEdge = boundary;

nregs = 0;

while size(boundary,1) ~= 0
    nregs = nregs + 1;
    startPt = boundary(1,1);
    currentPt = boundary(1,2);
    reg = boundary(1,1);
    boundary(1,:) = [];
    while startPt ~= currentPt
        reg = [reg currentPt];
        for i=1:size(boundary,1)
            if boundary(i,1) == currentPt
                break;
            end
        end
        
        if i<=size(boundary,1)
            if boundary(i,1) == currentPt
                currentPt = boundary(i,2);
            elseif boundary(i,2) == currentPt
                currentPt = boundary(i,1);
            end
            boundary(i,:) = [];
        end
        
    end
    regions(nregs).ptIdx = reg;
    regions(nregs).pts = spherePoint(:,reg);
end