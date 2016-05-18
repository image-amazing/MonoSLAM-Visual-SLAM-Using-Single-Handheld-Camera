%
% script for visualization
%

function x_history = script_visualize( traj, mu_prev )

x_history = [];

global State;
global Param;

chi_095_2 = 5.9915; chi_099_2 = 9.2103;
chi_095_3 = 7.8147; chi_099_3 = 11.3449;

figure(1); clf;

% visualize 2D image with measurements and their uncertainty ellipsoids
subplot(1,2,1); hold off;
imshow( uint8(State.Ekf.I) ); hold on;


for i=1:State.Ekf.nL
    
    if (~isempty(State.Ekf.h{i}) && ~isempty(State.Ekf.S{i}))
        
        % draw matched points with 2D ellipses
        if State.Ekf.individually_compatible(i)
            plotUncertainEllip2D( State.Ekf.S{i}, State.Ekf.h{i}, chi_095_2, 'g', 1 );
            plot( State.Ekf.z{i}(1), State.Ekf.z{i}(2),'g*','Markersize',10);
            
        elseif ~State.Ekf.individually_compatible(i)
            plot( State.Ekf.h{i}(1), State.Ekf.h{i}(2), 'b*', 'MarkerSize', 10 );
            
        end
        
        if State.Ekf.individually_compatible(i)
            % draw bounding boxes around image patches
            rectangle('Position',...
                [ State.Ekf.z{i}-Param.patchsize_match; 2*Param.patchsize_match*ones(2,1)]', ...
                'EdgeColor','y', 'LineWidth',2);
            
            text(State.Ekf.z{i}(1)+3, State.Ekf.z{i}(2)+3, ...
                num2str(i), 'Color', 'blue', 'FontSize', 10);
        end
    end
    hold on;
end

% draw camera with 3D uncertainty ellipsoid
subplot(1,2,2);
hold on; grid on; axis equal;
xlabel('x'); ylabel('y'); zlabel('z');
xlim([-10 10]); ylim([-10 10]); zlim([-10 10]);

draw_camera( State.Ekf.mu, 'k', State.Ekf.Sigma, 18, 'b' ); hold on

xr = State.Ekf.mu(1:3);

for i = 1:State.Ekf.nL
    
    iL = State.Ekf.iL{i};
    h = State.Ekf.mu(iL);
    xyz = inversedepth2cartesian(h);
    
    if State.Ekf.individually_compatible(i)
        plot3(xyz(1), xyz(2), xyz(3), 'g*', 'LineWidth',2);
        vectarrow( xr, xyz, 'g' );
        
    else
        plot3(xyz(1), xyz(2), xyz(3), 'm*', 'LineWidth',2);
        
    end
    text(xyz(1), xyz(2), xyz(3), num2str(i));
    axis auto; axis equal;
    
    % draw uncertainty ellipsoid
    if State.Ekf.individually_compatible(i)
        cth = cos(h(4)); cphi = cos(h(5));
        sth = sin(h(4)); sphi = sin(h(5)); rho = h(6);
        dx_by_dy = [1 0 0 cth*cphi/rho    -sth*sphi/rho   -sth*cphi/rho^2
            0 1 0     0           -cphi/rho        sphi/rho^2
            0 0 1 -sth*cphi/rho   -cth*sphi/rho    -cth*cphi/rho^2];
        p_XYZ = dx_by_dy * State.Ekf.Sigma(iL,iL) * dx_by_dy';
        
        % if eig(p_XYZ) < 1000
        plotUncertainEllip3D(  p_XYZ, xyz, chi_095_2, 'r', 1 );
        % end
    end
    
    
end
view([-30,-30]);
hold off;



figure(3);
hold on; grid on;
if isempty(mu_prev)
    hold on; grid on;
    plot3(xr(1),xr(2),xr(3), 'rp', 'LineWidth',2, 'MarkerSize',15, 'MarkerFaceColor', 'r');
else
    plot3(xr(1),xr(2),xr(3), 'yp', 'MarkerSize',10,'MarkerFaceColor', 'y');
    hold on;
end
plotUncertainEllip3D(  State.Ekf.Sigma(1:3,1:3), State.Ekf.mu(1:3), chi_099_3, 'b', 0  );

axis auto; axis equal;

hold off;
