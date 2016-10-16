%{
% % % % % % % % % % % % % % % % % % % % % % % 
%
% Find the frames and descriptors - Lizi Chen
% http://www.vlfeat.org/overview/sift.html
%
% % % % % % % % % % % % % % % % % % % % % % % 
%}

colormap 'gray';
%I = imread('book_backup.pgm');
I = imread('scene.pgm');
I = single(I);
image(I);
[f,d] = vl_sift(I) ;
perm = randperm(size(f,2)) ;
sel = perm(1:75) ; % top 75 
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3, 'color', 'b');



