%{
% % % % % % % % % % % % % % % % % % % % % % % 
%
% Basic Matching - Lizi Chen
% http://www.vlfeat.org/overview/sift.html
%
% % % % % % % % % % % % % % % % % % % % % % % 
%}
disp('Running sift_dector_2.m');
colormap 'gray'; % somehow the rgb2gray(I) does not work, use this colormap to set globally.
Iscene = imread('scene.pgm');
Ibook = imread('book.pgm');
Iscene = single(Iscene);
Ibook = single(Ibook);
rows1 = size(Iscene,1);
rows2 = size(Ibook,1);
if (rows1 < rows2)
     Iscene(rows2, 1) = 0;
else
     Ibook(rows1, 1) = 0;
end
jointedImg = [Iscene, Ibook]; % Now append both images side-by-side.
imagesc(jointedImg);% Display the jointed image
[fscene, dscene] = vl_sift(Iscene);
[fbook, dbook] = vl_sift(Ibook);
[matches, scores1] = vl_ubcmatch(dscene, dbook, 1.5); 


    % This is for displaying the match points.
    xa = fscene(1, matches(1,:));
    xb = fbook(1, matches(2,:)) + size(Iscene,2) ;
    ya = fscene(2, matches(1,:));
    yb = fbook(2, matches(2,:));
    hold on;
    h = line([xa ; xb], [ya ; yb]);
    set(h,'linewidth', 1, 'color', 'b') ;
    vl_plotframe(fscene(:,matches(1,:))) ;
    fbook(1,:) = fbook(1,:) + size(Iscene,2) ;
    vl_plotframe(fbook(:,matches(2,:))) ;

[fscene, dscene] = vl_sift(Iscene);
[fbook, dbook] = vl_sift(Ibook);
[matches, scores] = vl_ubcmatch(dscene, dbook, 1.5); 

GoodPoints1 = zeros(148,2);%store the good points of the image 1
GoodPoints2 = zeros(148,2);%store the good points of the image 2
goodPointCursor = 1;
for i = 1: 125 %repeat N = 100 times
   perm = randperm(size(matches,2));%number of matched points
   sel = perm(1:5) ;% randomly pick 5 points
   xalist = fscene(1, matches(1,sel));
   xblist = fbook(1, matches(2,sel));
   yalist = fscene(2, matches(1,sel));
   yblist = fbook(2, matches(2,sel));
   pointlist1 = horzcat(xalist',yalist'); % a 5-by-2 list of all the good points for img 1
   pointlist2 = horzcat(xblist',yblist'); % a 5-by-2 list of all the good points for img 2
   tform = fitgeotrans(pointlist2, pointlist1, 'affine');
   transformedPointlist2 = transformPointsForward(tform, pointlist2);
   for j = 1 : 5 % compare transformedPointlist1 with pointlist2
        distance = pdist([transformedPointlist2(j,:);pointlist1(j,:)], 'euclidean');
        if(distance < 10)% save the ones that distance less than 10 pixels to the group of inliers 
            GoodPoints2(goodPointCursor,:) = pointlist2(j,:);
            GoodPoints1(goodPointCursor,:) = pointlist1(j,:);
            goodPointCursor = goodPointCursor + 1;
        end    
   end    
end
% use the saved inliers - group of points to run the fitgeotrans again to get the overall best tform.
tform2 = fitgeotrans(GoodPoints2, GoodPoints1, 'affine');
figure;
finalImage = imwarp(Ibook, tform2); %'OutputView', imref2d(size(Ibook)));
colormap 'gray';
imagesc(finalImage);
