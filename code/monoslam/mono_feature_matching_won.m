% input
%   zhat: an array of predicted measurements [2 x num_measurements]
%   landmark id
%   H
%   S
%   I: current image frame
%



function [ zhat ] = mono_feature_matching(zhat, H, S )
% function [] = mono_feature_matching(zhat,H_dash,template,img,landmark_ix)

global State;
global Param;

I = State.Ekf.I;

nz = size(zhat,2); % number of measurements


Q = sigma^2*eye(2*zcol);   % Don't know value of sigma^2. Need to find it
S = H_dash*State.Ekf.predSigma*H_dash' + Q; % (2m*2m) = 2m*(n)*(n*n)*(n*2m) + (2m*2m)
%% Double check S matrix multiplication with Won
%%%%%%%%%%%%%% Define feature boundary
buv = 2*sqrt(diag(S));
% zhat(1,i)- buv(2*i-1)  , zhat(2,i)- buv(2*i); % Bounding Box
% zhat(1,i)+ buv(2*i-1)  , zhat(2,i)+ buv(2*i); %

final_template = template{landmark_ix}; % landmark_ix is the vector containing the landmark indices which lie inside the image

%%%%%%%%%%%% Compute Correlation
sw = 7; swsize = (sw*2+1)^2; % 13*13
for k=1:nz
    window1 = final_template{k};
    window1 = reshape(window1,[swsize,1]);
    mean1 = mean(window1);
    
    for i=zhat(2,k)- buv(2*k):zhat(2,k)+ buv(2*k) % v,along the row
        for j= zhat(1,k)- buv(2*k-1):zhat(1,k)+ buv(2*k-1) % u,along the column
            window2 = img(i-sw:i+sw,j-sw:j+sw);
            window2 = reshape(window2,[swsize,1]);
            mean2 = mean(window2);
            
            den = std(window1)*std(window2)*sqrt(swsize-1)*sqrt(swsize-1);
            num = sum(window1.*window2) - sum(window1*mean2) - sum(mean1*window2) + mean1*mean2*swsize;
            Corr(i,j) = num/den;
            
        end
    end
    [num idx] = max(Corr(:));
    [row(k) col(k)] = ind2sub(size(Corr),idx); % Stores the pixel value where the feature is matched
    Corr_max(k)=num;
end

[sorted_Corr, indexval] = sort(Corr_max,'descend');
new_row = row(indexval(1:15)); new_col = col(indexval(1:15));
corrindex = find(sorted_Corr>0.9);

final_Corr = sorted_Corr(corrindex);
sz = size(final_Corr);
new_indexval = indexval(1:sz);
final_row = new_row(corrindex); final_col = new_col(corrindex);

match_landmark_ix = new_indexval; % those values of k which matched


%%%%%%%%%%%%%%%%%%%%%%%%%%

%zhat = removerows(zhat','ind',index);  % zhat' as I want to remove cols
%zhat = zhat';
%H_dash = removerows(H_dash,'ind',index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Not complete: To think about it later

zhat = zhat(match_landmark_ix);
mask = size(landmark_ix);
mask(:) = 0; mask(match_landmark_ix) = 1;
nonmatch_landmark_ix = find(mask==0);
hnonlandmark_ix = [(2*nonmatch_landmark_ix) (2*nonmatch_landmark_ix)-1];
hnonlandmark_ix = sort (hnonlandmark_ix,'ascend');
H_dash(hnonlandmark_ix,:)=0; % Makes the columns in that row position 0

%{
 for i=1:size(landmark_ix)
    Fxj = vertcat(eye(13),zeros(2,13)); % 15*13 % State 2+13
    temp1 = vertcat(zeros(13,2),eye(2)); %
    Fxj = horzcat(Fxj,zeros(5,(2*landmark_ix-1)+13),temp1,zeros(5,dim - (index+1)));
  
%}