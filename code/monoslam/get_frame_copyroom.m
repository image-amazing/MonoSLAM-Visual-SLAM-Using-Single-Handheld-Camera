%--------------------------------------------------------------------------
% get_frame.m
%
% load an image frame with given frame id
% 
% input:  integer frame id
% output: grayscale image with double format
%
%--------------------------------------------------------------------------


function img = get_frame_copyroom(frameId)

global Param;

try
    imgFilename = sprintf( '%s/%s%06d.%s', ...
        Param.frame.dir, Param.frame.prefix, frameId, Param.frame.ext );
    imgRGB = imread( imgFilename );
    
catch err
    % throw an error if the image does not exist
    error( 'get_frame.m :: %s not exist', imgFilename );
    
end

% convert to grayscale
img = double(imgRGB( :, :, 1 ));