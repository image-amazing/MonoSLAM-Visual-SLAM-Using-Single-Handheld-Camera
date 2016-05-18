%--------------------------------------------------------------------------
% f.m
%
% measurement model function
% 
% inputs:
%           u : input control
%           x : camera pose (13-dimensional)         
%
% output:
%
%--------------------------------------------------------------------------

function [xnew,a] = f(u, x, dt)

xnew = zeros(size(x));

% camera position
xnew(1:3) = x(1:3) + ( x(8:10) + u(1:3) ) * dt;

% linear velocity of the camera
xnew(8:10) = x(8:10) + u(1:3);

% angular velocity of the camera
xnew(11:13) = x(11:13) + u(4:6);

% quaternion
omega = x(11:13);
alpha = norm( omega*dt );
a = [ alpha; omega*dt/alpha ];
if alpha < eps
    q = [1 0 0 0]';
else
    % a = [ alpha; omega*dt/alpha ];
    q = [ cos(alpha/2);
        a(2)*sin(alpha/2)/norm(a);
        a(3)*sin(alpha/2)/norm(a);
        a(4)*sin(alpha/2)/norm(a) ];
end
xnew(4:7) = reshape( qprod(x(4:7),q), 4, 1 );
