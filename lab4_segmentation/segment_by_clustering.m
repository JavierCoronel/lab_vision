function my_segmentation = segment_by_clustering( rgb_image, feature_space, clustering_method, number_of_clusters)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%% Comparing Method

% Kmeans
if (strcmp(clustering_method,'k-means'))
    Image=colorVerify(rgb_image, feature_space);
    
    Tam=1;
        K=number_of_clusters;
    Numcol=im2col(Image,[Tam Tam]);
    Numcoldouble=im2double(Numcol');
    
    [et ,ind]=kmeans(Numcoldouble,K);
    % Tama?os
    [m,n]=size(ind);
    [mm,nn,uu]=size(Image);
    
    % Se reemplaza por el valor de cada pixel por el valor de la etiqueta
    % correspondiente
    for i=1:m
        for j=1:length(et)
            if et(j)==i
                et(j,1)=ind(i,Tam*Tam/2+0.5);
            else
                et(j,1)=et(j,1);
            end
        end
    end
    
    %reacomodamiento
    imk=et;
    %Se arma la imagen nuevamente con los valores de las etiquetas correspondientes
    my_segmentation=reshape(imk(:),[mm,nn,uu]);
    
    
% Gaussian mixture
elseif strcmp(clustering_method,'gmm')
    Image=colorVerify(rgb_image, feature_space);
    I=im2double(rgb2gray(Image));
    I=I(:);
    GMModel = fitgmdist(I,number_of_clusters);
    
    idx = cluster(GMModel,I);
    cluster1 = (idx == 1);
    cluster2 = (idx == 2);
    cluster3 = (idx == 3);
    cluster4 = (idx == 4);
    
    [mm,nn,uu]=size(Image);
    cone=reshape(cluster1(:),[mm,nn]);
    ctwo=reshape(cluster2,[mm,nn]);
    ctree=reshape(cluster3,[mm,nn]);
    cfour=reshape(cluster4,[mm,nn]);
    
    onei=imfuse(cone,ctwo);
    twoi=imfuse(ctree,cfour);
    my_segmentation=imfuse(onei,twoi);

% Hierarchical classiffication
elseif strcmp(clustering_method,'hierarchical')
    
    colorTransform = makecform('srgb2lab');
    clrSpace = applycform(image(:,:,1:3), colorTransform);
    
% Watersheds
elseif strcmp(clustering_method,'watershed')
    
    I=colorVerify(rgb_image, feature_space);
    I=rgb2gray(I);
    [Gmag,Gdir] = imgradient(I);
    marker = imextendedmin(I, number_of_clusters);
    new_grad = imimposemin(Gmag, marker);
    my_segmentation=watershed(new_grad);
    
else
    display('The clustering method is not specified');
    return
end

end

%% Color space change
function imageRSpace=colorVerify(image, feature_space)
if (strcmp(feature_space,'rgb')==1 || strcmp(feature_space,'rgb+xy')==1 )
    imageRSpace=image;
elseif strcmp(feature_space,'hsv')==1 || strcmp(feature_space,'hsv+xy')==1
    
    imageRSpace=rgb2hsv(image(:,:,1:3));
    
elseif strcmp(feature_space,'lab')==1 || strcmp(feature_space,'hsv+xy')==1
    
    colorTransform = makecform('srgb2lab');
    imageRSpace = applycform(image(:,:,1:3), colorTransform);
    
end

end

