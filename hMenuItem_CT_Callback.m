function hMenuItem_CT_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

if ~data_main.flag.CTLoaded
    ffd = fullfile(data_main.fd_data, data_main.RadoncIDFolder);
    ffn_CT = fullfile(ffd, [data_main.RadoncID, '_initialCT']);
    load(ffn_CT)
    data_main.flag.CTLoaded = true;
    CT.Lim = [min(CT.MM(:)) max(CT.MM(:))];
    CT.Lim = double(CT.Lim);
%     CT.MMn = single(mat2gray(CT.MM, CT.Lim));
    data_main.CT = CT;
    
  set(hFig_main, 'Name', [data_main.version, ' - ',...
                                    data_main.RadoncID, '   ', ...
                                    data_main.RadoncIDfromTable]);
  
else
    CT = data_main.CT;
end

% set(hPanel.CT(1), 'Title', 'Primary CT');

selected = data_main.selected;
hAxis = data_main.hAxis;
hPlotObj = data_main.hPlotObj;
hText = data_main.hText;

% Axial
selected.iSlice.z = round(size(CT.MM,3)/2);
ICT{1} = CT.MM(:, :, selected.iSlice.z);
set(hPlotObj.CT(1), 'CData', []); 
set(hPlotObj.CT(1), 'CData', ICT{1}); 
set(hPlotObj.CT(1), 'visible', 'on'); 
set(hAxis.CT(1), 'CLim', [CT.Lim(1) CT.Lim(2)]);

set(hText.CT(1), 'String', ['Axial slice: ', num2str(selected.iSlice.z-1)])
% set(hText.CTcm(1), 'String', ['Y: ', num2str((CT.zz(selected.iSlice.z)-CT.iso(3))/10, '%5.2f'), ' cm'])
set(hText.CTcm(1), 'String', ['Y: ', num2str((CT.zz(selected.iSlice.z)-0)/10, '%5.2f'), ' cm'])

% use mm
set(hPlotObj.CT(1), 'XData', CT.xx, 'YData', CT.yy); 
% set(hAxes.sliceImage(1), 'XLim', [CT.xx(1) CT.xx(end)], 'YLim', [CT.yy(1) CT.yy(end)]);

% Saggittal
CT.dx = CT.xx(2)-CT.xx(1);
selected.iSlice.x = round(size(CT.MM,2)/2);
ICT{2} = rot90(squeeze(CT.MM(:, selected.iSlice.x, :)));

set(hPlotObj.CT(2), 'CData', []); 
set(hPlotObj.CT(2), 'CData', ICT{2}); 
set(hPlotObj.CT(2), 'visible', 'on'); 
set(hAxis.CT(2), 'CLim', [CT.Lim(1) CT.Lim(2)]);

set(hText.CT(2), 'String', ['Sagittal slice: ', num2str(selected.iSlice.x-1)])
% set(hText.CTcm(2), 'String', ['X: ', num2str((CT.xx(selected.iSlice.x)-CT.iso(1))/10, '%5.2f'), ' cm'])
set(hText.CTcm(2), 'String', ['X: ', num2str((CT.xx(selected.iSlice.x)-0)/10, '%5.2f'), ' cm'])

% use mm
set(hPlotObj.CT(2), 'XData', CT.yy, 'YData', CT.zz); 

% hCrossLine.z(1) = line(hAxis.CT(2), 'XData', [CT.yy(1) CT.yy(end)], 'YData', [CT.zz(iz), CT.zz(iz)]);

% Coronal
CT.dy = CT.yy(2)-CT.yy(1);
selected.iSlice.y = round(size(CT.MM,1)/2);
ICT{3} = rot90(squeeze(CT.MM(selected.iSlice.y, :, :)));

set(hPlotObj.CT(3), 'CData', []); 
set(hPlotObj.CT(3), 'CData', ICT{3}); 
set(hPlotObj.CT(3), 'visible', 'on'); 
set(hAxis.CT(3), 'CLim', [CT.Lim(1) CT.Lim(2)]);

set(hText.CT(3), 'String', ['Coronal slice: ', num2str(selected.iSlice.y-1)])
% set(hText.CTcm(3), 'String', ['Z: ', num2str((CT.yy(selected.iSlice.y)-CT.iso(2))/10, '%5.2f'), ' cm'])
set(hText.CTcm(3), 'String', ['Z: ', num2str((-CT.yy(selected.iSlice.y)-0)/10, '%5.2f'), ' cm'])

% use mm
set(hPlotObj.CT(3), 'XData', CT.xx, 'YData', CT.zz);

%% Initialize
% contrast bar on
set(get(hAxis.contrast1, 'children'), 'visible', 'on')
showContrast_MV(hFig_main, hAxis.CT, hAxis.contrast1, ICT{1}, CT.Lim);
set(get(hAxis.contrast2, 'children'), 'visible', 'off')

set(data_main.hMenuItem.bar, 'Checked', 'on', 'Enable', 'on')
% uistack(data_main.hPanel.Bar, 'top');

% cross lines
iz = size(CT.MM, 3) - selected.iSlice.z +1;
set(hPlotObj.CrossLine.z(1), 'XData', [CT.yy(1) CT.yy(end)], 'YData', [CT.zz(iz), CT.zz(iz)], 'visible', 'off');
set(hPlotObj.CrossLine.z(2), 'XData', [CT.xx(1) CT.xx(end)], 'YData', [CT.zz(iz), CT.zz(iz)], 'visible', 'off');

ix = selected.iSlice.x;
set(hPlotObj.CrossLine.x(1), 'XData', [CT.xx(ix) CT.xx(ix)], 'YData', [CT.yy(1), CT.yy(end)], 'visible', 'off');
set(hPlotObj.CrossLine.x(2), 'XData', [CT.xx(ix) CT.xx(ix)], 'YData', [CT.zz(1), CT.zz(end)], 'visible', 'off');

iy = selected.iSlice.y;
set(hPlotObj.CrossLine.y(1), 'XData', [CT.xx(1) CT.xx(end)], 'YData', [CT.yy(iy), CT.yy(iy)], 'visible', 'off');
set(hPlotObj.CrossLine.y(2), 'YData', [CT.zz(1) CT.zz(end)], 'XData', [CT.yy(iy), CT.yy(iy)], 'visible', 'off');

set(data_main.hMenuItem.CrossLine, 'Enable', 'on', 'Checked', 'off')

% Text
set(data_main.hText.CT, 'visible', 'on')
set(data_main.hText.CTcm, 'visible', 'on')

% structure set
set(data_main.hMenuItem.SS, 'Enable', 'on')

% panel border
hAllPanel = get(data_main.hPanel.View, 'children');
set(hAllPanel, 'HighLightColor', 'black', 'ShadowColor',  'black');

% view panel on
set(data_main.hPanel.View, 'visible', 'on');

% menu on/off
set(data_main.hMenuItem.CT, 'Checked', 'on');
set(data_main.hMenuItem.CB, 'Checked', 'off');
set(data_main.hMenuItem.CTCB, 'Checked', 'off');

% tumor
if strcmp(data_main.hMenuItem.tumor.Checked, 'on')
    updateTumor(hFig_main, '1', data_main.selected.iSlice.z);
end

% tables off
% set(data_main.hTable.CBDate, 'Visible', 'off');

%% save data
data_main.selected = selected;
guidata(hFig_main, data_main);