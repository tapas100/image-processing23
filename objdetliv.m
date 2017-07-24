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
    framePnt = detectSURFFeatures(frame);
    tracker.addDetections(frame, framePnt);
    displayFrame = insertObjectAnnotation(framergb, 'rectangle',...
                          tracker.framePnt);
    displayFrame = insertMarker(displayFrame, framePnt);
    videoPlayer.step(displayFrame);
   %[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
   %framew=im2double(frame);
   %BW1 = edge(framew,'canny');
     
   nFrame=nFrame+1;
end
release(videoPlayer);
clear all;