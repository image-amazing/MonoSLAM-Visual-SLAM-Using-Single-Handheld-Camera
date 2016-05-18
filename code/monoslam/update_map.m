function update_map()

global State;
global Param;

disp('update_map.m');
idx = [];

for i = 1:State.Ekf.nL
    
    if isempty(State.Ekf.z{i}), continue; end
    if isempty(State.Ekf.h{i}), continue; end
    if State.Ekf.t - State.Ekf.init_t{i} <= 50 * Param.frame.stride, continue; end
    if ~is_valid_measurement( State.Ekf.z{i} ), continue; end
    
    idx = [idx, i];
    
    add_new_features( State.Ekf.z{i} );
    State.Ekf.matched(end) = State.Ekf.matched(i);
    State.Ekf.match_attempts(end) = State.Ekf.match_attempts(i);
    State.Ekf.individually_compatible(end) = State.Ekf.individually_compatible(i);
    State.Ekf.innovation_inlier(end) = State.Ekf.innovation_inlier(i);
    State.Ekf.h{end} = State.Ekf.h{i};
    State.Ekf.z{end} = State.Ekf.z{i};
    State.Ekf.H{end} = State.Ekf.H{i};
    State.Ekf.S{end} = State.Ekf.S{i};
    State.Ekf.Q{end} = State.Ekf.Q{i};
    State.Ekf.patch_matching{end} = State.Ekf.patch_matching{i};

end

delete_landmarks( idx );