function hMenuItem_AnalysisZ_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
selected = data_main.selected;

if strcmp(data_main.hMenuItem.AnalysisZ.Checked, 'off')
    set(data_main.hMenuItem.AnalysisZ, 'checked', 'on');

    % pdf
    set(data_main.hPanel.pdf_z, 'visible', 'on');
    set(data_main.hPanel.Stat_z, 'visible', 'on');
    
    % stat
    updateStat(data_main);
        
    % view panel position
    set(data_main.hPanel.CT(3), 'Position',  [0.6 0    0.4  1/3]);
    set(data_main.hPanel.CT(2), 'Position',  [0.6 1/3 0.4 1/3]);
    set(data_main.hPanel.CT(1), 'Position',  [0.6 2/3 0.4 1/3]);
    
else
    set(data_main.hMenuItem.AnalysisZ, 'checked', 'off');

    set(data_main.hPanel.pdf_z, 'visible', 'off');
    set(data_main.hPanel.Stat_z, 'visible', 'off');

    set(data_main.hPanel.CT(1), 'Position',  [0 0 0.6 1]);
    set(data_main.hPanel.CT(2), 'Position',  [0.6 0.5 0.4 0.5]);
    set(data_main.hPanel.CT(3), 'Position',  [0.6 0    0.4 0.5]);
end