function [CBCB, CBCT, tumor, jh] = fun_getStat(CT, CB, SS, selected, CBinfo, jhOn)

jh = [];

%% dx dy
[M1, N1, ~] = size(CT.MM);
dx = CT.xx(2)-CT.xx(1);
dy = CT.yy(2)-CT.yy(1);
nCT = size(CT.MM, 3);
iso.x = (CT.iso(1)-CT.xx(1))/dx;
iso.y = (CT.iso(2)-CT.yy(1))/dy;

%% contours
[cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
contData = cont.data;

nCB = length(CB);

% stat
tumor.CB = cell(nCT, nCB);
tumor.CT = cell(nCT, 1);
tumor.OffSet = nan(nCT, 2);

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

for iCB = 1:nCB
    z1(iCB) = CB(iCB).ind1(1);
    z2(iCB) = CB(iCB).ind2(1);
end

ind_com = intersect(cont.ind, max(z1):min(z2));

h = waitbar(0, 'Calculating Metrics...');

for iC = 1:length(ind_com)
    iSlice = ind_com(iC);  % slice
%     iSlice = 15;
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
    
    % ct crop
    marg = 5;
    x1 = floor(min(xx))-marg;
    x2 = ceil(max(xx))+marg;
    y1 = floor(min(yy))-marg;
    y2 = ceil(max(yy))+marg;
    IC_CT = imcrop(I_CT, [x1 y1 x2-x1 y2-y1]);

    if iSlice == CT.idx_iso
        iso.x = iso.x-x1;
        iso.y = iso.y-y1;
    end

    % 2D mask
    xxC = xx-x1;
    yyC = yy-y1;
    [M, N] = size(IC_CT);
    BW  = poly2mask(xxC,  yyC, M, N);
    IC_CT(~BW) = 0; % ct crop inside structure

    % convert to uint8 for similarity calculation
    IC_CT8 = uint8(IC_CT / 256);
    
    % tumor on CT
    tumor.OffSet(iSlice, :) = [x1 y1];
    tumor.CT{iSlice} = fun_tumorSegmentation(IC_CT);

    % 3D mask for cb   
    BW3d = repmat(BW, 1, 1, nCB);
    
    % daily slice stack cb crop
    for iCB = 1:nCB
        ICB_z = zeros(M1, N1);
        MMI = CB(iCB).MMI;
        ind1 = CB(iCB).ind1;    
        ind2 = CB(iCB).ind2;
%         CBLim = CB(iCB).Lim;
        ICB_z(ind1(2):ind2(2), ind1(3):ind2(3)) = MMI(:,:,iSlice-ind1(1)+1);
        IC_CB(:,:,iCB) = ICB_z(y1:y2, x1:x2);
    end
    IC_CB(~BW3d) = 0;
    IC_CB = double(IC_CB); % 3d stack

    % max intensity for ct and cb stack
    maxV = max(max(IC_CT(:)), max(IC_CB(:)));
    maxV = double(maxV);
    
    % ct pdf
    VCT = IC_CT(BW);  % pixels inside structure
    nBin = 100;

%     binEdges = -0.5:1:maxV+0.5;
    binEdges = -1:10:maxV+1;
    numCT = histcounts(VCT, binEdges);
    pdfVCT = numCT/sum(numCT);
    [mie_CTCT(iSlice), jpdfe, entrp] = fun_mie(pdfVCT, pdfVCT);

%     [imgJH] = fun_imgJH(IC_CT, IC_CT, maxV);
%     [mi_CTCT(iSlice)] = fun_calMI(imgJH);
%     if jhOn
%         jh.CTCT{iSlice} = imgJH;
%     end

    %% CB
    for iCB = 1:nCB

        ICB = IC_CB(:,:,iCB);
        if any(ICB(:))
            VCB = ICB(BW);

            num_CB = histcounts(VCB, binEdges);
            pdf_CB(iCB, :) = num_CB/sum(num_CB);

            % pdf correlation coeff.
            junk1 = corrcoef(pdf_CB(1, :), pdf_CB(iCB, :));
            CBCB.CC(iSlice, iCB) = junk1(1,2);

            junk2 = corrcoef(pdfVCT, pdf_CB(iCB, :));
            CBCT.CC(iSlice, iCB) = junk2(1,2);
            
            % pdf mi
            [CBCB.mie(iSlice, iCB), jpdfe, entrp] = fun_mie(pdf_CB(1, :), pdf_CB(iCB, :));
            [CBCT.mie(iSlice, iCB), jpdfe, entrp] = fun_mie(pdfVCT, pdf_CB(iCB, :));
 
%             [imgJH] = fun_imgJH(IC_CB(:,:,1), IC_CB(:,:,iCB), maxV);
%             [CBCB.mie(iSlice, iCB)] = fun_calMI(imgJH);
%             if jhOn
%                 jh.CBCB{iSlice, iCB} = imgJH;
%             end
%             
%             [imgJH] = fun_imgJH(IC_CT, IC_CB(:,:,iCB), maxV);
%             [CBCT.mie(iSlice, iCB)] = fun_calMI(imgJH);
%             if jhOn
%                 jh.CBCT{iSlice, iCB} = imgJH;
%             end

            % NMSE - Normalized Mean Square Error
            if iCB ==1
                IC_CB1 = ICB;
                IC_CB1_norm = IC_CB1/max(IC_CB1(:));
                junk2 = IC_CB1_norm.^2;
                IC_CB1_norm2sum = sum(junk2(:))/numel(junk2);
                
                IC_CB1_abs = IC_CB1/max(IC_CB(:));
                junk2 = IC_CB1_abs.^2;
                IC_CB1_abs2sum = sum(junk2(:))/numel(junk2);
            end
            
                IC_CB_norm = ICB/max(IC_CB(:));
                CBCB.nmse(iSlice, iCB) = immse(IC_CB_norm, IC_CB1_abs)/IC_CB1_abs2sum;
            
            % area and morph change
%             if iSlice == CT.idx_iso
                [tumor.CB{iSlice, iCB}] = fun_tumorSegmentation(ICB);
                [CBCB.areaDelta(iSlice, iCB), CBCB.morphDelta(iSlice, iCB)] = fun_getDelta(tumor.CB{iSlice, 1}, tumor.CB{iSlice, iCB}, size(ICB, 1), size(ICB, 2));
                [CBCT.areaDelta(iSlice, iCB), CBCT.morphDelta(iSlice, iCB)] = fun_getDelta(tumor.CT{iSlice}, tumor.CB{iSlice, iCB}, size(ICB, 1), size(ICB, 2));
%             end
            
            % FSIM - Feature Similarity
            ICB8 = uint8(ICB / 256);
            IC_CB18 = uint8(IC_CB1 / 256);
            CBCB.fsim(iSlice, iCB) = fun_FeatureSIM23(ICB8, IC_CB18);

            CBCT.fsim(iSlice, iCB) = fun_FeatureSIM23(ICB8, IC_CT8);
        
        end
    end
    
    % normalize
    CBCB.mie(iSlice, :) = CBCB.mie(iSlice, :)/CBCB.mie(iSlice, 1);
    CBCT.mie(iSlice, :) = CBCT.mie(iSlice, :)/mie_CTCT(iSlice);
    
    CBCB.fsim(iSlice, :) = CBCB.fsim(iSlice, :)/CBCB.fsim(iSlice, 1);
    
    clear IC_CB pdf_CB;
    
    waitbar(iC/length(ind_com))

end
close(h) 