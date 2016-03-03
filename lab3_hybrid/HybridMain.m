clear all; clc; close all;
%% Save final images
% 0 Don't save
% 1 Save
save=0;

%% Read Images

%Low frequency image
lowFqIm=imread('2kMod.jpg');
%High frequency image
highFqIm=imread('20kMod.jpg');

%% Filter Design

lowFq = fspecial('gaussian', 150, 8);
highFq = fspecial('gaussian', 150, 120);

%% Image Filter
filteredLow = imfilter(lowFqIm, lowFq);
filteredHigh = highFqIm - imfilter(highFqIm, highFq);

%% Hybrid image and visualization

HybridImage=filteredHigh+filteredLow;

% Pyramid of imges
% The function vis_hybrid_image was available from 
% Project 1: Image Filtering and Hybrid Images in the course
% Introduction to Computer Vision at Brown University
% link http://cs.brown.edu/courses/cs143/proj1/
pyramid = vis_hybrid_image(HybridImage);

%% Save resulting images
if save==1
   
    imwrite (HybridImage, fullfile('hybridimage.png'));
    imwrite (pyramid, fullfile('pyramid.png'));
    
end

%% Figures
figure('units','normalized','position',[.15 .1 .7 .7])
subplot(3,2,1); imshow(lowFqIm); title('Original')
subplot(3,2,2); imshow(highFqIm); title('Original')
subplot(3,2,4); imshow(filteredHigh); title('Filtered')
subplot(3,2,3); imshow(filteredLow); title('Filtered')
subplot(3,2,5); imshow(HybridImage); title('Hybrid Image')
subplot(3,2,6); imshow(pyramid); title('Pyramid')

figure
imshow(HybridImage); title('Hybrid Image')