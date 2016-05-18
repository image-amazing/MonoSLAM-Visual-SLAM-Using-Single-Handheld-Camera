

%% translation
%
% load('trajectory_openslam.mat')
% load('trajectory_openslam_modified_feature_matching___-.mat');


% load('trajectory-rectangular-constant-depth-stride-1-trial-1');
% 
% % load('trajectory_rectangular_stride_1.mat'); % dataset 2
% 
% % load('trajectory_rotation-1_stride_1'); % dataset 3
% % load('trajectory-rotation-1-stride-3-trial-3'); % dataset 3
% % load('trajectory-rotation-1-stride-3-w-update-map');
% load('trajectory-rect-stride-1-w-update-map-');
% 
% % load('trajectory-rotation-5-stride-1'); % dataset 4
% % load('trajectory-rotation-5-stride-1-trial-2');
% load('trajectory-rotation-5-stride-1-trial-2');
% load('traj-rect-varying-d-test-matching');
% load('traj-rot-inplane-w-update-map');

obj_wo = load('traj-rot-inplane-wo-update-map-time-stride-3');
obj_w = load('traj-rot-inplane-w-update-map-time-stride-3');

% [traj] = mrLoadLog('../copyroom_png/copyroom_trajectory.log');

% initial location
figure(1); clf;
plot3(0,0,0,'-pg', 'MarkerSize',10, 'LineWidth',2); hold on;

axis equal; grid on;
xlabel('x'); ylabel('y'); zlabel('z');

% mu_history = 10*mu_history;
for i = 1:size(mu_history,2)
    axis auto;
    if i < 500
        plot3(mu_history(1,i), mu_history(2,i), mu_history(3,i), '-b.');
    else
        plot3(mu_history(1,i), mu_history(2,i), mu_history(3,i), '-ro');
    end
    % pause(0.000001);
    hold on;
end

figure(2); clf;
mu_history = mu_history;
plot3(mu_history(1,:), mu_history(2,:), mu_history(3,:), '-b', 'LineWidth',2); hold on;
plot3(0,0,0,'-pg', 'MarkerSize',10, 'LineWidth',2); hold on;
grid on; axis equal; hold on;
xlabel('x'), ylabel('y'), zlabel('z');
view([-30 20]);
set(gca, 'FontSize',16)


% n = size(mu_history,2);
% x = zeros(3, n);
% init_trans = traj(1).trans;
% init_inv = init_trans^(-1);
% for k = 1:n
%     m = init_inv * traj(k).trans;
%     x(:,k) = m(1:3,4);
% end
% 
% x = -x;
% x(3,:) = -x(3,:);

% plot3( x(1,:), x(2,:), x(3,:), '-ro');






figure(3); % clf;
hold on; grid on;
subplot(1,3,1);
i = 1; j = 2;
plot( mu_history(i,:), mu_history(j,:), '-b','LineWidth',2); hold on;
% plot( x(i,:), x(j,:), '-r.');
% title('x-y');
axis equal; grid on;
xlabel('x','FontSize',16), ylabel('y','FontSize',16);
set(gca, 'FontSize',16)
xlim([-0.1,0.1]); ylim([-0.1,0.1]);

subplot(1,3,2);
i = 2; j = 3;
plot( mu_history(i,:), mu_history(j,:), '-b','LineWidth',2); hold on;
% plot( x(i,:), x(j,:), '-r.');
% title('y-z');
axis equal; grid on;
xlabel('y','FontSize',16), ylabel('z','FontSize',16);
set(gca, 'FontSize',16)
xlim([-0.1,0.1]); ylim([-0.1,0.1]);

subplot(1,3,3);
i = 3; j = 1;
plot( mu_history(i,:), mu_history(j,:), '-b','LineWidth',2); hold on;
% plot( x(i,:), x(j,:), '-r.');
% title('z-x');
axis equal; grid on;
xlabel('z','FontSize',16), ylabel('x','FontSize',16);
set(gca, 'FontSize',16)
xlim([-0.1,0.1]); ylim([-0.1,0.1]);


%% rotation

% figure(11); clf;
% grid on; hold on;
% 
% for i = 1:100,
% end



% linear velocity
figure(4); clf;
% plot3(mu_history(8,:), mu_history(9,:), mu_history(10,:), '-b'); hold on;
grid on; 
plot( (1:size(mu_history,2))*3/30, sqrt(sum(mu_history(8:10,:).^2,1)), '-b'); hold on;

% angular velocity
% figure(5); clf;
% plot3(mu_history(11,:), mu_history(12,:), mu_history(13,:), '-r'); hold on;
grid on; 
plot( (1:size(mu_history,2))*3/30, sqrt(sum(mu_history(11:13,:).^2,1)), '-r'); hold on;