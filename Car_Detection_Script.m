Vin = VideoReader("RoadTraffic.mp4");
Vout = VideoWriter("Outputt.mp4","MPEG-4");
Vout.FrameRate = Vin.FrameRate;

open(Vout)
for i =1:Vin.NumFrames
   img = readFrame(Vin);
   imFiltered = imfilter(img , fspecial('average',3));
   out = im2gray(imFiltered);

   if i == 1
       background = out;
   end
   out = abs(out-background);

    X = imadjust(out);

    % Threshold image - adaptive threshold
    BW = imbinarize(X, 'adaptive', 'Sensitivity', 0.000000, 'ForegroundPolarity', 'dark');

    % Invert mask
    BW = imcomplement(BW);

    % Open mask with disk
    radius = 10;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imopen(BW, se);

    % Close mask with disk
    radius = 14;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imclose(BW, se);
  
   props = regionprops("table" , BW , "BoundingBox");
   objBoxed = insertShape(img , "rectangle" , props.BoundingBox,"color" , "red" ,"linewidth",3);
    % Create masked image.
    maskedImage = X;
    maskedImage(~BW) = 0;
   frame = imfuse(img , objBoxed , "montage");
   writeVideo(Vout,frame);
   time= Vin.currentTime;
end
close(Vout);
Vin.currentTime = 0;





%montage({Frame96 , imFiltered ,Frame96g, imFiltered2});
% img1 = imread("1.jpg");
% img1 = im2gray(img1);
% img2 = imread("2.jpg");
% img2 = im2gray(img2);
% 
% img1 = img1>245 ;
% img2 = img2>245 ;
% diff = abs( im2double(frame) - im2double(back) );
% diffBW = im2gray(diff);
% percent = nnz(BW3)/(nnz(BW3)+nnz(~BW3));
% img3 = im2gray(frame167);
% im3bin = imbinarize(img3);
% montage({img1 , BW , diff});
% k=3;
% labels = imsegkmeans(im2single(I) ,k);












% imgGauss = imgaussfilt(img);
% imgbin2 = imbinarize(img , "adaptive");

% imgbin = ~imgbin;
% img2 =img;
% img2(imgbin)=0;
% montage({img,imgbin,imgbin2,img2});
% [imgEdge t gv gh] = edge(img);
% montage({img , imgEdge ,im2double(gv) });
% f = fspecial("mean" , 3);
% imgMed = medfilt2(img);
% montage({maskedImage,BW});
% newImg = im2gray(imread("00143.jpg"));
% thresh = graythresh(refImg) *255;
% newImgBW = (newImg > thresh);
% matchImgBW = imhistmatch(newImg , refImg , 256) ;
% matchImgBW = (matchImgBW > thresh);
% montage({newImg,newImgBW,matchImgBW});
% BW = im2gray(img);
% im = imreducehaze(img);

% m=mean2(im) - mean2(img);
%BW = imadjust(BW);
% BW = adapthisteq(BW );
% BW = imbinarize(BW);
% BW = ~BW;
% no = nnz(BW);
% imshow(BW)