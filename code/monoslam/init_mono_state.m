%--------------------------------------------------------------------------
% init_mono_state.m
%
% initialize the state vector for monoslam
%
%--------------------------------------------------------------------------


function init_mono_state

global Param;
global State;

% time
State.Ekf.t = 0;         

% camera pose x = [r; q; v; omega] which is a 13-by-1 vector
% where r is a 3-dimensional camera position vector,
%       q is a 4-dimensional quaternion for camera orientation,
%       v is a 3-dimensional linear velocity of camera,
%       omega is a 3-dimensional angular velocity of camera
% Initially, camera is positioned in the origin of the world coord system,
% looking into the direction of the positive z-axis,
% and the camera is assumed to be unmoving
State.Ekf.mu = [0 0 0 1 0 0 0 eps eps eps eps eps eps]';
State.Ekf.mu = [0 0 0 1 0 0 0 0 0 0 eps eps eps]'; % 1e-15;
% State.Ekf.mu = [0 0 0 1 0 0 0 eps eps eps eps eps eps]'; % 1e-15;

% init covariance matrix
% 13-by-13 symmetric, positive-semidefinite matrix
sig = 0.025;
State.Ekf.Sigma = diag( [ eps eps eps eps eps eps eps 1 1 1 0.5 0.5 0.5 ] );
State.Ekf.Sigma = diag([ eps eps eps eps eps eps eps ...
                         sig^2 sig^2 sig^2 sig^2 sig^2 sig^2 ]);

% the state vector will be augmented with landmark positions as SLAM proceeds
switch Param.map.encoding
    case 'XYZ'
        State.Ekf.dimL = 3;
        
    case 'InverseDepth'
        State.Ekf.dimL = 6;   % we only implemented inverse depth parametrization
end

State.Ekf.iR    = 1:13;       % vector containing camera indices
State.Ekf.iM    = [];         % dimL*nL vector containing map indices
State.Ekf.iL    = {};         % nL cell array containing indices of landmark i
State.Ekf.sL    = [];         % nL vector containing signatures of landmarks
State.Ekf.nL    = 0;          % scalar number of landmarks

State.Ekf.status = [];
State.Ekf.matched = [];
State.Ekf.match_attempts = [];
State.Ekf.individually_compatible = [];

State.Ekf.z = {}; % measurement
State.Ekf.h = {}; % predicted measurement
State.Ekf.H = {};
State.Ekf.S = {};
State.Ekf.Q = {};

State.Ekf.init_t = [];
State.Ekf.init_z = {};
State.Ekf.init_x = {};
State.Ekf.patch_matching = {};