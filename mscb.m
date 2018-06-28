% Mouse Scroll Call Back
% Called in RAPID: 'WindowScrollWheelFcn';
function mscb(src, evnt)

step = evnt.VerticalScrollCount;

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

if isfield(data_main, 'selected')
if isfield(data_main.selected, 'Panel')
    if ~isempty(data_main.selected.Panel)
        selected = data_main.selected;
        panelTag = get(selected.Panel, 'tag');

        switch panelTag
            case '1'
                selected.iSlice.z = selected.iSlice.z+step;
                iSlice = selected.iSlice.z;
            case '2'
                selected.iSlice.x = selected.iSlice.x+step;
                iSlice = selected.iSlice.x;
            case '3'
                selected.iSlice.y = selected.iSlice.y+step;
                iSlice = selected.iSlice.y;
        end
        
        updateCTImage(hFig_main, panelTag, iSlice);
        showISO(hFig_main, panelTag, iSlice)

        if data_main.flag.SSLoaded
            updateSS(hFig_main, panelTag, iSlice)
%             updateSS(hFig_main, '1', data_main.selected.iSlice.z)
        end
        
        data_main.selected = selected;
        guidata(hFig_main, data_main)

        if strcmp(data_main.hMenuItem.AnalysisZ.Checked, 'on')
            updatePDF_zTime(data_main);
            updateStat_zTime2d(data_main);
            updateStat_zTime3d(data_main);
        end
        
    end
end
end