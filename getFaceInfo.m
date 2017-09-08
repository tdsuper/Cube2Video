function [fIdx, x, y] = getFaceInfo(im, iX, iY)

faceWidth = size(im,2)/4;
faceHeight = size(im,1)/3;

fIdx = floor( iY / faceHeight ) * 3;
if fIdx == 0
    fIdx = fIdx + 1;
elseif fIdx == 3
    fIdx = fIdx + floor(iX / faceWidth) - 1;
end

x = rem(iX, faceWidth);
y = rem(iY, faceHeight);
