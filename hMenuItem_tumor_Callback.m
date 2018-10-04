function hMenuItem_tumor_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

if strcmp(data_main.hMenuItem.tumor.Checked, 'off')
    set(data_main.hMenuItem.tumor, 'Checked', 'on');
    updateTumor(hFig_main, '1', data_main.selected.iSlice.z);
elseif strcmp(data_main.hMenuItem.tumor.Checked, 'on')
    set(data_main.hMenuItem.tumor, 'Checked', 'off');
    set(data_main.hPlotObj.tumor, 'xdata', [], 'ydata', [], 'visible', 'on');    
end