clc;
clear all;
close all;
clear classes;
vidObj = webcam;
frame = snapshot(vidObj);
frameSize = size(frame);
nFrame = 0;
videoPlayer  = vision.VideoPlayer('Position',[200 100 fliplr(frameSize(1:2)+30)]);


while(nFrame <1150)
    framergb = snapshot(vidObj);
    frame = rgb2gray(framergb);
    framew=im2double(frame);
    BW1 = edge(framew,'canny');
    videoPlayer.step(BW1);
   nFrame=nFrame+1;
end
release(videoPlayer);
clear all;