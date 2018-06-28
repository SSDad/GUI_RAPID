function updateSS(hFig_main, panelTag, iSlice)

data_main = guidata(hFig_main);
CT = data_main.CT;
hPlotObj = data_main.hPlotObj;
selected = data_main.selected;
SS = data_main.SS;
SS_SagCor = data_main.SS_SagCor;

switch panelTag
    case '1'
        [cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
        contData = cont.data;

        if iSlice <= cont.ind(1) && iSlice >= cont.ind(end)
            xx = [];
            yy = [];
            for iS = 1:length(contData{iSlice})
                points = contData{iSlice}(iS).points;
                x = points(:,1);
                y = points(:,2);

                xx = [xx;x]; 
                yy = [yy;y];
            end
            set(hPlotObj.SS.z, 'xdata', xx, 'ydata', yy, 'color', SS.contourColor{selected.idxSS}/255);    
%             set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')
        else
            set(hPlotObj.SS.z, 'xdata', (nan), 'ydata', (nan));    
%             set(hText.Struct, 'visible', 'off')
        end
        
    case '2'  % x cut
        if isempty(SS_SagCor(selected.idxSS).sag(iSlice).pt)
            set(hPlotObj.SS.x, 'xdata', [], 'ydata', []);    
        else
            ptmm = [];
            for iB = 1:length(SS_SagCor(selected.idxSS).sag(iSlice).pt)
                pt = SS_SagCor(selected.idxSS).sag(iSlice).pt{iB};
                ptmm = [ptmm;pt];
            end
            set(hPlotObj.SS.x, 'xdata', ptmm(:,2), 'ydata', ptmm(:,1), 'color', SS.contourColor{selected.idxSS}/255);
        end
        
    case '3' % y cut
        if isempty(SS_SagCor(selected.idxSS).cor(iSlice).pt)
            set(hPlotObj.SS.y, 'xdata', [], 'ydata', []);    
        else
            ptmm = [];
            for iB = 1:length(SS_SagCor(selected.idxSS).cor(iSlice).pt)
                pt = SS_SagCor(selected.idxSS).cor(iSlice).pt{iB};
                ptmm = [ptmm;pt];
            end
            set(hPlotObj.SS.y, 'xdata', ptmm(:,2), 'ydata', ptmm(:,1), 'color', SS.contourColor{selected.idxSS}/255);
        end
end