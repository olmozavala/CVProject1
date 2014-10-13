%% This function creates a Gaussian mask of nxn
% Just for testing
%sigma = .7;
%theta = 0;
%n = 5;
function gabor = gaborFilter(n,sigma,theta)

T = 1;% Scale
f = @(x,y,sigma) exp( (-1/(2*T^2))*(4*(x.*cos(theta) + y.*sin(theta)).^2 + (-x.*sin(theta)+ y.*cos(theta)).^2)).* ...
                        exp((-i*2*pi)./(T*(x.*cos(theta)+y.*sin(theta))));

width = 5;
height = 5;
x = [-width/2:width/n:width/2];
y = [-height/2:height/n:height/2];

[X,Y] = meshgrid(x,y);

gabor= f(X,Y,sigma);

%Normalization of the gauss function
total = sum(sum(gabor));
gabor = gabor./total;%It doens't validate that the minimum can be 0

%surf(gabor);
