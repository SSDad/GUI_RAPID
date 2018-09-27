function updatePDF_CBCT_zTime(data_main)

if data_main.flag.SSLoaded && data_main.flag.CBLoaded

    CT = data_main.CT;
    CB = data_main.CB;
    CBinfo = data_main.CBinfo;
    selected = data_main.selected;
    hPlotObj = data_main.hPlotObj;

    [subImg, subPDF, iso] = fun_getPDF(CT, CB, CBinfo, data_main.SS, selected);

    if isfield(subImg, 'CT') && isfield(subImg, 'CB')
    
        I1 = subImg.CT;

        [~, ~, nSub] = size(subImg.CB);
        for iSub = 1:nSub

            I2 = subImg.CB(:,:,iSub);
            II = imfuse(I2, I1);
            set(hPlotObj.sliceSub(iSub), 'CData', II); 

    %             if selected.Slice == CT.idx_iso
    %     hPlotObj.isoSub(iSub).z = line((nan), (nan), 'Marker', '+', 'MarkerSize', 50,  'Color','yellow', 'parent', hAxis.sliceSub(iSub));
    %                 plot(iso.x, iso.y, '+y', 'MarkerSize', 50, 'parent', hAxes.sliceSub(iSub))  % iso point
    %             end

            set(hPlotObj.subPDF(iSub).CB, 'XData', subPDF.CBCT.x{iSub}, 'YData', subPDF.CBCT.y{iSub});
            set(hPlotObj.subPDF(iSub).CB1, 'XData', subPDF.CT.x, 'YData', subPDF.CT.y);
        end

        if nSub < 4
            for iSub = nSub+1:4
                set(hPlotObj.sliceSub(iSub), 'CData', []);        
                set(hPlotObj.subPDF(iSub).CB, 'XData', [], 'YData', []);
                set(hPlotObj.subPDF(iSub).CB1, 'XData', [], 'YData', []);
            end
        end
    else
        for iSub = 1:4
            set(hPlotObj.sliceSub(iSub), 'CData', []);        
            set(hPlotObj.subPDF(iSub).CB, 'XData', [], 'YData', []);
            set(hPlotObj.subPDF(iSub).CB1, 'XData', [], 'YData', []);
        end
    end
end
