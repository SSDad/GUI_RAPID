function hToolbarItem_Distance_Callback(src, evnt)
    hFig_main = ancestor(src, 'Figure');
    data_main = guidata(hFig_main);
    
    panelNo = 1;
    if isfield( data_main.selected, 'Panel')
        panelTag = get(data_main.selected.Panel, 'tag');
        panelNo = str2num(panelTag);
    end
    imdistline(data_main.hAxis.CT(panelNo));