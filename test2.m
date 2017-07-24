clc;
vidObj=webcam;
frame = snapshot(vidObj);
frameSize = size(frame);
nFrame = 0;
videoPlayer  = vision.VideoPlayer('Position',[200 100 fliplr(frameSize(1:2)+30)]);
J = imread('cultured.png');
object=rgb2gray(J);
scenePoints = detectSURFFeatures(object);
[sceneFeatures, scenePoints] = extractFeatures(object, scenePoints);

while(nFrame <150)
    framergb = snapshot(vidObj);
    frame = rgb2gray(framergb);
    vidpoints = detectSURFFeatures(frame);
    [vidFeatures, vidpoints] = extractFeatures(frame, vidpoints);
%matching of object
imaggPairs = matchFeatures(vidFeatures, sceneFeatures);
matchedvidpoints = vidpoints(imaggPairs(:, 1), :);
matchedscenePoints = scenePoints(imaggPairs(:, 2), :);
if ~isempty(vidpoints)
            tracker.addDetections(frame, vidpoints);
end
  displayFrame = insertObjectAnnotation(framergb, 'rectangle',...
                          tracker.vidpoints,tracker.scenepoints);
    %displayFrame = insertMarker(displayFrame, );
    videoPlayer.step(displayFrame);  
nFrame=nFrame+1;
end

    

