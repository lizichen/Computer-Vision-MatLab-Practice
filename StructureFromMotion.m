%{
% % % % % % % % % % % % % % % % % % % % % % % 
%
% Structure from Motion - Lizi Chen
%
% % % % % % % % % % % % % % % % % % % % % % % 
%}
disp('Running StructureFromMotion.m');
load('sfm_points.mat'); % 2-by-600-by-10 matrix.
                        % image_points(:,1,:) is the 1st of the 600 world points
format short
W = zeros(20,600);
WRowCursor = 1;
for i=1:10
    sumX = 0;
    sumY = 0;
    for j=1:600
        x = image_points(1,j,i); % x
        y = image_points(2,j,i); % y
        sumX = sumX + x;
        sumY = sumY + y;
    end
    aveX = sumX / 600; % this is the t(1,1) for current image
    aveY = sumY / 600; % this is the t(2,1) for current image
    for j=1:600 % assign values to W, the 2m-by-n measurement matrix
        x = image_points(1,j,i); % x
        y = image_points(2,j,i); % y
        W(WRowCursor, j) = x-aveX;
        W(WRowCursor+1, j) = y-aveY;
    end  
    WRowCursor = WRowCursor + 2;
end    
[U,D,V] = svd(W);
% camera locations M_i can be obtained from the first three columns of U,
    % mulipleid by D(1:3,1:3)
% The first camera, M and t:
CameraLocations = U(:,1:3) * D(1:3,1:3);
figure;
plot3(V(:,1), V(:,2), V(:,3) );
rotate3d on;

