%--------------------------------------------------------------------------
% compute_analytic_exp.m
%
% Computes the analytic expressions using Matlab symbolic toolbox
% This is not being used during the program runtime, but the resulting
% analytic expressions are used to write codes in other functions.
%
% Wonhui Kim (wonhui@umich.edu)
%--------------------------------------------------------------------------


%% 1st order derivative of each component in R matrix

syms qr qi qj qk

R = [ qr^2+qi^2-qj^2-qk^2,  -2*qr*qk + 2*qi*qj,     2*qr*qj+2*qi*qk;
          2*qr*qk+2*qi*qj, qr^2-qi^2+qj^2-qk^2,    -2*qr*qi+2*qj*qk;
         -2*qr*qj+2*qi*qk,     2*qr*qi+2*qj*qk, qr^2-qi^2-qj^2+qk^2 ];

for i = 1:numel(R)
    dRdq(i,1) = diff(R(i), qr, 1);
    dRdq(i,2) = diff(R(i), qi, 1);
    dRdq(i,3) = diff(R(i), qj, 1);
    dRdq(i,4) = diff(R(i), qk, 1);
end



%% Jacobian of R*x w.r.t. q

syms px py pz
x = [px; py; pz];


for i = 1:3
    dRxdq(i,1) = diff( R(i,:) * x, qr, 1 );
    dRxdq(i,2) = diff( R(i,:) * x, qi, 1 );
    dRxdq(i,3) = diff( R(i,:) * x, qj, 1 );
    dRxdq(i,4) = diff( R(i,:) * x, qk, 1 );
end


