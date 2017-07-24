%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program Name : Red Object Detection and Tracking                        %
% Author       : Arindam Bose                                             %
% Version      : 1.15                                                     %
% Description  : How to detect and track red, green and blue              %
%                objects in Live Video                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
tic;
redThresh = 0.137; % Threshold for red detection
greenThresh = 0.16; % Threshold for green detection
blueThresh = 0.16; % Threshold for blue detection

vidDevice = imaq.VideoDevice('winvideo', 1, '', ... % Acquire input video stream
                    'ROI', [1 1 640 480], ...
                    'ReturnedColorSpace', 'rgb');
vidInfo = imaqhwinfo(vidDevice); % Acquire input video property
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 600, ...
                                'MaximumBlobArea', 3000, ...
                                'MaximumCount', 10);
hshapeinsBox = vision.ShapeInserter('BorderColorSource', 'Input port', ... % Set box handling
                                        'Fill', true, ...
                                        'FillColorSource', 'Input port', ...
                                        'Opacity', 0.8);
htextinsRed = vision.TextInserter('Text', 'Red   : %2d', ... % Set text for number of blobs
                                    'Location',  [5 2], ...
                                    'Color', [1 0 0], ... // red color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
htextinsGreen = vision.TextInserter('Text', 'Green : %2d', ... % Set text for number of blobs
                                    'Location',  [5 18], ...
                                    'Color', [0 1 0], ... // green color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
htextinsBlue = vision.TextInserter('Text', 'Blue  : %2d', ... % Set text for number of blobs
                                    'Location',  [5 34], ...
                                    'Color', [0 0 1], ... // blue color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
htextinsCent = vision.TextInserter('Text', '+      X:%4d, Y:%4d', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [1 1 0], ... // yellow color
                                    'Font', 'Courier New', ...
                                    'FontSize', 14);
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ... % Output video player
                                'Position', [100 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);
nFrame = 0; % Frame number initialization
n1=0;
%% Processing Loop
    
while(nFrame < 1250)
    rgbFrame = step(vidDevice); % Acquire single frame
    rgbFrame = flipdim(rgbFrame,2); % obtain the mirror image for displaying
    
    diffFrameRed = imsubtract(rgbFrame(:,:,1), rgb2gray(rgbFrame)); % Get red component of the image
    diffFrameRed = medfilt2(diffFrameRed, [3 3]); % Filter out the noise by using median filter
    binFrameRed = im2bw(diffFrameRed, redThresh); % Convert the image into binary image with the red objects as white
    
    diffFrameGreen = imsubtract(rgbFrame(:,:,2), rgb2gray(rgbFrame)); % Get green component of the image
    diffFrameGreen = medfilt2(diffFrameGreen, [3 3]); % Filter out the noise by using median filter
    binFrameGreen = im2bw(diffFrameGreen, greenThresh); % Convert the image into binary image with the green objects as white
    
    diffFrameBlue = imsubtract(rgbFrame(:,:,3), rgb2gray(rgbFrame)); % Get blue component of the image
    diffFrameBlue = medfilt2(diffFrameBlue, [3 3]); % Filter out the noise by using median filter
    binFrameBlue = im2bw(diffFrameBlue, blueThresh); % Convert the image into binary image with the blue objects as white
    
    [centroidRed, bboxRed] = step(hblob, binFrameRed); % Get the centroids and bounding boxes of the red blobs
    centroidRed = uint16(centroidRed); % Convert the centroids into Integer for further steps 
    
    
  
    [centroidGreen, bboxGreen] = step(hblob, binFrameGreen); % Get the centroids and bounding boxes of the green blobs
    centroidGreen = uint16(centroidGreen); % Convert the centroids into Integer for further steps 
    
    [centroidBlue, bboxBlue] = step(hblob, binFrameBlue); % Get the centroids and bounding boxes of the blue blobs
    centroidBlue = uint16(centroidBlue); % Convert the centroids into Integer for further steps 
    
    rgbFrame(1:50,1:90,:) = 0; % put a black region on the output stream
    vidIn = step(hshapeinsBox, rgbFrame, bboxRed, single([1 0 0])); % Instert the red box
    vidIn = step(hshapeinsBox, vidIn, bboxGreen, single([0 1 0])); % Instert the green box
    vidIn = step(hshapeinsBox, vidIn, bboxBlue, single([0 0 1])); % Instert the blue box
    for object = 1:1:length(bboxRed(:,1)) % Write the corresponding centroids for red
        centXRed = centroidRed(object,1); centYRed = centroidRed(object,2);
        vidIn = step(htextinsCent, vidIn, [centXRed centYRed], [centXRed-6 centYRed-9]); 
    end
    for object = 1:1:length(bboxGreen(:,1)) % Write the corresponding centroids for green
        centXGreen = centroidGreen(object,1); centYGreen = centroidGreen(object,2);
        vidIn = step(htextinsCent, vidIn, [centXGreen centYGreen], [centXGreen-6 centYGreen-9]); 
    end
    for object = 1:1:length(bboxBlue(:,1)) % Write the corresponding centroids for blue
        centXBlue = centroidBlue(object,1); centYBlue = centroidBlue(object,2);
        vidIn = step(htextinsCent, vidIn, [centXBlue centYBlue], [centXBlue-6 centYBlue-9]); 
    end
    vidIn = step(htextinsRed, vidIn, uint8(length(bboxRed(:,1)))); % Count the number of red blobs
    vidIn = step(htextinsGreen, vidIn, uint8(length(bboxGreen(:,1)))); % Count the number of green blobs
    vidIn = step(htextinsBlue, vidIn, uint8(length(bboxBlue(:,1)))); % Count the number of blue blobs
    step(hVideoIn, vidIn); % Output video stream
    nFrame = nFrame+1;
    if nFrame==50
        display('entr 1st num');
  n1=size(centroidRed, 1);
   switch n1
     case 1
       imshow('1.jpg');
     case 2
       imshow('2.jpg');
     case 3
       imshow('3.jpg');
     case 4
       imshow('4.jpg');
     case 5
       imshow('5.jpg');
    
       otherwise
       imshow('download.jpg');
    end
    end
    if nFrame==100
        display('enter 2nd num');
     n2=size(centroidRed, 1);
        switch n2
     case 1
       imshow('1.jpg');
     case 2
       imshow('2.jpg');
     case 3
       imshow('3.jpg');
    case 4
       imshow('4.jpg');
     case 5
       imshow('5.jpg');
     otherwise
       imshow('download.jpg');
        end
    end
    if nFrame==125
        n3=size(centroidRed, 1);
  %  mulj=n1+n2;
    switch n3
     case 1
       imshow('add.jpg'); %for addition
      case 2
       imshow('sub.jpg'); %for substraction
     case 3
       imshow('3.jpg'); %for multiplication
    case 4
       imshow('4.jpg'); %for division
        otherwise
       imshow('5.jpg');
    end  
    
   %    display(mulj);
    end
end

if n3==1
    mulj=n1+n2;
    switch mulj
     case 1
       imshow('1.jpg');
     case 2
       imshow('2.jpg');
     case 3
       imshow('3.jpg');
    case 4
       imshow('4.jpg');
     case 5
       imshow('5.jpg');
     case 9
       imshow('9.jpg');
     case 6
       imshow('6.jpg');
     case 7
       imshow('7.jpg');
    case 8
       imshow('8.jpg');
     case 10
       imshow('10.jpg');
     otherwise
       imshow('download.jpg');
     
    end
    display(mulj);     
    
end

    if n3==2
    mulj=n1-n2;
    switch mulj
     case 1
       imshow('1.jpg');
     case 2
       imshow('2.jpg');
     case 3
       imshow('3.jpg');
    case 4
       imshow('4.jpg');
     case 5
       imshow('5.jpg');
     case 9
       imshow('9.jpg');
     case 6
       imshow('6.jpg');
     case 7
       imshow('7.jpg');
    case 8
       imshow('8.jpg');
     case 10
       imshow('10.jpg');
     otherwise
       imshow('download.jpg');

    end
         display(mulj);
    
    end
%% Clearing Memory
release(hVideoIn); % Release all memory and buffer used
release(vidDevice);
toe;
clc;