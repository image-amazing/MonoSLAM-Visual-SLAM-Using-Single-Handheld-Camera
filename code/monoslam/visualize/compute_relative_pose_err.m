% compute relative estimation error

function compute_relative_pose_err( mu_traj, gt_traj )

n = min( size(mu_traj,2), size(gt_traj,2) );

err_mu = [];
err_gt = [];

for i = 2:n
    err_mu = [ err_mu, norm(mu_traj(1:3,i)-mu_traj(1:3,i-1)) ];
    err_gt = [ err_gt, norm(gt_traj(1:3,i)-gt_traj(1:3,i-1)) ];
end


figure(100);
hold on; grid on;
plot( err_mu, '-b.'); 
plot( err_gt, '-k.');