%--------------------------------------------------------------------------
% runmonoslam.m
%
% main function to run the monoslam
% 
% input:
%   numSteps
%   pauseLen
%
%--------------------------------------------------------------------------


function runmonoslam(numSteps, pauseLen)

% rng('default');

global Param;
global State;

if ~exist('nSteps','var') || isempty(nSteps)
    nSteps = inf;
end

if ~exist('pauseLen','var')
    pauseLen = 0; % seconds
end



%===================================================
% Initalize Params, Data, State
%===================================================

init_mono_params();
init_mono_state();


%===================================================
% record / save result
%===================================================
Param.makeVideo = false;
if Param.makeVideo
    votype = 'VideoWriter';
    vo = VideoWriter('video_monoslam', 'MPEG-4');
    set(vo, 'FrameRate', min(5, 1/pauseLen));
    open(vo);
end

Param.do_save = true;
Param.do_visualize = true;

% ground-truth trajectory if there exists
traj = [];
% [traj] = mrLoadLog('../copyroom_png/copyroom_trajectory.log');

% final result will be saved in this file
filename = 'debug-copyroom-2.mat'; % 'traj-dataset2-w-update-stride-2-patch24-surf64.mat';

%===================================================
% MonoSLAM Iterations
%===================================================

% initial frame
t0 = Param.frame.init_id;
State.Ekf.t = t0;
State.Ekf.I = get_frame(t0);

% for drawing the trajectory
mu_prev = [];
mu_history = [];
Sigma_history = [];
pred_mu_history = [];
pred_Sigma_history = [];

ave_time_elapsed = 0;

for t = t0+1 : Param.frame.stride : Param.frame.end_id

    tic;
    
    %% map  management
    % check the total number of landmarks
    % detect new landmarks from the image, or
    % delete inappropriate landmarks from the map
    map_management();
    
    
    %% get control
    % assume stable camera motion with zero accelerations
    u = zeros(6,1);
    
    
    %% EKF predict state
    % given control, predict the 13-dimensional camera pose after delta t
    mono_predict_state( u, Param.dt );
    pred_mu_history = [ pred_mu_history, State.Ekf.mu( State.Ekf.iR ) ];
    pred_Sigma_history = [ pred_Sigma_history, State.Ekf.Sigma( State.Ekf.iR, State.Ekf.iR ) ];
    

    %% measurement prediction
    % predict where the features should be in the next image frame
    % compute zhat
    mono_predict_measurement();
    
    
    % For the original MonoSLAM:
    %   
    %   we need to warp the landmark templates
    %   considering the predicted camera pose (mu bar)
    %   State.Ekf.patch_init is warped into State.Ekf.patch_matching
    % 
    %   should warp patches here;
    
    
    %% load a frame
    State.Ekf.t = t;
    State.Ekf.I = get_frame(t);
    
    
    %% get measurement
    mono_feature_matching(true);
    % optional - one of our contribution
    % update_map();
    
    
    %% update
    % camera pose and the landmark positions should be updated
    mono_update();
    normalize_state_quaternion();
    
    
    %% visualize
    if Param.do_visualize
        xhist = script_visualize(traj, mu_prev);
    end
    mu_prev = State.Ekf.mu;


    %% save
    if Param.do_save
        mu_history = [ mu_history, State.Ekf.mu( State.Ekf.iR ) ];
        Sigma_history = [ Sigma_history, State.Ekf.Sigma( State.Ekf.iR, State.Ekf.iR ) ];
        if mod(t, 50) == 0
            save(filename, ...
                'mu_history', 'Sigma_history', ...
                'pred_mu_history', 'pred_Sigma_history', 'traj' );
        end
    end
   

    %% record
    % drawnow;
    % record video
    if Param.makeVideo
        F = getframe(gcf);
        switch votype
            case 'avifile'
                vo = addframe(vo, F);
            case 'VideoWriter'
                writeVideo(vo, F);
            otherwise
                error('unrecognized votype');
        end
    end
    if pauseLen > 0
        pause(pauseLen);
    end
    % compute_relative_pose_err( mu_history, xhist);
    
    time_elapsed = toc;
    ave_time_elapsed = ave_time_elapsed + time_elapsed;
    disp(ave_time_elapsed /  ( t - t0 ) * Param.frame.stride );
end
ave_time_elapsed = ave_time_elapsed / ( Param.frame.end_id - t0 ) * Param.frame.stride;
fprintf('Average time elapsed per iteration: %.4f\n\n', ave_time_elapsed);
save(filename, 'mu_history', 'Sigma_history', 'pred_mu_history', 'pred_Sigma_history', 'traj' );

