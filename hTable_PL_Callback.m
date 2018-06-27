function hTable_PL_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
ptNo = get(data_main.hTable.PL, 'Data'); 

idcs = evnt.Indices;
if numel(idcs)
    data_main.RadoncIDfromTable = ptNo{idcs(1)};
end
guidata(hFig_main, data_main);