function [CBCB, CBCT, tumor, imgC] = fun_getStat(CT, CB, SS, selected, CBinfo)

%% dx dy
[M1, N1, ~] = size(CT.MM);
dx = CT.xx(2)-CT.xx(1);
dy = CT.yy(2)-CT.yy(1);
nCT = size(CT.MM, 3);
iso.x = (CT.iso(1)-CT.xx(1))/dx;
iso.y = (CT.iso(2)-CT.yy(1))/dy;

%% ITVi
for n = 1:length(SS.sNames)
    if strcmp(SS.sNames{n}, 'ITVi')
        break
    end
end

idx_ITVi = n;
[cont] = fun_getContour(idx_ITVi, SS.structures, SS.sNames, CT.zz);
contData = cont.data;

S_ITVi = nan(nCT, 1);
for iSlice = 1:length(contData)
    cont_ITVi(iSlice).points = [];
    if ~isempty(contData{iSlice})
        S_ITVi(iSlice) = 0;
        for iSeg = 1:length(contData{iSlice})
            points = contData{iSlice}(iSeg).points;
            x = points(:,1);
            y = points(:,2);
            
            cont_ITVi(iSlice).points{iSeg} = points;
            S_ITVi(iSlice) = S_ITVi(iSlice)+polyarea(x, y);              % area
        end
    end
end

for n = 1:length(SS.sNames)
    if strcmp(SS.sNames{n}, 'ITVi+15mm')
        break
    end
end
idx_ITVi15 = n;

%% contours

