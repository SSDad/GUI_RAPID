function [CBCB] = fun_getStat(CT, CB, SS, selected)

%% dx dy
dx = CT.xx(2)-CT.xx(1);
dy = CT.yy(2)-CT.yy(1);
nCT = size(CT.MM, 3);
iso.x = (CT.iso(1)-CT.xx(1))/dx;
iso.y = (CT.iso(2)-CT.yy(1))/dy;

%% contours
[cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
contData = cont.data;

% stat
CBCB = struct('nmse', NaN(nCT, CB.nCB), ...
                    'CC',     NaN(nCT, CB.nCB), ...
                    'mie',    NaN(nCT, CB.nCB), ...
                    'fsim',   NaN(nCT, CB.nCB), ...
                    'areaDelta', NaN(nCT, CB.nCB), ...
                    'morphDelta', NaN(nCT, CB.nCB));

%                 CBCB = struct('nmse', NaN(nCT, CB.nCB), ...
%                     'CC',     NaN(nCT, CB.nCB), ...
%                     'mie',    NaN(nCT, CB.nCB), ...
%                     'fsim',   NaN(nCT, CB.nCB));
                
ind_com = intersect(cont.ind, CB.ind{1});

for iC = 1:length(ind_com)
    iSlice = ind_com(iC);
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
    
    % crop
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
    
    IC_CT(~BW) = 0; %Image Crop, CT
    
    % stat
    VCT = IC_CT(BW);
%     nBinCT = length(unique(VCT));
    nBin = 100;
    
    VCT = double(VCT);
    numCT = histcounts(VCT, nBin);
    pdfVCT = numCT/sum(numCT);

    BW3d = repmat(BW, 1, 1, CB.nCB);

    % sliceCut
    sliceCut = CB.MMI(y1:y2, x1:x2, iSlice, :);
    IC_CB = reshape(sliceCut, M, N, CB.nCB);
    IC_CB(~BW3d) = 0;
    IC_CB = double(IC_CB);

    % abs
    minCB = min(IC_CB(:));
    maxCB = max(IC_CB(:));

    if minCB == 0
        edgeCB = linspace(minCB, maxCB, nBin+2);
        edgeCB = edgeCB(2:end);
    else
        edgeCB = linspace(minCB, maxCB, nBin+1);
    end
    
    nBinCB = zeros(CB.nCB, 1);
    pdf_CB = zeros(CB.nCB, nBin);
    
    %% CB
    for iCB = 1:CB.nCB

        ICB = IC_CB(:,:,iCB);
        if any(ICB(:))
            VCB = ICB(BW);

%             nBinCB(iCB) = length(unique(VCB));  % not use here, instead use 'nBinCT'

            % hist correlation coeff.
            if strcmp(CB.machineName{1}, CB.machineName{iCB})
                num_CB = histcounts(VCB, edgeCB);
            else
                num_CB = histcounts(VCB, nBin);
            end
            pdf_CB(iCB, :) = num_CB/sum(num_CB);

            junk1 = corrcoef(pdf_CB(1, :), pdf_CB(iCB, :));
            CBCB.CC(iSlice, iCB) = junk1(1,2);
            
            % hist mi
            [CBCB.mie(iSlice, iCB), jpdfe, entrp] = fun_mie(pdf_CB(1, :), pdf_CB(iCB, :));
 
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
            
            if strcmp(CB.machineName{1}, CB.machineName{iCB})
                IC_CB_norm = ICB/max(IC_CB(:));
                CBCB.nmse(iSlice, iCB) = immse(IC_CB_norm, IC_CB1_abs)/IC_CB1_abs2sum;
            else                
                IC_CB_norm = ICB/max(ICB(:));
                CBCB.nmse(iSlice, iCB) = immse(IC_CB_norm, IC_CB1_norm)/IC_CB1_norm2sum;
            end
            
            % area and morph change
            if iSlice == CT.idx_iso
                [CBCB.areaDelta(iSlice, iCB), CBCB.morphDelta(iSlice, iCB)] = fun_getDelta(IC_CB1, ICB, iso);
            end
            
            % FSIM - Feature Similarity
            ICB8 = uint8(ICB / 256);
            IC_CB18 = uint8(IC_CB1 / 256);
            CBCB.fsim(iSlice, iCB) = fun_FeatureSIM23(ICB8, IC_CB18);
        end
        
    end
    CBCB.mie(iSlice, :) = CBCB.mie(iSlice, :)/CBCB.mie(iSlice, 1);
    CBCB.fsim(iSlice, :) = CBCB.fsim(iSlice, :)/CBCB.fsim(iSlice, 1);
    
end