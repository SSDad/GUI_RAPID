function hMenuItem_jhZ_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

if strcmp(data_main.hMenuItem.jhZ.Checked, 'off')
    set(data_main.hMenuItem.jhZ, 'checked', 'on');
else
    set(data_main.hMenuItem.jhZ, 'checked', 'off');
end