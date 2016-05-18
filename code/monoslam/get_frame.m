%--------------------------------------------------------------------------
% get_frame.m
%
% load an image frame with given frame id
% 
% input:  integer frame id
% output: grayscale image with double format
%
%--------------------------------------------------------------------------


function img = get_frame(frameId)

global Param;


files = dir( sprintf('%s/r-*.jpg', Param.frame.dir) );

if frameId == 1
    Param.frame.init_filename = files(frameId).name(3:end-4);
end


try
    imgFilename = sprintf( '%s/%s', ...
        Param.frame.dir, files(frameId).name );
    imgRGB = imread( imgFilename );
    disp( imgFilename );
    
catch err
    % throw an error if the image does not exist
    error( 'get_frame.m :: %s not exist', imgFilename );
    
end

% convert to grayscale
img = double(imgRGB( :, :, 1 ));
