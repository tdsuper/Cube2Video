function sphPos = cube2sphere(faceIdx, d, x, y)

% transform a point on the cube map to a unit 3D vector
%
% faceIdx:  the face index
%       d:  focal length
%   (x,y):  the coordinate
%
%  sphPos:  the output unit vector

switch faceIdx
    case 1
        if x <= d
            if y <= d
                phi = atan2(d-x, d-y);	
            else
                phi = atan2(y-d, d-x) + 0.5 * pi;
            end
        else
            if y <= d
                phi = atan2(d-y, x-d) + 1.5 * pi;
            else
                phi = atan2(x-d, y-d) + pi;
            end
        end
        theta = atan2(hypot(x-d, y-d), d);
    case 2
        phi = atan2(x-d, d) + 0.5 * pi;
        theta = atan2(y-d, d / abs(sin(phi))) + 0.5 * pi;
    case 3
        phi = atan2(x-d, d) + pi;
        theta = atan2(y-d, d / abs(cos(phi))) + 0.5 * pi;
    case 4
        phi = atan2(x-d, d) + 1.5 * pi;
        theta = atan2(y-d, d / abs(sin(phi))) + 0.5 * pi;
    case 5
        phi = atan2(x-d,d);
        theta = atan2(y-d, d / abs(cos(phi))) + 0.5 * pi;
    case 6
        if x <= d
            if y <= d
                phi = atan2(d-y, d-x) + 0.5 * pi;
            else
                phi = atan2(d-x, y-d);
            end
        else
            if y <= d
                phi = atan2(x-d, d-y) + pi;
            else
                phi = atan2(y-d, x-d) + 1.5 * pi;
            end
        end
        theta = pi - atan2(hypot(x-d, y-d), d);
end
phi = phi + pi;
sphPos = [sin(theta)*cos(phi); sin(theta)*sin(phi); cos(theta)];

