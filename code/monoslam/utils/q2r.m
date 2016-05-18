%--------------------------------------------------------------------------
% q2r.m
%
% compute the rotation matrix R from the unit quaternion
% 
% input:  unit quaternion
% output: 3x3 rotation matrix
%
% Wonhui Kim (wonhui@umich.edu)
%--------------------------------------------------------------------------

function R = q2r(q)

assert(length(q) == 4);
q = q / norm(q); % assumes unit quaternion

qr = q(1);
qi = q(2);
qj = q(3);
qk = q(4);

R = zeros(3);

R(1,1) = qr^2 + qi^2 - qj^2-qk^2;
R(1,2) = -2*qr*qk + 2*qi*qj;
R(1,3) =  2*qr*qj + 2*qi*qk;

R(2,1) =  2*qr*qk + 2*qi*qj;
R(2,2) = qr^2 - qi^2 + qj^2 - qk^2;
R(2,3) = -2*qr*qi + 2*qj*qk;

R(3,1) = -2*qr*qj + 2*qi*qk;
R(3,2) =  2*qr*qi + 2*qj*qk;
R(3,3) = qr^2 - qi^2 - qj^2 + qk^2;
