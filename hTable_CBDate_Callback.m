function hTable_CBDate_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
selected = data_main.selected;

idcs = evnt.Indices;
if numel(idcs)
    selected.idxDate = idcs(1);
    data_main.selected = selected;
    guidata(hFig_main, data_main);

%     if strcmp(data_main.hMenuItem.CTCB.Checked, 'on')
%     else
        updateCTImage(hFig_main, '1', selected.iSlice.z);
        updateCTImage(hFig_main, '2', selected.iSlice.x);
        updateCTImage(hFig_main, '3', selected.iSlice.y);
        
        %tumor
if strcmp(data_main.hMenuItem.tumor.Checked, 'on')
    updateTumor(hFig_main, '1', data_main.selected.iSlice.z);
end

        
        if strcmp(data_main.hMenuItem.AnalysisZ.Checked, 'on')
            updatePDF_zTime(data_main);
            updateJH_zTime(data_main);
            updateStat_zTime2d(data_main);
        elseif strcmp(data_main.hMenuItem.AnalysisZ_CBCT.Checked, 'on')
            updatePDF_CBCT_zTime(data_main);            
            updateJH_zTime(data_main);
            updateStat_zTime2d(data_main);
        end

        %     end
end
