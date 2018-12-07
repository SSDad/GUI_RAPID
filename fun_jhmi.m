function [jhmi] = fun_jhmi(imgC, nib)

jhmi.CBCB = NaN(imgC.nCT, imgC.nCB);
jhmi.CBCT = NaN(imgC.nCT, imgC.nCB);
jhmi.CTCT = NaN(imgC.nCT, 1);

h = waitbar(0, 'Calculating Joint Histogram MI...');

for iC = 1:length(imgC.sliceIdx)
    iSlice = imgC.sliceIdx(iC);  % slice
    IC_CT = imgC.CT{iSlice};
    IC_CB = imgC.CB{iSlice};
    maxV = max(max(IC_CT(:)), max(IC_CB(:)));      % max intensity for ct and cb stack
    maxV = double(maxV);

    if maxV > 100
        [imgJH] = fun_imgJH(IC_CT, IC_CT, maxV, nib);
        [jhmi.CTCT(iSlice)] = fun_calMI(imgJH);
    
        for iCB = 1:imgC.nCB

            ICB = IC_CB(:,:,iCB);
            if any(ICB(:))

                [imgJH] = fun_imgJH(IC_CB(:,:,1), IC_CB(:,:,iCB), maxV, nib);
                [jhmi.CBCB(iSlice, iCB)] = fun_calMI(imgJH);

                [imgJH] = fun_imgJH(IC_CT, IC_CB(:,:,iCB), maxV, nib);
                [jhmi.CBCT(iSlice, iCB)] = fun_calMI(imgJH);
            end
        end
        jhmi.CBCB(iSlice, :) =  jhmi.CBCB(iSlice, :)/ jhmi.CBCB(iSlice, 1);
        jhmi.CBCT(iSlice, :) =  jhmi.CBCT(iSlice, :)/ jhmi.CTCT(iSlice);

        waitbar(iC/length(imgC.sliceIdx))
    end
end
close(h) 