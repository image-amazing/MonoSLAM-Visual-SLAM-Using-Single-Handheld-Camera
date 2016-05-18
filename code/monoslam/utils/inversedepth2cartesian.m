function [ cartesian ] = inversedepth2cartesian( inverse_depth )

rw = inverse_depth(1:3,:);
theta = inverse_depth(4,:);
phi = inverse_depth(5,:);
rho = inverse_depth(6,:);

m = [cos(phi).*sin(theta);   -sin(phi);  cos(phi).*cos(theta)];   
cartesian(1,:) = rw(1) + (1./rho).*m(1,:);
cartesian(2,:) = rw(2) + (1./rho).*m(2,:);
cartesian(3,:) = rw(3) + (1./rho).*m(3,:);