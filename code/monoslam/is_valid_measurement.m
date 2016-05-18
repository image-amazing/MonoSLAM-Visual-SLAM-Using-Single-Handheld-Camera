%--------------------------------------------------------------------------
% is_valid_measurement.m
%
% check if the input pixel coordinate is at valid location
% we could draw a small patch around it
% otherwise, it should return false
%--------------------------------------------------------------------------

function is_valid = is_valid_measurement(uv)

global Param;

u = uv(1);
v = uv(2);
    
% check if a measurement is visible in the image
if u - Param.patchsize_match < 1 || ...
        u + Param.patchsize_match > Param.camera.ncols || ...
        v-Param.patchsize_match < 1 || ...
        v + Param.patchsize_match > Param.camera.nrows
    is_valid = false;
else
    is_valid = true;
end
