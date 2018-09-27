function hTable_SS_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
selected = data_main.selected;

idcs = evnt.Indices;
if ~isempty(idcs)
%     if idcs(1) == selected.idxSS
%         set(data_main.hPlotObj.SS.z, 'visible', 'off')
%         set(data_main.hPlotObj.SS.x, 'visible', 'off')
%         set(data_main.hPlotObj.SS.y, 'visible', 'off')
%     else
        src.Data{selected.idxSS, 1} = false;
        selected.idxSS = idcs(1);
        src.Data{selected.idxSS, 1} = true; 
        
        data_main.selected = selected;
        guidata(hFig_main, data_main);

        set(data_main.hPlotObj.SS.z, 'visible', 'on')
        set(data_main.hPlotObj.SS.x, 'visible', 'on')
        set(data_main.hPlotObj.SS.y, 'visible', 'on')
    
        updateSS(hFig_main, '1', selected.iSlice.z);
        updateSS(hFig_main, '2', selected.iSlice.x);
        updateSS(hFig_main, '3', selected.iSlice.y);
        
        if strcmp(data_main.hMenuItem.AnalysisZ.Checked, 'on')
            data_main = guidata(hFig_main);
            updatePDF_zTime(data_main);
            updateStat_zTime2d(data_main);
%             initializeStat_zTime3d(data_main);
            updateStat_zTime3d(data_main);
        elseif strcmp(data_main.hMenuItem.AnalysisZ_CBCT.Checked, 'on')
            updatePDF_CBCT_zTime(data_main);            
        end
end