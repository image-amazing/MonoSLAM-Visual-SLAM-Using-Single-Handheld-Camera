%--------------------------------------------------------------------------
% monoslam_update.m
%
% update the state estimates of EKF
%--------------------------------------------------------------------------

function mono_update()

global Param;
global State;

% construct stacked H and S matrices for update
H = [];
z = [];
zhat = [];
idx = [];

for i = 1:State.Ekf.nL
    if State.Ekf.individually_compatible(i)
        H = [ H; State.Ekf.H{i} ];
        z = [ z; State.Ekf.z{i} ];
        zhat = [ zhat; State.Ekf.h{i} ];
    else
        idx = [idx, i];
    end
end

if isempty(H)
    return;
end
Q = eye( size(H,1) ) * Param.sigma.image_noise^2;
S = H * State.Ekf.Sigma * H' + Q;


% compute Kalman gain
K = State.Ekf.Sigma*H' / S ;

% construct stacked measurement arrays
assert( isequal( size(z), size(zhat) ));

% update
dz = z - zhat;
if ~isempty(dz)
    State.Ekf.mu = State.Ekf.mu + K*dz;
    State.Ekf.Sigma = State.Ekf.Sigma - K*H*State.Ekf.Sigma; 
    State.Ekf.Sigma = 0.5*State.Ekf.Sigma + 0.5*State.Ekf.Sigma';
    normalize_state_quaternion();
end
