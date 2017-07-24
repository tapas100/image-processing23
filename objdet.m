clc;

I =imread('cam1.jpg');
J = imread('cam2.jpg');
boxImage=rgb2gray(I);
sceneImage=rgb2gray(J);
%first image
boxPoints = detectSURFFeatures(boxImage);
figure;
imshow(boxImage);
hold on;
plot(selectStrongest(boxPoints, 200));
[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
%second image
scenePoints = detectSURFFeatures(sceneImage);
figure;
imshow(sceneImage);
hold on;
plot(selectStrongest(scenePoints, 400));
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%matching of object
boxPairs = matchFeatures(boxFeatures, sceneFeatures);
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure;
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');
[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');
figure;
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');
boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    newBoxPolygon = transformPointsForward(tform, boxPolygon);
    

