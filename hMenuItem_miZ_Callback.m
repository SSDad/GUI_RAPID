function hMenuItem_miZ_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
selected = data_main.selected;

if strcmp(data_main.hMenuItem.miZ.Checked, 'off')
    set(data_main.hMenuItem.miZ, 'checked', 'on');
    
    load(data_main.statFileName);
    if ~exist('jhmi', 'var')
        [jhmi] = fun_jhmi(data_main.imgC(data_main.selected.idxSS));
        save(data_main.statFileName, 'jhmi', '-append');
    end
    
    data_main.CBCB(selected.idxSS).jhmi = jhmi.CBCB;
    data_main.CBCT(selected.idxSS).jhmi = jhmi.CBCT;
    guidata(hFig_main, data_main);

    updateStat_zTime2d(data_main);

    initializeStat_zTime3d(data_main);
    updateStat_zTime3d(data_main);
else
    set(data_main.hMenuItem.miZ, 'checked', 'off');
end