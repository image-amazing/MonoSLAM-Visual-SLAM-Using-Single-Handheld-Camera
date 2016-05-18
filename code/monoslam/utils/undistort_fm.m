function uvu = undistort_fm( uvd, cam )

Cx = cam.Cx;
Cy = cam.Cy;
k1 = cam.k1;
k2 = cam.k2;
dx = cam.dx;
dy = cam.dy;

nPoints = size( uvd, 2 );
uvu = zeros( 2, nPoints );

for k = 1:nPoints;
    rd = sqrt( ( dx*(uvd(1,k)-Cx) )^2 + (dy*(uvd(2,k)-Cy) )^2 );
    uvu(1,k) = Cx + ( uvd(1,k) - Cx ) * ( 1 + k1*rd^2 + k2*rd^4 );
    uvu(2,k) = Cy + ( uvd(2,k) - Cy ) * ( 1 + k1*rd^2 + k2*rd^4 );
end

