function bConsist = SphTriTopoConsist(TRIS, spherePts, sample, srcTri)
bConsist = 1;

if TriOriReverse(srcTri, sample)
    bConsist = 0;
    return;
end

for i=1:size(TRIS,1)
    tri = spherePts(:,TRIS(i,:));
    if SphTriOverlap(tri, sample)
        bConsist = 0;
        return;
    end
end
