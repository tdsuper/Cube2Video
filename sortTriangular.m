function triIndex = sortTriangular(orgIndex)

triIndex = zeros(size(orgIndex));
triIndex(1, :) = orgIndex(1, :);
orgIndex(1, :)=[];
for i=1:size(triIndex,1)-1
    edgeArr = getEdgeArr(triIndex(1:i, :));
    idx = getAdjacentTri(edgeArr, orgIndex);
    triIndex(i+1, :) = orgIndex(idx, :);
    orgIndex(idx, :)=[];
end

function edgeArray = getEdgeArr(triArr)
triNum = size(triArr, 1);
edgeArray = zeros(triNum * 3, 2);
for i=1:triNum
    pt1 = max(triArr(i,1), triArr(i, 2));
    pt2 = min(triArr(i,1), triArr(i, 2));
    edgeArray((i - 1) * 3 + 1, :) = [pt1 pt2];
    
    pt1 = max(triArr(i,1), triArr(i, 3));
    pt2 = min(triArr(i,1), triArr(i, 3));
    edgeArray((i - 1) * 3 + 2, :) = [pt1 pt2];
    
     pt1 = max(triArr(i,2), triArr(i, 3));
    pt2 = min(triArr(i,2), triArr(i, 3));
    edgeArray((i - 1) * 3 + 3, :) = [pt1 pt2];
end

function idx = getAdjacentTri(edgeArr, triArr)
for i=1:size(triArr, 1)
    
    pt1 = max(triArr(i,1), triArr(i, 2));
    pt2 = min(triArr(i,1), triArr(i, 2));
    testArr = repmat([pt1 pt2],[size(edgeArr, 1) 1]);

    if size(find(sum(edgeArr==testArr,2)==2), 1) > 0
        idx = i;
        return;
    end
    
    pt1 = max(triArr(i,1), triArr(i, 3));
    pt2 = min(triArr(i,1), triArr(i, 3));
    testArr = repmat([pt1 pt2],[size(edgeArr, 1) 1]);
    if size(find(sum(edgeArr==testArr,2)==2), 1) > 0
        idx = i;
        return;
    end
    
    pt1 = max(triArr(i,3), triArr(i, 2));
    pt2 = min(triArr(i,3), triArr(i, 2));
    testArr = repmat([pt1 pt2],[size(edgeArr, 1) 1]);
    if size(find(sum(edgeArr==testArr,2)==2), 1) > 0
        idx = i;
        return;
    end
end
