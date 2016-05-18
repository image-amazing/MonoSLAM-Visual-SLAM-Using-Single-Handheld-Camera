%--------------------------------------------------------------------------
% map_management.m
%
% check the total number of landmarks
% detect new landmarks from the image, or
% delete inappropriate landmarks from the map
% 
% inputs:
% output:
%
%--------------------------------------------------------------------------

function map_management()

global State;
global Param;

% if landmarks are repeatedly "not be matched"
% we need to delete those landmarks
delete_idx = [];
for i = 1:State.Ekf.nL

    iL = State.Ekf.iL{i};
    mi = State.Ekf.mu(iL);
    
    % decide whether to delete the landmark
    % we count the times each landmark is matched
    % and also the total number of attempts
    % the low ratio means the landmark is not reliable
    ratio = State.Ekf.matched(i) / State.Ekf.match_attempts(i);
    if State.Ekf.match_attempts(i) > 10 && ratio < 0.5
        delete_idx = [ delete_idx, i ];
    end

end
delete_landmarks( delete_idx );
measured = sum( State.Ekf.individually_compatible );

% detect new landmarks if total # is less than threshold
if State.Ekf.nL == 0 % initially
    
    detect_corners( Param.map.min_nL );
    
    % this part is optional!
    % At the initial frame, the landmarks will be initialized
    % with "actual" depth values from the depth map
    % with (almost) zero uncertainty :    
    % update the inverse depth of all landmarks with true values
    % init_depth();
    
else
    if measured < Param.map.min_nL
        fprintf('measured: %d\n', measured);
        % detect more landmarks
        detect_corners( Param.map.min_nL - measured );
    end
end

update_landmarks_info();
