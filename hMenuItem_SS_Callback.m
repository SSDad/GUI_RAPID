function hMenuItem_SS_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

if ~data_main.flag.SSLoaded
    % Load SS
    ffd = fullfile(data_main.fd_data, data_main.RadoncIDFolder);
    ffn_SS = fullfile(ffd, [data_main.RadoncID, '_SS']);
    load(ffn_SS)
    data_main.flag.SSLoaded = true;
    SS.contourColor = contourColor;
    SS.sNames = sNames;
    SS.structures = structures;
    data_main.SS = SS;

    ffn_SS_SagCor = fullfile(ffd, [data_main.RadoncID, '_SS_SagCor.mat']);
    if exist(ffn_SS_SagCor, 'file')
        load(ffn_SS_SagCor);
        data_main.SS_SagCor = SS_SagCor;
        data_main.flag.SS_SagCorLoaded = true;
    end
    
    % Fill SS Table
    nS = length(SS.structures);
    tableData.Struct = cell(nS, 1);
    for iS = 1:nS
        sCLR = dec2hex(SS.contourColor{iS});
        sCLR_Char = reshape(sCLR', 1, 6);
        tableData.Struct{iS, 2} = ['<html><font color =' sCLR_Char '>' SS.sNames{iS} '</font></html>'];
        tableData.Struct{iS, 1} = false;
    end

%     set(data_main.hTable.SS, 'Data', tableData.Struct, 'Visible',   'on');
    data_main.hTable.SS.Data = tableData.Struct;
    data_main.hPanel.SS.Visible = 'on';
    jScroll = findjobj(data_main.hTable.SS);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
    
    % PTV index
    selected = data_main.selected;
    selected.idxSS = 1;
    for j = 1:length(SS.sNames)
        if contains(SS.sNames{j}, 'PTV')  % strcmp('PTV', SS.sNames{j}(1:3))
            selected.idxSS = j;
            data_main.hTable.SS.Data{j, 1} = true;
            break
        end
    end
    
    % iso
    CT = data_main.CT;
    hPlotObj = data_main.hPlotObj;
    set(hPlotObj.iso.z, 'xdata', CT.iso(1), 'ydata', CT.iso(2));
    set(hPlotObj.iso.x, 'xdata', CT.iso(2), 'ydata', CT.zz(1)-CT.iso(3)+CT.zz(end));
    set(hPlotObj.iso.y, 'xdata', CT.iso(1), 'ydata', CT.zz(1)-CT.iso(3)+CT.zz(end));
    set(data_main.hMenuItem.iso, 'Enable', 'on')
    
    % check menuitem
    set(data_main.hMenuItem.SS, 'Checked', 'on');

    data_main.selected = selected;
    guidata(hFig_main, data_main);

else
    if strcmp(data_main.hMenuItem.SS.Checked, 'on')
        data_main.hMenuItem.SS.Checked = 'off';
        set(data_main.hPanel.SS, 'visible', 'off');
    else
        data_main.hMenuItem.SS.Checked = 'on';
        set(data_main.hPanel.SS, 'visible', 'on');
    end
end

set(data_main.hPanel.PL, 'visible', 'off');
set(data_main.hMenuItem.Patient, 'checked', 'off');

updateSS(hFig_main, '1', data_main.selected.iSlice.z);
updateSS(hFig_main, '2', data_main.selected.iSlice.x);
updateSS(hFig_main, '3', data_main.selected.iSlice.y);

%% Analysis
if data_main.flag.CBLoaded
    set(data_main.hMenuItem.AnalysisZ, 'Enable', 'on');
end
% updatePDF(data_main);