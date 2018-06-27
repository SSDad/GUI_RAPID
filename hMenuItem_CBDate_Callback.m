function hMenuItem_CBDate_Callback(src, evnt)
    hFig_main = ancestor(src, 'Figure');
    data_main = guidata(hFig_main);
    
    if data_main.flag.CBLoaded
        if strcmp(get(data_main.hMenuItem.CBDate, 'checked'), 'on')
            set(data_main.hMenuItem.CBDate, 'checked', 'off');
            set(data_main.hTable.CBDate, 'visible', 'off');
        else
            set(data_main.hMenuItem.CBDate, 'checked', 'on');
            set(data_main.hTable.CBDate, 'visible', 'on');

            set(data_main.hMenuItem.Patient, 'checked', 'off');
            set(data_main.hTable.PL, 'visible', 'off');

            set(data_main.hMenuItem.SS, 'checked', 'off');
            set(data_main.hTable.SS, 'visible', 'off');
        end
    end
    
