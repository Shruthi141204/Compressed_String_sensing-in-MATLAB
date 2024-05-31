clc; clear variables; close all;

img = imread("D:\AMRITA\Sem4\MFC4\Assignment6\Image.jpeg");
img = rgb2gray(img);
img = imresize(img, [50, 50]);
img = reshape(img,[],1);

act_Size = size(img);
n = act_Size(1);

p = 500;
C = randn(p, n);
theta = C*dctmtx(n) ;
y = C * double(img);

cvx_begin
variable s(n)
minimize ( norm(s, 1) ) 
subject to
norm(y - theta*s, 2) <= 0 ;
cvx_end

% Reconstruct the image
s_resz = dctmtx(n) * s;
s_resz = reshape(s_resz, [50, 50]); % Reshape to image size
s_resz = uint8(s_resz); % Convert to uint8 format

subplot(2, 1, 1)
imshow(reshape(img, 50, 50))
subplot(2, 1, 2)
imshow(s_resz)

%%
cvx_begin
variable s1(n)
minimize ( norm(s1, 1) ) 
subject to
theta*s1 == y ;
cvx_end

% Reconstruct the image
s_resz1 = dctmtx(n) * s1;
s_resz1 = reshape(s_resz1, [50, 50]); % Reshape to image size
s_resz1 = uint8(s_resz1); % Convert to uint8 format

subplot(2, 1, 1)
imshow(reshape(img, 50, 50))
subplot(2, 1, 2)
imshow(s_resz)


%%
subplot(3,2,1)
plot(s)
title('L1')
ylim([-.2 .2])
grid on

subplot(3,2,[3 5])
[hc, h] = hist(s, [-.1:.01: .1]);
bar(h,hc,'r')
axis([-.1 .1 -20 1000]);

subplot(3,2,2)
plot(s1)
title('L2')
ylim([-.2 .2])
grid on

subplot(3,2,[4 6])
[hc, h] = hist(s, [-.1:.01: .1]);
bar(h,hc,'r')
axis([-.1 .1 -20 1000]);

%%

s_pinv = pinv(C * dctmtx(n)) * y;

subplot(2,1,1)
plot(s_pinv)
title('L2')
ylim([-.2 .2])
grid on

subplot(2,1,2)
[hc, h] = hist(s_pinv, [-.1:.01: .1]);
bar(h,hc,'r')
axis([-.1, .1, -20, 1000]);

%%

s_resz = dctmtx(n)'*s;
s_resz = reshape(s_resz, [50, 50]); % Reshape to match the original image size
s_resz = uint8(s_resz);

imwrite(s_resz, 'D:\AMRITA\Sem4\MFC4\Assignment6\image_1.jpg');

s_resz = dctmtx(n)'*s1; % Corrected variable name
s_resz = reshape(s_resz, [50, 50]); % Reshape to match the original image size
s_resz = uint8(s_resz);

imwrite(s_resz, 'D:\AMRITA\Sem4\MFC4\Assignment6\image_2.jpg');

s_resz = dctmtx(n)'*s_pinv;
s_resz = reshape(s_resz, [50, 50]); % Reshape to match the original image size
s_resz = uint8(s_resz);

imwrite(s_resz, 'D:\AMRITA\Sem4\MFC4\Assignment6\image_3.jpg');

