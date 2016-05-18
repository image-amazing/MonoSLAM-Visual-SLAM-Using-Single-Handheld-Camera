%--------------------------------------------------------------------------
% init_mono_params.m
%
% initialize the parameters for monoslam
% 
% input:
% output:
%
%--------------------------------------------------------------------------

function init_mono_params


global Param;


%% Video recording

Param.makeVideo = true;


%% Image frame related

% directory and prefix
Param.frame.dir = 'data/dataset2/color';

Param.frame.prefix = ''; 
Param.frame.ext = 'png';
Param.frame.rate = 1/30;
Param.frame.trajectory = '../copyroom_png/copyroom_trajectory.log';
Param.frame.init_id =1;
Param.frame.end_id = 604;
Param.frame.stride = 1;

%% Camera related

Param.camera = get_camera_params;

%% Map related

% Param.map.encoding = 'XYZ';
Param.map.encoding = 'InverseDepth';
Param.map.min_nL = 12; % minimum number of landmarks in the map


%% EKF related

% Param.updateMethod = 'seq';
Param.updateMethod = 'batch';


%% Process model related (noise param)

Param.sigma.a_noise = 0.0070; 
Param.sigma.alpha_noise = 0.0070;
Param.sigma.image_noise = 1;

% Param.sigma.inverse_depth: influences confidence interval of inv depth
% e.g. rho_init=0.1 with sigma=0.5 results in 95% confidence interval of
%   [-0.9, 1.1] for inverse depth
Param.sigma.inverse_depth = 1;
Param.rho_init = 1; % initial inverse depth

Param.dt = 1/30; % time btw frames [sec]
Param.lambda = 10; % for uncertainty ellipse in feature init step


%% params for feature matching

Param.patchsize_match = 24; % this is half-size