function hTable_SS_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
selected = data_main.selected;

idcs = evnt.Indices;
if ~isempty(idcs)
    if idcs(1) == selected.idxSS
        set(data_main.hPlotObj.SS.z, 'visible', 'off')
        set(data_main.hPlotObj.SS.x, 'visible', 'off')
        set(data_main.hPlotObj.SS.y, 'visible', 'off')
    else
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
    end
end