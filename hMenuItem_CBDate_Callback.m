function hMenuItem_CBDate_Callback(src, evnt)
    hFig_main = ancestor(src, 'Figure');
    data_main = guidata(hFig_main);
    
    if data_main.flag.CBLoaded
        if strcmp(get(data_main.hMenuItem.CBDate, 'checked'), 'on')
            set(data_main.hMenuItem.CBDate, 'checked', 'off');
            set(data_main.hPanel.CBDate, 'visible', 'off');
        else
            set(data_main.hMenuItem.CBDate, 'checked', 'on');
            set(data_main.hPanel.CBDate, 'visible', 'on');

            set(data_main.hMenuItem.Patient, 'checked', 'off');
            set(data_main.hPanel.PL, 'visible', 'off');

        end
    end
    
