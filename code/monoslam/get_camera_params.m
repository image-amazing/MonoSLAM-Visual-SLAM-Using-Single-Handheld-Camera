function cam = get_camera_params_copyroom()

% ASUS XTION PRO LIVE

% fx = 525.0; fy = 525.0; %// default focal length
% cx = 319.5; cy = 239.5; %// default optical center
% Eigen::Matrix4d Tk; %// k-th transformation matrix from trajectory.log

% %// translation from depth pixel (u,v,d) to a point (x,y,z)
% z = d / 1000.0;
% x = (u - cx) * z / fx;
% y = (v - cy) * z / fy; 

% %// transform (x,y,z) to (xw,yw,zw)
% Eigen::Vector4d w = Tk * Eigen::Vector4d(x, y, z, 1); 
% xw = w(0); yw = w(1); zw = w(2);

fx = 525.0;  % focal length x
fy = 525.0;  % focal length y
Cx = 319.5;  % optical center x
Cy = 239.5;  % optical center y


cam.k1 = 0;
cam.k2 = 0;

cam.fx = 525.0;
cam.fy = 525.0;
cam.f = 525.0;

cam.Cx = 319.5;
cam.Cy = 239.5;

cam.nrows = 480;
cam.ncols = 640;

cam.d = 1;
cam.dx = cam.d;
cam.dy = cam.d;


cam.K = [ -fx/cam.d, 0, Cx; 0, -fy/cam.d, Cy; 0, 0, 1 ];

