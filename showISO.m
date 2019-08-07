function showISO(hFig_main, panelTag, iSlice)

data_main = guidata(hFig_main);
CT = data_main.CT;
hPlotObj = data_main.hPlotObj;
% iso = data_main.iso;

switch panelTag
    case '1'
        set(hPlotObj.iso.z, 'visible', 'off');
        if iSlice == iso.iSlice.z
            set(hPlotObj.iso.z, 'visible', 'on');
        end

    case '2'
        set(hPlotObj.iso.x, 'visible', 'off');
        if iSlice == iso.iSlice.x
            set(hPlotObj.iso.x, 'visible', 'on');
        end

    case '3'
        set(hPlotObj.iso.y, 'visible', 'off');
        if iSlice == iso.iSlice.y
            set(hPlotObj.iso.y, 'visible', 'on');
        end

end