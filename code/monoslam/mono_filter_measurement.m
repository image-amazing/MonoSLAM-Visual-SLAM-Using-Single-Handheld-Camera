% function [ zhat, H, S, idx ] = mono_filter_measurement( zhat, H )

function mono_filter_measurement( zhat )

global State;
global Param;

num_measurements = size(zhat,2);
assert( num_measurements == State.Ekf.nL );

for i = 1:num_measurements
    if is_valid_measurement( zhat(:,i) )
        State.Ekf.status(i) = true;
    else
        State.Ekf.status(i) = false;
    end
end

% idx = [];
% for i = 1:num_measurements
% 
%     if ~is_valid_measurement( zhat(:,i) )
%         idx = [idx, i];
%     end
%     
% end
% 
% for i = 1:length(idx)
%     j = idx(i);
%     zhat(:,j) = [];
%     H(2*(j-1)+1:2*j,:) = [];
% end
% 
% 
% assert( ~isempty(H) );
% Q = eye( 2 * (State.Ekf.nL-length(idx)) ) * Param.sigma.image_noise^2;
% S = H * State.Ekf.Sigma * H' + Q;