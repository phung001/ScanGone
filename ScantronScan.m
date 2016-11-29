function [  ] = ScantronScan(  )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    while input('Enter 0 to record answer key: ') > 0
    end
    
    cam = webcam('Logitech HD Webcam C270');%'Logitech QuickCam Pro 9000');
    img = snapshot(cam);
    %imtool(img);
    %imshow(img)
    K = rgb2gray(img);
    K2 = im2bw(K, 0.35);
    figure, imshow(K2)
    %K2 is the final image for the answer key
    for i = 1 : input('How many tests are being graded: ')
    while input('Enter 0 when ready to record grade: ') > 0
    end
    
    img2 = snapshot(cam);
    Knew = rgb2gray(img2);
    Knew2 = im2bw(Knew, 0.35);
    %figure, imshow(K2)
   s1 = Knew2(1:length(Knew2)/2, length(Knew2)/2 + 20:end);
   %len = size(s1)
    for i = 1: 10
        s1 = medfilt2(s1);
    end
    s1 = imresize(s1,.5);
    s1 = imrotate(s1 ,90);
    figure, imshow(s1);
    
    [h,w] = size(s1);
    
    sid = string('');
    [ii jj] = find(s1 == 0);
    len = floor(length(ii)/10);
    
    for i = 1: 10
       if ii(i*len)>= 28 && ii(i*len) <=32
           sid = strcat(sid,'0')
       elseif ii(i*len) >=42 && ii(i*len) <= 46
           sid = strcat(sid,'1')
       elseif ii(i*len) >=56 && ii(i*len) <= 60
           sid = strcat(sid,'2')
       elseif ii(i*len) >=70 && ii(i*len) <= 74
           sid = strcat(sid,'3')
       elseif ii(i*len) >=81 && ii(i*len) <= 85
           sid = strcat(sid,'4')
       elseif ii(i*len) >=95 && ii(i*len) <= 99
           sid = strcat(sid,'5')
       elseif ii(i*len) >=109 && ii(i*len) <= 112
           sid = strcat(sid,'6')
       elseif ii(i*len) >=122 && ii(i*len) <= 126
           sid = strcat(sid,'7')
       elseif ii(i*len) >=135 && ii(i*len) <= 139
           sid = strcat(sid,'8')
       elseif ii(i*len) >=148 && ii(i*len) <= 152
           sid = strcat(sid,'9')
       end
    end

    
     figure, imshow(Knew2)
    
%    imshowpair(K, Knew,'Scaling','joint');
    [optimizer, metric] = imregconfig('multimodal');
    optimizer.InitialRadius = 0.009;
    optimizer.Epsilon = 1.5e-4;
    optimizer.GrowthFactor = 1.01;
    optimizer.MaximumIterations = 300;
    movingRegistered = imregister(Knew, K, 'affine', optimizer, metric);
    %figure, imshowpair(I, movingRegistered,'Scaling','joint');
    C = imfuse(K, movingRegistered,'blend','Scaling','joint');
    bla = im2bw(C, 0.35);
    for i = 1: 20
        bla = medfilt2(bla);
    end
    
%    figure, imshow(bla);
    bla = imcomplement(bla);
    figure, imshow(bla);
% 
    bla = bwareaopen(bla,15);
    CC = bwconncomp(bla);
    CC.NumObjects
    x = CC.NumObjects/22;
    disp('Student ID is: ')
    disp(sid)
    disp('Score is:');
    disp(x*100);
    [SID]=[sid,i];
    [answers]=[x*100,i];
    end
    clear('cam');
end
