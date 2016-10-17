fileworld = fopen('world.txt');
format short
C_world = textscan(fileworld,'%f','whitespace', '');
fclose(fileworld);
worldPoints = zeros(10,3);
for i=1:10
    worldPoints(i,1) = C_world{1,1}(i,1);
end
for i=1:10
    worldPoints(i,2) = C_world{1,1}(10+i,1);
end
for i=1:10
    worldPoints(i,3) = C_world{1,1}(20+i,1);
end   
fileimage = fopen('image.txt');
C_image = textscan(fileimage,'%f','whitespace','');
fclose(fileimage);
imagePoints = zeros(10,2);
for i=1:10
    imagePoints(i,1) = C_image{1,1}(i,1);
end
for i=1:10
    imagePoints(i,2) = C_image{1,1}(10+i,1);
end
% Now we have worldPoints, and imagePoints
worldjoinimage = horzcat(worldPoints, imagePoints);
AMatrix = zeros(20,12);
worldjoinimageCursor = 1;
for i=0:9
    Xx = worldjoinimage(worldjoinimageCursor,1);
    Xy = worldjoinimage(worldjoinimageCursor,2);
    Xz = worldjoinimage(worldjoinimageCursor,3);
    xx = worldjoinimage(worldjoinimageCursor,4);
    xy = worldjoinimage(worldjoinimageCursor,5);
    index1 = 2*i + 1;
    index2 = 2*i + 2;
    AMatrix(index1,:) = [0,  0,  0,  0,  -Xx,    -Xy,    -Xz,    -1, xy*Xx,  xy*Xy,  xy*Xz,  xy];
    AMatrix(index2,:) = [Xx,  Xy,  Xz,  1,  0,   0,  0,  0, -xx*Xx,  -xx*Xy,  -xx*Xz,  -xx];
    worldjoinimageCursor = worldjoinimageCursor + 1;  
end    
% now we have A Matrix, Ap = 0.
[U,S,V] = svd(AMatrix);
oneColumnP = V(:,end);
P = zeros(3,4);
for i=0:2
    P(i+1,:) = [oneColumnP(4*i+1,1), oneColumnP(4*i+2,1),oneColumnP(4*i+3,1),oneColumnP(4*i+4,1)];
end   
% now we have P, a 3*4 matrix
[Uc,Sc,Vc] = svd(P);
oneColumnC = Vc(:,end);
C = oneColumnC';