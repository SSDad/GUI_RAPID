function [subImg, subPDF, iso] = fun_getPDF(CT, CB, CBinfo, SS, selected)

nBin = 100;

%% iso on CT
dx = CT.xx(2)-CT.xx(1);
dy = CT.yy(2)-CT.yy(1);
iso.x = (CT.iso(1)-CT.xx(1))/dx;
iso.y = (CT.iso(2)-CT.yy(1))/dy;

subImg = [];
subPDF = [];

%% contours
[cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
contData = cont.data;

iSlice = selected.iSlice.z;

indS = find(~cellfun(@isempty,contData));

if indS(1) <= iSlice && iSlice <= indS(end) 
    
xx = [];
yy = [];
for iS = 1:length(contData{iSlice})
    points = contData{iSlice}(iS).points;
    x = points(:,1);
    y = points(:,2);

    % shift and scale
    x = x-CT.xx(1); x = x/dx;
    y = y-CT.yy(1); y = y/dy;
    xx = [xx;x]; 
    yy = [yy;y];
end

%% CT
I_CT = CT.MM(:,:,iSlice);

% crop
marg = 5;
x1 = floor(min(xx))-marg;
x2 = ceil(max(xx))+marg;
y1 = floor(min(yy))-marg;
y2 = ceil(max(yy))+marg;
IC_CT = imcrop(I_CT, [x1 y1 x2-x1 y2-y1]);

iso.x = iso.x-x1;
iso.y = iso.y-y1;

% 2D mask
xxC = xx-x1;
yyC = yy-y1;
[M, N] = size(IC_CT);
BW  = poly2mask(xxC,  yyC, M, N);
IC_CT(~BW) = 0;
subImg.CT = IC_CT;

subImg.contCB.x = xxC;
subImg.contCB.y = yyC;

%% CB
[M, N, P] = size(CT.MM);
I_CB = zeros(M, N);
iDate = 1;

MMI = CB(iDate).MMI;
ind1 = CB(iDate).ind1;
ind2 = CB(iDate).ind2;
% CBLim = CB(iDate).Lim;
% Axial

if ind1(1) <= iSlice && iSlice<=ind2(1)
    I_CB(ind1(2):ind2(2), ind1(3):ind2(3)) = MMI(:,:,iSlice-ind1(1)+1);
end

if any(I_CB(:))

    IC_CB = imcrop(I_CB, [x1 y1 x2-x1 y2-y1]);
    IC_CB(~BW) = 0;

    subImg.CB1 = IC_CB;
    subImg.machineName1 = CBinfo(1).dcmInfo.ManufacturerModelName;

    nSub = min(length(CBinfo)-selected.idxDate+1, 4);
    for iSub = 1:nSub
        iCB = selected.idxDate+iSub-1;
        MMI = CB(iCB).MMI;
        ind1 = CB(iCB).ind1;
        ind2 = CB(iCB).ind2; 
        I_CB = zeros(M, N);

        if ind1(1) <= iSlice && iSlice<=ind2(1)
            I_CB(ind1(2):ind2(2), ind1(3):ind2(3)) = MMI(:,:,iSlice-ind1(1)+1);
        end
        
        IC_CB = imcrop(I_CB, [x1 y1 x2-x1 y2-y1]);
        IC_CB(~BW) = 0;
        subImg.CB(:,:,iSub) = IC_CB;
        subImg.Date{iSub} = CBinfo(iCB).date;
        subImg.machineName{iSub} = CBinfo(iCB).dcmInfo.ManufacturerModelName;
       
    end

    %% stat
    %CT
    VCT = IC_CT(BW);
    VCT = double(VCT);
    
    [subPDF.CT.x, subPDF.CT.y, edgeCT] = getHist(VCT, nBin);
    
    %CB1
    IC_CB = subImg.CB1;
    IC_CB = double(IC_CB);
    
    VCB = IC_CB(BW);
    VCB = double(VCB);

    [subPDF.CB1.x, subPDF.CB1.y, edgeCB1] = getHist(VCB, nBin);
   
    % CB
    for iSub = 1:nSub
        IC_CB = subImg.CB(:,:,iSub);
        VCB = IC_CB(BW);
        VCB = double(VCB);
        
        % CB2CB1
        numCB1 = histcounts(VCB, edgeCB1);
        yy1 = numCB1/sum(numCB1); 
        yy1(1) = 0;
        xx1 = (1:length(yy1))/length(yy1);
        subPDF.CB.y{iSub} = yy1;
        subPDF.CB.x{iSub} = xx1;
        
        %CB2CT
        numCB2 = histcounts(VCB, edgeCT);
        yy2 = numCB2/sum(numCB2); 
        yy2(1) = 0;
        xx2 = (1:length(yy2))/length(yy2);
        subPDF.CBCT.y{iSub} = yy2;
        subPDF.CBCT.x{iSub} = xx2;
     end
end

end

function [xxCT, yyCT, edgeCT] = getHist(VCT, nBin)
    minCT = min(VCT);
    maxCT = max(VCT);
    if minCT == 0  % remove  0 (dark background or padding)
        edgeCT = linspace(minCT, maxCT, nBin+2);
        edgeCT = edgeCT(2:end);
    else
        edgeCT = linspace(minCT, maxCT, nBin+1);
    end

    numCT = histcounts(VCT, edgeCT);
    yyCT = numCT/sum(numCT);
    yyCT(1) = 0; % remove dark background or padding
    xxCT = (1:length(yyCT))/length(yyCT); 
