function updateJH_zTime(data_main)

if strcmp(data_main.hMenuItem.jhZ.Checked, 'on')

selected = data_main.selected;
imgC = data_main.imgC(selected.idxSS);
hPlotObj = data_main.hPlotObj;

CT = imgC.CT{selected.iSlice.z};
CB = imgC.CB{selected.iSlice.z};
maxV = max(max(CT(:)), max(CB(:)));
maxV = double(maxV);

    if strcmp(data_main.hMenuItem.AnalysisZ.Checked, 'on')
        CT = CB(:,:,1);
    elseif strcmp(data_main.hMenuItem.AnalysisZ_CBCT.Checked, 'on')
        
    else
        return
    end
   
%     [jh.CTCT] = fun_imgJH(CT, CT, maxV);
%     [mi_CTCT] = fun_calMI(jh.CTCT);

nib = 10; % number in bin
    for iCB = 1:size(CB, 3)
        [jh{iCB}] = fun_imgJH(CT, CB(:,:,iCB), maxV, nib);
        [mi(iCB)] = fun_calMI(jh{iCB});
    end
    
%     nSub = min(iCB-selected.idxDate+1, 4);up
    idx_CB = selected.idxDate:iCB; 
    nSub = min(iCB-selected.idxDate+1, 4);
    for iSub = 1:nSub
        A = jh{idx_CB(iSub)};
%         A(1) = 0;
        A = A>0;
        if isdiag(single(A))
            
%             line([1 size(A, 2)], [1 size(A, 1)], 'color', 'w', 'linewidth', 1,...
%                 'parent', data_main.hAxis.jhSub(iSub));
        end
        set(hPlotObj.jhSub(iSub), 'CData', A, 'visible', 'on'); 
    end
    
    if nSub < 4
        for iSub = nSub+1:4
            set(hPlotObj.jhSub(iSub), 'CData', []); 
        end
    end
            
end