if selected.idxSS ~= idx_ITVi
    [cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
    contData = cont.data;

    % calculate area
    S_select = nan(nCT, 1);
    for iSlice = 1:length(contData)
        cont_select(iSlice).points = [];
        if ~isempty(contData{iSlice})
            S_select(iSlice) = 0;
            for iSeg = 1:length(contData{iSlice})
                points = contData{iSlice}(iSeg).points;
                x = points(:,1);
                y = points(:,2);

                cont_select(iSlice).points{iSeg} = points;
                S_select(iSlice) = S_select(iSlice)+polyarea(x, y);              % area
            end
        end
    end

end

nCB = length(CB);

imgC.nCT = nCT;
imgC.nCB = nCB;

% stat

CBCB = struct('nmse', NaN(nCT, nCB), ...
                    'CC',     NaN(nCT, nCB), ...
                    'mie',    NaN(nCT, nCB), ...
                    'fsim',   NaN(nCT, nCB), ...
                    'areaDelta', NaN(nCT, nCB), ...
                    'morphDelta', NaN(nCT, nCB));

CBCT = struct('nmse', NaN(nCT, nCB), ...
                    'CC',     NaN(nCT, nCB), ...
                    'mie',    NaN(nCT, nCB), ...
                    'fsim',   NaN(nCT, nCB), ...
                    'areaDelta', NaN(nCT, nCB), ...
                    'morphDelta', NaN(nCT, nCB));
nmseCB = CBCB.nmse;
for iCB = 1:nCB
    z1(iCB) = CB(iCB).ind1(1);
    z2(iCB) = CB(iCB).ind2(1);
end

ind_com = intersect(cont.ind, max(z1):min(z2));

h = waitbar(0, 'Calculating Metrics...');

sliceIdx = 0;
for iC = 1:length(ind_com)
    iSlice = ind_com(iC);  % slice
%     iSlice = 15;
    xx = [];
    yy = [];
    
    nSeg = length(contData{iSlice});
    pointsOnSlice = cell(nSeg, 1);
    for iS = 1:nSeg
        points = contData{iSlice}(iS).points;
        x = points(:,1);
        y = points(:,2);

        % shift and scale
        x = x-CT.xx(1); x = x/dx;
        y = y-CT.yy(1); y = y/dy;
        xx = [xx;x]; 
        yy = [yy;y];
        
        pointsOnSlice{iS} = [x y];
    end
    
    %% CT
    I_CT = CT.MM(:,:,iSlice);
    
    % ct crop
    marg = 5;
    x1 = floor(min(xx))-marg;
    x2 = ceil(max(xx))+marg;
    y1 = floor(min(yy))-marg;
    y2 = ceil(max(yy))+marg;
    IC_CT = imcrop(I_CT, [x1 y1 x2-x1 y2-y1]);

    for iS = 1:nSeg
        pointsOnSlice{iS}(:,1) = pointsOnSlice{iS}(:,1) - x1;
        pointsOnSlice{iS}(:,2) = pointsOnSlice{iS}(:,2) - y1;
    end        
        
    if iSlice == CT.idx_iso
        iso.x = iso.x-x1;
        iso.y = iso.y-y1;
    end

    % 2D mask
    xxC = xx-x1;
    yyC = yy-y1;
    [M, N] = size(IC_CT);
    BW  = poly2mask(xxC,  yyC, M, N);
    
    IC_CT_tumor = IC_CT;
    
    IC_CT(~BW) = 0; % ct crop inside structure

    % save slices
    imgC.CT{iSlice} = IC_CT;
    imgC.CT_tumor{iSlice} = IC_CT_tumor;
    sliceIdx = sliceIdx+1;
    imgC.sliceIdx(sliceIdx) = iSlice;
    
    % convert to uint8 for similarity calculation
    IC_CT8 = uint8(IC_CT / 256);
    
    % tumor on CT
    % tumor.CB = cell(nCT, nCB);
    % tumor.CT = cell(nCT, 1);
    %tumor.OffSet = nan(nCT, 2);
    if selected.idxSS == idx_ITVi15
         if iSlice <= length(cont_ITVi) && ~isempty(cont_ITVi(iSlice).points)
             for iS = 1:length(cont_ITVi(iSlice))
                 points = cont_ITVi(iSlice).points{iS};
                 x = points(:,1);
                 y = points(:,2);
                 % shift and scale
                 x = x-CT.xx(1); x = x/dx;
                 y = y-CT.yy(1); y = y/dy;
                 
                 ITViP{iS}(:, 1) = x-x1;
                 ITViP{iS}(:, 2) = y-y1;
             end
             
             tumor.OffSet(iSlice, :) = [x1 y1];
             [tumor.CT(iSlice).BWO, tumor.CT(iSlice).points] = fun_tumorSegmentation(IC_CT_tumor, pointsOnSlice, ITViP);
         end
    else
        tumor.CT = [];
        tumor.OffSet = [];
    end
    
    % 3D mask for cb   
    BW3d = repmat(BW, 1, 1, nCB);
    
    % daily slice stack cb crop
    for iCB = 1:nCB
        ICB_z = uint16(zeros(M1, N1));
        MMI = CB(iCB).MMI;
        ind1 = CB(iCB).ind1;    
        ind2 = CB(iCB).ind2;
%         CBLim = CB(iCB).Lim;
        ICB_z(ind1(2):ind2(2), ind1(3):ind2(3)) = MMI(:,:,iSlice-ind1(1)+1);
        IC_CB(:,:,iCB) = ICB_z(y1:y2, x1:x2);
    end
    IC_CB_tumor = IC_CB;
    IC_CB(~BW3d) = 0;
    
    % save slcies
    imgC.CB{iSlice} = IC_CB;
    
    IC_CB = double(IC_CB); % 3d stack
    IC_CT = double(IC_CT);
    
    % max intensity for ct and cb stack
    maxV = max(max(IC_CT(:)), max(IC_CB(:)));
    maxV = double(maxV);

    % ct pdf
    VCT = IC_CT(BW);  % pixels inside structure

    binEdges = 0:10:maxV;
    numCT = histcounts(VCT, binEdges);
    pdfVCT = numCT/sum(numCT);
    [mie_CTCT(iSlice), jpdfe, entrp] = fun_mie(pdfVCT, pdfVCT);

    %% CB
    for iCB = 1:nCB

        ICB = IC_CB(:,:,iCB);
        ICB_tumor = IC_CB_tumor(:,:,iCB);
        if any(ICB(:))
            VCB = ICB(BW);

            num_CB = histcounts(VCB, binEdges);
            pdf_CB(iCB, :) = num_CB/sum(num_CB);

            % pdf correlation coeff.
            junk1 = corrcoef(pdf_CB(1, :), pdf_CB(iCB, :));
            CBCB.CC(iSlice, iCB) = junk1(1,2);

            junk2 = corrcoef(pdfVCT, pdf_CB(iCB, :));
            CBCT.CC(iSlice, iCB) = junk2(1,2);
            clear junk*;
            % pdf mi
            [CBCB.mie(iSlice, iCB), jpdfe, entrp] = fun_mie(pdf_CB(1, :), pdf_CB(iCB, :));
            [CBCT.mie(iSlice, iCB), jpdfe, entrp] = fun_mie(pdfVCT, pdf_CB(iCB, :));
 
            % NMSE - Normalized Mean Square Error
            if contains(SS.sNames{selected.idxSS}, 'ITVi')
                structArea = S_ITVi(iSlice);
            else
                structArea = S_select(iSlice);
            end
                
            junk1 = IC_CB(:,:,1); 
            junk = (junk1(:)-ICB(:)).^2;
            CBCB.nmse(iSlice, iCB) = sum(junk(:))/1000/1000/sqrt(structArea);
            clear junk*;

            junk = (IC_CT(:)-ICB(:)).^2;
            CBCT.nmse(iSlice, iCB) = sum(junk(:))/1000/1000/sqrt(structArea);
            clear junk*;
             
            % for diagnosis
            if iSlice == 12 && iCB == 7
                bbb = 0;
            end
            
            % area and morph change
            if selected.idxSS == idx_ITVi15 
                if iSlice <= length(cont_ITVi) && ~isempty(cont_ITVi(iSlice).points)
                    [tumor.CB(iSlice, iCB).BWO, tumor.CB(iSlice, iCB).points] = fun_tumorSegmentation(ICB_tumor, pointsOnSlice, ITViP);
                    [CBCB.areaDelta(iSlice, iCB), CBCB.morphDelta(iSlice, iCB)] = ...
                        fun_getDelta(tumor.CB(iSlice, 1), tumor.CB(iSlice, iCB), size(ICB, 1), size(ICB, 2));
                    [CBCT.areaDelta(iSlice, iCB), CBCT.morphDelta(iSlice, iCB)] =...
                        fun_getDelta(tumor.CT(iSlice), tumor.CB(iSlice, iCB), size(ICB, 1), size(ICB, 2));
                end
            else
                tumor.CB = [];
            end
            
            % FSIM - Feature Similarity
            ICB8 = uint8(ICB / 256);
            IC_CB18 = uint8(IC_CB(:,:,1) / 256);
            CBCB.fsim(iSlice, iCB) = fun_FeatureSIM23(ICB8, IC_CB18);

            CBCT.fsim(iSlice, iCB) = fun_FeatureSIM23(ICB8, IC_CT8);
        
        end
    end
    
    % normalize
    CBCB.mie(iSlice, :) = CBCB.mie(iSlice, :)/CBCB.mie(iSlice, 1);
    CBCT.mie(iSlice, :) = CBCT.mie(iSlice, :)/mie_CTCT(iSlice);
    
    CBCB.fsim(iSlice, :) = CBCB.fsim(iSlice, :)/CBCB.fsim(iSlice, 1);
    
    clear IC_CB pdf_CB ITViP;
    
    waitbar(iC/length(ind_com))

end
close(h) 