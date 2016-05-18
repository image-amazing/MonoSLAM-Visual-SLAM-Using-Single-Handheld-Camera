% depth map of the initial frame

global Param;
global State;

depth_dir = sprintf('~/logger2/build/data-translation2/depth/d-%s.jpg', Param.frame.init_filename);
depth = double( imread(depth_dir) );

z = depth / 1000; % z coord in camera frame


for i = 1:State.Ekf.nL
    % for all landmarks
    % which are observed from initial frame
    if State.Ekf.init_t{i} == Param.frame.init_id
        uv = State.Ekf.init_z{i};
        u = uv(1); v = uv(2);
        d = z(v,u);
        if d < 1e-8
            box = 30;
            while true
                % find nearby nonzero depth point
                patch = z( max(1,v-box):min(v+box,size(z,1)), ...
                    max(1,u-box):min(u+box,size(z,2)) );
                d = mean2( patch( patch >= 1e-8 ) );
                if d >= 1e-8, break; end
                box = box + 10;
            end
        end
        State.Ekf.mu( State.Ekf.iL{i}(end) ) = 1/d;
        State.Ekf.Sigma(State.Ekf.iL{i}(end), State.Ekf.iL{i}(end)) = 1;
    end
end