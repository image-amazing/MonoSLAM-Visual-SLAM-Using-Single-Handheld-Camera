%------------------------------------------------
% Detect new features in the image
% Input: n - Number of features to be detected
%------------------------------------------------


function uv = detect_corners( n )


global State;
global Param;
I = State.Ekf.I;

uv = [];
box = 30;

% generate corner proposals from the entire image
% we will randomly select the landmark candidate later
corners = detectMinEigenFeatures(uint8(I));
points = corners.selectStrongest(200);
rp = randperm(size(points,1));
location = points.Location(rp,:);
nloc = size(location,1);


if Param.do_visualize
figure(10), imshow(uint8(State.Ekf.I)); hold on;
end

idx = 1;
zhat = [];
u = []; v = [];
% Project the landmarks onto the image
for i=1:State.Ekf.nL
zhat(:,i) = hi_inverse_depth(State.Ekf.mu(State.Ekf.iL{i}),State.Ekf.mu(1:3),q2r(State.Ekf.mu(4:7)));
end
zhat = zhat(:,State.Ekf.individually_compatible > 0);

cnt = 0;
while cnt < n

% distorted pixel location
% currently landmarks are randomly selected,
% but we need to apply the corner detector ( or other feature
                                            % descriptor) here,
% and should also check if the selected feature is not duplicated with
% already registered landmarks in the map.
zhat = [zhat [u ; v]];
nz = size(zhat,2);
for j = idx:nloc
flag = 0;
for i = 1:nz

if isempty(zhat), continue; end
plot (zhat(1,i),zhat(2,i), 'g*', 'MarkerSize', 10);
hold on;

if location(j,1)>= zhat(1,i)-box ...
&& location(j,1)<= zhat(1,i)+box ...
&& location(j,2)>= zhat(2,i)-box ...
&& location(j,2)<= zhat(2,i)+box
else
flag = flag+1;
end
end

if (flag==nz)
u = location(j,1);
v = location(j,2);
break;
end

end

uv = double([u; v]);
idx = j+1;
if isempty(uv),
continue;
end
uv = min(max(1,round(uv)), [size(I,2);size(I,1)]);
if ~is_valid_measurement(uv)
u = []; v = [];
continue;
end
add_new_features(uv);
plot (u, v, 'ro', 'MarkerSize',10);
cnt = cnt + 1;
end

disp('detect_corners done!');

