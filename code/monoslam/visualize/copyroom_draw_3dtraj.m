function copyroom_draw_3dtraj

[ traj ] = mrLoadLog( '../copyroom_png/copyroom_trajectory.log' );

% figure(1);
% mrDrawTraj(traj);
% grid on; title('2d trajectory');


nrows = 480;
ncols = 640;

p0 = ones(4,1);
p_traj = [];


init_trans = traj(1).trans;
n = size( traj, 2 );
x = zeros( 3, n );
init_inverse = init_trans ^ -1;

for i = 1:5490
    
    assert( i == traj(i).info(end) );
    T = traj(i).trans;
    
    % load frame
    % rgb = imread( sprintf('../copyroom_png/color/%06d.png', i) );
    % depth = imread( sprintf('../copyroom_png/depth/%06d.png', i) );
    
    % initial point to track
    if i == 1
        p0 = [0 0 0 1]';
        p_traj = p0(1:3);
        p = p0;
    end
    

    m = init_inverse * traj( i ).trans;
    x( :, i ) = [ m( 1, 4 ); m( 2, 4 ); m( 3, 4 ) ];
    
    
    %     p = T * p;
    %     p(1:3) = p(1:3) / p(end);
    %     p_traj = [ p_traj, p(1:3) ];
    %
    %     if mod(i, 100) == 0
    %         figure(2);
    %         plot3(p_traj(1,:), p_traj(2,:), p_traj(3,:), '-bs', 'MarkerSize',1);
    %         grid on;
    %     end
end
plot3( -x( 1, : ), -x( 2, : ), -x( 3, : ), 'b-', 'LineWidth',2 ); hold on;
% plot3( -x(1,1:500), x(2,1:500), x(3,1:500), 'm-', 'LineWidth',2);
axis equal;

function xyz = uvd2xyz( uvd )

u = uvd(1);
v = uvd(2);
d = uvd(3);

fx = 525.0; fy = 525.0; % // default focal length
cx = 319.5; cy = 239.5; % // default optical center
% Eigen::Matrix4d Tk; % // k-th transformation matrix from trajectory.log

% // translation from depth pixel (u,v,d) to a point (x,y,z)
z = d / 1000.0;
x = (u - cx) * z / fx;
y = (v - cy) * z / fy;

xyz = [ x; y; z ];