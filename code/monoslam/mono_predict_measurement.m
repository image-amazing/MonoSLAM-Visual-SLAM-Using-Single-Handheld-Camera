%--------------------------------------------------------------------------
% mono_predict_measurement.m
%
% compute the expected measurement zhat:
%   for all landmarks in the map
%   project them onto the image plane with current camera pose
%
% input:
% output:
%
%--------------------------------------------------------------------------

function mono_predict_measurement()

global State;
global Param;

cam = Param.camera;

mu = State.Ekf.mu;
nL = State.Ekf.nL;
dimL = State.Ekf.dimL;

x = mu( State.Ekf.iR ); % camera pose
m = mu( 14:end ); % landmarks

R = q2r( x(4:7) ); % rotation matrix from quaternion

for i = 1:nL
    
    iL = State.Ekf.iL{i};
    mi = State.Ekf.mu(iL);

    % convert inverse depth representation into
    % projected 2d image coordinate
    
    % directional vector from camera center to the landmark
    theta = mi(4);
    phi = mi(5);
    rho = mi(6);
    hi = R' * ...
        ( (mi(1:3)-x(1:3)) * rho + ...
        [cos(phi).*sin(theta), -sin(phi), cos(phi).*cos(theta)]' );  
    
    % projective camera model
    uv = hu( hi, cam );
    
    % radial distortion
    zhat(:,i) = distort_fm( uv, cam );

    % skip if zhat(:,i) is not valid
    if ~is_valid_measurement(zhat(:,i))
        State.Ekf.h{i} = []; 
        State.Ekf.H{i} = [];
        State.Ekf.Q{i} = [];
        State.Ekf.S{i} = [];
        State.Ekf.status(i) = 0;
        continue;
    end
    
    State.Ekf.h{i} = zhat(:,i);
    
    % parse a single landmark from m
    iL = State.Ekf.iL{i};
    mi = State.Ekf.mu( iL );
    assert( isequal( mi, m((i-1)*dimL+1:i*dimL) ) );
    
    Hi = calculate_Hi( x, mi, zhat(:,i), cam, i, nL );
    Qi = eye(2) * Param.sigma.image_noise^2;
    Si = Hi * State.Ekf.Sigma * Hi' + Qi;
    State.Ekf.H{i} = Hi;
    State.Ekf.Q{i} = Qi;
    State.Ekf.S{i} = Si;

end
