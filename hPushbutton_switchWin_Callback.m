function hPushbutton_switchWin_Callback(src, ~)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
winID = str2num(src.Tag);

h = get(src,'parent');
if data_main.Param.CT.singleWin
    set(h, 'Position', data_main.Param.CT.pos(winID, :), 'Visible', 'on');
    set(data_main.hPanel.CT, 'Visible', 'on');
    data_main.Param.CT.singleWin = false;
else
    set(data_main.hPanel.CT, 'Visible', 'off');
    set(h, 'Position', [0 0 1 1], 'Visible', 'on');
    data_main.Param.CT.singleWin = true;
end
guidata(hFig_main, data_main)