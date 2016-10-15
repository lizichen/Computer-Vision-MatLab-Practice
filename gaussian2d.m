
function f=gaussian2d(N)
  % N is grid size, sigma speaks for itself
 [x, y]=meshgrid(round(-N/2):round(N/2), round(-N/2):round(N/2));
 f=exp(-x.^2/(2)-y.^2/(2));
 f = f/(2*pi);
 
 function f=gaussian2d2(N)
  % N is grid size, sigma speaks for itself
 [x, y]=meshgrid(round(-N/2):round(N/2), round(-N/2):round(N/2));
 f=exp(-x.^2/(2)-y.^2/(2));
 f=f./sum(f(:));

 
