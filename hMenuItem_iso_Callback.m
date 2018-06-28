function hMenuItem_iso_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
iso = data_main.iso;

updateCTImage(hFig_main, '1', iso.iSlice.z);
updateCTImage(hFig_main, '2', iso.iSlice.x);
updateCTImage(hFig_main, '3', iso.iSlice.y);

showISO(hFig_main, '1', iso.iSlice.z);
showISO(hFig_main, '2', iso.iSlice.x);
showISO(hFig_main, '3', iso.iSlice.y);

updateSS(hFig_main, '1', iso.iSlice.z)
updateSS(hFig_main, '2', iso.iSlice.x)
updateSS(hFig_main, '3', iso.iSlice.y)

data_main.selected.iSlice.z = iso.iSlice.z;
data_main.selected.iSlice.x = iso.iSlice.x;
data_main.selected.iSlice.y = iso.iSlice.y;

if strcmp(data_main.hMenuItem.AnalysisZ.Checked, 'on')
    updatePDF_zTime(data_main);
    updateStat_zTime3d(data_main);
end

guidata(hFig_main, data_main);