function hMenuItem_bar_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
hAxis = data_main.hAxis;
hBar = data_main.hMenuItem.bar;
if strcmp(data_main.hMenuItem.CT.Checked, 'on')
    if strcmp(hBar.Checked, 'on')
        hBar.Checked = 'off';
        set(get(hAxis.contrast1, 'children'), 'visible', 'off')
    else
        hBar.Checked = 'on';
        set(get(hAxis.contrast1, 'children'), 'visible', 'on')
    end
end