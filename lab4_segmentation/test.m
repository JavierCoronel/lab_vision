imagen=imread('images/8068.jpg');
x=segment_by_clustering(imagen, 'rgb', 'gmm', 4);
figure
subplot(1,2,1); imagesc(imagen); axis off
subplot(1,2,2); imagesc(x); axis off
