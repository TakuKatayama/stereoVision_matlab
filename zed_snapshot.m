clear all;close all;clc;

% get access to the ZED camera
zed = webcam('ZED')

% set the desired resolution
zed.Resolution = zed.AvailableResolutions{3};
% get the image size
[height width channels] = size(snapshot(zed))

% Create Figure and wait for keyboard interruption to quit
f = figure('keypressfcn','close','windowstyle','modal');

preview(zed)

i=1;
for i = 1:10
k = waitforbuttonpress;

%capture the current image
img = snapshot(zed);

% split the side by side image image into two images
im_Left = img(:, 1 : width/2, :);
formatSpec = 'snapshotL%d.png';
str_L = sprintf(formatSpec,i);
imwrite(im_Left,str_L)

im_Right = img(:, width/2 +1: width, :);
formatSpec = 'snapshotR%d.png';
str_R = sprintf(formatSpec,i);
imwrite(im_Right,str_R)

% display the left and right images
subplot(1,2,1);
imshow(im_Left);
formatSpec = 'snapshotL%d.png';
str_L = sprintf(formatSpec,i);
title(str_L);
subplot(1,2,2);
imshow(im_Right);
formatSpec = 'snapshotR%d.png';
str_R = sprintf(formatSpec,i);
title(str_R);

drawnow; %this checks for interrupts
% ok = ishandle(f); %does the figure still exist
end
% close the camera instance
clear cam