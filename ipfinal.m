clc
clear all
EyeDetect=vision.CascadeObjectDetector('EyePairBig');
I=imread('Image1-1.jpg');
igray=rgb2gray(I);
BB=step(EyeDetect,igray);

Eyes=imcrop(igray,BB);

% J = imadjust(Eyes,[],[],1.2);
% figure,imshow(J)

n1 = Eyes(:, 1 : end/2);
n2 = Eyes(:, end/2+1 : end );
BW = imbinarize(n1,0.4);
se = strel('disk',2);
closeBW = imclose(BW,se);
filter1 = medfilt2(closeBW);

se3 = strel('disk',2);
er1=imerode(filter1,se3);
open = bwareaopen(er1,30);
neg = imcomplement(open);
fill = imfill(neg,'holes');
filter2 = medfilt2(fill);
se4 = strel('disk',4);
er2=imerode(filter2,se4);

subplot(3,4,1),imshow(I)
title('Original image')
subplot(3,4,2),imshow(igray)
title('Gray scale image')
rectangle('Position',BB,'LineWidth',4,'LineStyle','-','EdgeColor','b');
subplot(3,4,3),imshow(Eyes)
title('Cropped image')
subplot(3,4,4),imshow(BW)
title('Binary image')
subplot(3,4,5),imshow(closeBW)
title('Applied closing')
subplot(3,4,6),imshow(filter1)
title('Median filter')
subplot(3,4,7),imshow(er1)
title('Applied erosion')
subplot(3,4,8),imshow(open)
title('Applied opening')
subplot(3,4,9),imshow(neg)
title('Negative image')
subplot(3,4,10),imshow(fill)
title('Filled holes')
subplot(3,4,11),imshow(filter2)
title('Median filter')
subplot(3,4,12),imshow(er2)
title('Applied erosion')


BB1=step(EyeDetect,I);
Eyes1=imcrop(I,BB1);
[rows, columns, numberOfColorChannels] = size(Eyes1);
righteye = Eyes1(1:end, 1:round(columns/2), :);
lefteye = Eyes1(1:end, round(columns/2):end, :);
[centers,radii] = imfindcircles(er2,[30 120],'ObjectPolarity','bright', ...
    'Sensitivity',0.92)
figure,imshow(righteye)
title('Eye ball detected')
h = viscircles(centers,radii);