function hMenuItem_AnalysisZ_CBCT_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
selected = data_main.selected;

if strcmp(data_main.hMenuItem.AnalysisZ_CBCT.Checked, 'off')

    set(data_main.hMenuItem.AnalysisZ, 'checked', 'off');
    set(data_main.hMenuItem.AnalysisZ_CBCT, 'checked', 'on');

    % stat
    updatePDF_CBCT_zTime(data_main);
    
    % turn on pdf and Stat panels
    set(data_main.hPanel.pdf_zTime, 'visible', 'on');
    set(data_main.hPanel.Stat_zTime, 'visible', 'off');
    
    % view panel position
    set(data_main.hPanel.CT(1), 'Position',  [0    0 1/3 0.5]);
    set(data_main.hPanel.CT(2), 'Position',  [1/3 0 1/3 0.5]);
    set(data_main.hPanel.CT(3), 'Position',  [2/3 0 1/3 0.5]);
    
else
    set(data_main.hMenuItem.AnalysisZ_CBCT, 'checked', 'off');

    set(data_main.hPanel.pdf_zTime, 'visible', 'off');
    set(data_main.hPanel.Stat_zTime, 'visible', 'off');

    set(data_main.hPanel.CT(1), 'Position',  [0 0 0.6 1]);
    set(data_main.hPanel.CT(2), 'Position',  [0.6 0.5 0.4 0.5]);
    set(data_main.hPanel.CT(3), 'Position',  [0.6 0    0.4 0.5]);
end