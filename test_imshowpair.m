clear all

%%
load ('testImages')
ICTnorm = mat2gray(ICT);
ICBnorm = mat2gray(ICB);

CTLim = [min(ICT(:)) max(ICT(:))];
newCTLim(1) = CTLim(1);
newCTLim(2) = round(CTLim(2)/2);
newCTLim = double(newCTLim);

CBLim = [min(ICB(:)) max(ICB(:))];
newCBLim(1) = CBLim(1);
newCBLim(2) = round(CBLim(2)/2);
newCBLim = double(newCBLim);

ICTnorm_new = mat2gray(ICT, newCTLim);
ICBnorm_new = mat2gray(ICB, newCBLim);

%%
figure(1), clf
subplot(2,3,1), imshow(ICTnorm, [])
subplot(2,3,2), imshow(ICBnorm, [])
subplot(2,3,3), imshowpair(ICBnorm, ICTnorm)

subplot(2,3,4), imshow(ICTnorm_new, [])
subplot(2,3,5), imshow(ICBnorm_new, [])
subplot(2,3,6), h = imshowpair(ICBnorm_new, ICTnorm_new);


%%
figure(2), clf
subplot(2,2,1), h1 = imshowpair(ICBnorm, ICTnorm);
cdata1 = get(h1, 'cdata');
subplot(2,2,2), h = imshowpair(ICBnorm_new, ICTnorm_new);
subplot(2,2,3), h = imshowpair(ICBnorm_new, ICTnorm_new);

ICBnew = ICBnorm;
C1 = im2uint8(ICBnew);

ICTnew = ICTnorm;
C2 = im2uint8(ICTnew);

cdata = get(h, 'cdata');
cdata(:,:,2) = C1;
cdata(:,:,1) = C2;
cdata(:,:,3) = C2;

set(h, 'cdata', cdata)

image(ICT)