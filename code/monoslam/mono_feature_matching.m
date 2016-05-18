%--------------------------------------------------------------------------
% mono_feature_matching.m
%
% The goal is to get the actual measurements
% from the new image frame, and the given map of a 3D world.
% Instead of searching over the entire image region,
% we only search over the local region around zhat. (stored in State.Ekf.h)
%
% match features which lie in the image by searching around a region
% To find: Value of Sigma^2 in Q, Size of bounding box
% Global variables needed: Feature Template, Landmark index of features
% which lie in the image, Actual Image
%
%--------------------------------------------------------------------------

function mono_feature_matching( using_surf )

global State;
global Param;

I = State.Ekf.I;


sw = Param.patchsize_match;
swsize = (sw*2 + 1)^2;

% for all landmarks in the map

for k = 1:State.Ekf.nL
    
    features = [];
    uvs = [];
    
    % check status, and skip invalid measurements
    if isempty(State.Ekf.h{k}), continue; end
    
    h = State.Ekf.h{k};
    S = State.Ekf.S{k};
    
    % skip if the uncertainty of measurement prediction is too high
    if eig(S) > 500,
        display('mono_feature_matching :: eig(S) is too big!');
        continue;
    end
    
    % define the local search region for observing the actual measurement z
    buv = 2 * sqrt(diag(S));
    buv = max( sw, min( 2*sw, buv ));

    % initial patch corresponding to the current landmark
    window_init = State.Ekf.patch_matching{k};
    
    if using_surf
        [ feature_init, ~ ] = ...
        extractFeatures( uint8(window_init), ...
        Param.patchsize_match+1 * ones(1,2), ...
        'Method','SURF', 'BlockSize', 2*sw+1, 'SURFSize',64 );
    else
        feature_init = window_init(:);
    end
    features = [ features, feature_init' ];
    
    
    % detect corner proposals within the local search region
    % defined by buv and zhat
    region = I( max(1,round(h(2)-buv(2))) : min(round(h(2)+buv(2)),size(State.Ekf.I,1)), ...
                max(1,round(h(1)-buv(1))) : min(round(h(1)+buv(1)),size(State.Ekf.I,2)) );
    points = detectMinEigenFeatures(uint8(region));
    
    if isempty(points)
            State.Ekf.individually_compatible(k) = 0;
            State.Ekf.z{k} = [];
            continue;
    end
    uvs = double( [ points.Location(:,1) + max(1,round(h(1)-buv(1))) - 1, ...
            points.Location(:,2) + max(1,round(h(2)-buv(2))) - 1 ] );
    
    if using_surf
        [ feature, ~] = ...
            extractFeatures( uint8(State.Ekf.I), uvs, ...
            'Method', 'SURF', 'BlockSize', 2*sw+1, 'SURFSize', 64);
    else
        feature = State.Ekf.patch_matching{k}(:);
    end
    
    features = [features, feature'];
    corr_mat = corrcoef( features ); % this is a Matlab built-in function
    [corr_sorted, id_sorted] = sort( corr_mat(1,2:end), 'descend' );
    

    % check if corr is greater than the threshold
    thres = 0.8;
    
    State.Ekf.individually_compatible(k) = 0;
    State.Ekf.z{k} = [];
    for i = 1:length(corr_sorted)
        State.Ekf.z{k} = uvs(id_sorted(i),:)';
        if corr_sorted(i) > thres && is_valid_measurement( uvs(id_sorted(i),:) )
            State.Ekf.individually_compatible(k) = 1;
            break;
        end
        if corr_sorted(i) < thres
            break;
        end
    end

end

% disp('feature_matching done');


