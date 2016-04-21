setup ;
imdb = load('textonsdb.mat') ;
imdb.images.data = im2single(imdb.images.data) ;
train_index = find(mod(0:length(imdb.images.id)-1,2) < 1) ;
val_index = setdiff(1:length(imdb.images.id),train_index) ;
imdb.images.set(1,val_index)=2;

net=load('textures_jitter.mat');

results_train = train_net(net,imdb.images.data);
results_train_anot = imdb.images.label ;

save('results_train_anot');
save('results_train');

