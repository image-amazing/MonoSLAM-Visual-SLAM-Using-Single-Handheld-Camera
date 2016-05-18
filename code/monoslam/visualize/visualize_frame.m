%--------------------------------------------------------------------------
% visualize_frame.m
%
% visualize a single frame
% 
% input: an array of a single grayscale image frame
% output:
%
% Wonhui Kim (wonhui@umich.edu)
%--------------------------------------------------------------------------



function visualize_frame( I )

figure;
imagesc(I); colormap gray; colorbar;
axis equal; axis tight;