%--------------------------------------------------------------------------
% mono_predict_state.m
%
% EKF prediction for monoslam
%
% inputs
%       u: control
%       dt: difference in time btw two consecutive frames

%--------------------------------------------------------------------------

function mono_predict_state(u, dt)


global Param;
global State;


x = State.Ekf.mu( State.Ekf.iR );
dimX = length(x);
dim = length(State.Ekf.mu);


%% update mean vector

% predict the state
[ State.Ekf.mu( State.Ekf.iR ), a ] = f(u, x, dt);


%% update covariance matrix

% obtain Jacobians for camera pose state and noise
F = compute_jacobian_state(x, a, dt);
[H, Pn] = compute_jacobian_noise( x, Param.sigma.a_noise, Param.sigma.alpha_noise, dt );

% construct G and R matrices for the augmented state vector
G = blkdiag( F, eye(dim-dimX) );
R = [ H*Pn*H',                 zeros(dimX, dim-dimX);
     zeros(dim-dimX, dimX),   zeros(dim-dimX)      ];

State.Ekf.Sigma = G * State.Ekf.Sigma * G' + R;


%Obtaining the Jacobians
function F = compute_jacobian_state(x, aold, dt)

qold = x(4:7);
vold = x(8:10);
omegaOld = x(11:13);

dr_by_drold = eye(3);
dr_by_dvold = dt * eye(3);
dv_by_dvold = eye(3);
domega_by_domegaold = eye(3);

dq_by_dqold = [aold(1) -aold(2) -aold(3) -aold(4);
               aold(2)  aold(1)  aold(4) -aold(3);
               aold(3) -aold(4)  aold(1)  aold(2);
               aold(4)  aold(3)  -aold(2)  aold(1)];

dq_by_dquat = [qold(1) -qold(2) -qold(3) -qold(4);
               qold(2)  qold(1) -qold(4) qold(3);
               qold(3)  qold(4)  qold(1) -qold(2);
               qold(4) -qold(3) -qold(2)  qold(1)];

dquat_by_domega = dqomegadt_by_domega(omegaOld ,dt);
dq_by_domega = dq_by_dquat * dquat_by_domega;

F = [ dr_by_drold, zeros(3,4), dr_by_dvold, zeros(3);
     zeros(4,3),  dq_by_dqold, zeros(4,3), dq_by_domega;
     zeros(3), zeros(3,4), dv_by_dvold, zeros(3);
     zeros(3), zeros(3,4), zeros(3), domega_by_domegaold ];


%Obtaining the Jacobian for noise
function [H, Pn] = compute_jacobian_noise(x, lin_a_noise, ang_a_noise, dt)


Pn = blkdiag( (lin_a_noise*dt)^2*eye(3), (ang_a_noise*dt)^2*eye(3) );

dr_by_dV = eye(3)*dt;
dv_by_dV = eye(3);
dq_by_dOmega = dq3_by_dq1(x(4:7))*dqomegadt_by_domega(x(11:13),dt);
domega_by_dOmega = eye(3);

H = [ dr_by_dV,   zeros(3);
     zeros(4,3), dq_by_dOmega;
     dv_by_dV,   zeros(3);
     zeros(3),   domega_by_dOmega ];

