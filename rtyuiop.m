clc;
clear all;
close all;
clear classes;
vidObj = webcam

%vidObj.SelectedSourceName = 'input1'
%src_vidObj = getselectedsource(vidObj);
%get(src_vidObj)
frame = snapshot(vidObj);
frameSize = size(frame);
nFrame = 0;
videoPlayer  = vision.VideoPlayer('Position',[200 100 fliplr(frameSize(1:2)+30)]);


while(nFrame <200)
    framergb = snapshot(vidObj);
    frame = rgb2gray(framergb);
    framew=im2double(frame);
    BW1 = edge(framew,'canny');
    videoPlayer.step(); 
   nFrame=nFrame+1;
   if nFrame==150
       snaap=snapshot(vidObj);
       imshow(snaap);
   end
       
end
release(videoPlayer);
clear all;