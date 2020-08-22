x_c = [10, 20, 30];
y_c = [20, 40, 60];
m_c = [0, 1 ,2];
n = size(x_c);
% xc = cat(3, repmat(640, [1024, 1280]), repmat(320, [1024, 1280]));
% yc = cat(3, repmat(512, [1024, 1280]), repmat(256, [1024, 1280]));
xc = repmat(reshape(x_c, 1, 1, []), 1024, 1280);
yc = repmat(reshape(y_c, 1, 1, []), 1024, 1280);
mc = repmat(reshape(m_c, 1, 1, []), 1024, 1280);

x = 1:1280;
y = 1:1024;
sigma = 4;
[X, Y] = meshgrid(x,y);
X = repmat(X, [1, n]);
Y = repmat(Y, [1, n]);

val       = 10 ^ 4 * (100 ^ 0.2) .^ (-mc) / (sigma * sqrt(2*pi))  .* exp(-((X-xc).^2 + (Y-yc).^2)/(2*sigma^2));
imshow(mat2gray(sum(val,3)));
