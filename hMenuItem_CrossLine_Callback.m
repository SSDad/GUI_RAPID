function hMenuItem_CrossLine_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hPlotObj = data_main.hPlotObj;
hCrossLine = data_main.hMenuItem.CrossLine;
% if strcmp(data_main.hMenuItem.CT.Checked, 'on')
    if strcmp(hCrossLine.Checked, 'on')
        hCrossLine.Checked = 'off';
        set(hPlotObj.CrossLine.z, 'visible', 'off')
        set(hPlotObj.CrossLine.x, 'visible', 'off')
        set(hPlotObj.CrossLine.y, 'visible', 'off')
    else
        hCrossLine.Checked = 'on';
        set(hPlotObj.CrossLine.z, 'visible', 'on')
        set(hPlotObj.CrossLine.x, 'visible', 'on')
        set(hPlotObj.CrossLine.y, 'visible', 'on')
    end
% end