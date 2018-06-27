clear all
close all


C = imread('ngc6543a.jpg');

figure
subplot(121)
imshow(C)

C1 = repmat(C(:,:,1), 1,1,3);
subplot(122)
imshow(C1)

%%
load ('testImages')
figure
subplot(221)
imshow(ICT, [])
subplot(222)
imshow(ICB, [])

ICTnorm = mat2gray(ICT);
ICBnorm = mat2gray(ICB);
subplot(223)
imshow(ICTnorm, [])
subplot(224)
imshow(ICBnorm, [])

ICT3 = repmat(ICTnorm, 1, 1, 3);

% ICT3(:,:,2) = ICBnorm;

figure
h(1) = imshow(ICT3, []);

