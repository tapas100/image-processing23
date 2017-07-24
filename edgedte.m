clear classes;
framergb = imread('penguins.jpg');
    frame = rgb2gray(framergb);
    framew=im2double(frame);
     BW1 = edge(framew,'canny');
     imshow(BW1);
clear all;