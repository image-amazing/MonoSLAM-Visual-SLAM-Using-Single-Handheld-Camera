%
% input
%   idx: landmark indices to be deleted
%
% output
%

function delete_landmarks( idx )

if ~isempty(idx)
    display( 'delete_landmarks::');
end

global State;

dimX = length( State.Ekf.iR );
dimL = State.Ekf.dimL;

while ~isempty(idx)
    
    i = idx(1);
    
    iL = State.Ekf.iL{i}; % landmark range
    assert( isequal(iL, ( dimX+(i-1)*dimL+1 ) : ( dimX+i*dimL )) );
    
    State.Ekf.mu( iL ) = [];
    State.Ekf.Sigma(iL,:) = [];
    State.Ekf.Sigma(:,iL) = [];
    
    for j = i+1:State.Ekf.nL
        State.Ekf.iL{j} = State.Ekf.iL{j} - dimL;
        State.Ekf.iM(iL(end)+1:end) = State.Ekf.iM(iL(end)+1:end) - dimL;
    end
    
    State.Ekf.iM(i) = [];
    State.Ekf.iL(i) = [];
    State.Ekf.sL(i) = [];

    State.Ekf.z(i) = [];
    State.Ekf.h(i) = [];
    State.Ekf.H(i) = [];
    State.Ekf.S(i) = [];
    State.Ekf.Q(i) = [];
    
    State.Ekf.status(i) = [];
    State.Ekf.matched(i) = [];
    State.Ekf.match_attempts(i) = [];
    State.Ekf.individually_compatible(i) = [];
    % State.Ekf.innovation_inlier(i) = [];
    
    State.Ekf.init_t(i) = [];
    State.Ekf.init_z(i) = [];
    State.Ekf.init_x(i) = [];
    State.Ekf.patch_matching(i) = [];
    
    State.Ekf.nL = State.Ekf.nL - 1;
    
    idx(1) = [];
    idx = idx-1;
    
end
