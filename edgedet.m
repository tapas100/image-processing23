clc;
clear all;
close all;
I = imread('ball.jpg');
imshow(I);
BW1 = edge(I,'sobel');
BW2 = edge(I,'canny');
figure;
imshowpair(BW1,BW2,'montage')
title('Sobel Filter                                   Canny Filter');