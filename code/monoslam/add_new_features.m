function add_new_features( uv_d )

global State;
global Param;

assert( is_valid_measurement(uv_d) );

ud = uv_d(1);
vd = uv_d(2);

% Add a new feature to the vector state
% mean and covariance
[mi,n] = hinv(uv_d);

% add to the state vector
State.Ekf.mu = [ State.Ekf.mu; mi ];
augment_sigma( uv_d );

% other indices
% update the following:
%   State.Ekf.iM : 2*nL vector containing map indices
%   State.Ekf.iL : nL cell array containing indices of landmark i
%   State.Ekf.nL : scalar number of landmarks
%   State.Ekf.sL : nL vector containing signatures of landmarks

dimX = 13;                       % dimension of camera pose
dimL = State.Ekf.dimL;           % dimension of landmark
prev = dimL*State.Ekf.nL + dimX; % tail position of prev state

State.Ekf.iM( dimL*State.Ekf.nL + (1:dimL) ) = prev + (1:dimL);
State.Ekf.iL{ State.Ekf.nL+1 } = prev + (1:dimL);
State.Ekf.sL( State.Ekf.nL+1 ) = max( [State.Ekf.nL, State.Ekf.sL] );
% ==> not using this

R = q2r( State.Ekf.mu(4:7) );
State.Ekf.h{ State.Ekf.nL+1 } = [];
State.Ekf.z{ State.Ekf.nL+1 } = [];
State.Ekf.H{ State.Ekf.nL+1 } = [];
State.Ekf.S{ State.Ekf.nL+1 } = [];
State.Ekf.Q{ State.Ekf.nL+1 } = [];

State.Ekf.status( State.Ekf.nL+1 ) = true;
State.Ekf.matched( State.Ekf.nL+1 ) = 0;
State.Ekf.match_attempts( State.Ekf.nL+1 ) = 0;
State.Ekf.individually_compatible( State.Ekf.nL+1 ) = 0;

State.Ekf.init_t{ State.Ekf.nL+1 } = State.Ekf.t;
State.Ekf.init_z{ State.Ekf.nL+1 } = uv_d;
State.Ekf.init_x{ State.Ekf.nL+1 } = State.Ekf.mu( State.Ekf.iR );

% add patch around the given pixel coords
del_match = Param.patchsize_match;
State.Ekf.patch_matching{ State.Ekf.nL+1 } = ...
    State.Ekf.I( vd-del_match:vd+del_match , ud-del_match:ud+del_match );

State.Ekf.nL = State.Ekf.nL + 1; % num of total landmarks
assert( length(State.Ekf.mu) == ( dimL * State.Ekf.nL + 13 ) );