function hMenuItem_CB_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

selected = data_main.selected;
hPlotObj = data_main.hPlotObj;
hAxis = data_main.hAxis;

if ~data_main.flag.CBLoaded
    [CBinfo, CB] = loadCB(hFig_main);
    data_main.flag.CBLoaded = true;

    data_main.flag.CBInfoTableFilled = false;
    
%     CB.Lim = [min(CB.minI) max(CB.maxI)]; CB.Lim = double(CB.Lim);
    selected.idxDate = 1;

    % save data
    data_main.selected = selected;
    data_main.CBinfo = CBinfo;
    data_main.CB = CB;
    guidata(hFig_main, data_main);
else
    CBinfo = data_main.CBinfo;
    CB = data_main.CB;
end

[M, N, P] = size(data_main.CT.MM);

ICB{1} = zeros(M, N);
ICB{2} = zeros(P, M);
ICB{3} = zeros(P, N);

iDate = selected.idxDate;
MMI = CB(iDate).MMI;
ind1 = CB(iDate).ind1;
ind2 = CB(iDate).ind2;

% Axial
ICB{1}(ind1(2):ind2(2), ind1(3):ind2(3)) =...
                                                        MMI(:,:,selected.iSlice.z-ind1(1)+1);

set(hPlotObj.CT(1), 'CData', []); 
set(hPlotObj.CT(1), 'CData', ICB{1}); 
set(hPlotObj.CT(1), 'visible', 'on'); 
set(hAxis.CT(1), 'CLim', [CB(iDate).Lim(1) CB(iDate).Lim(2)]);

%Sagittal
ICB{2}(P-ind2(1)+1:P-ind1(1)+1, ind1(2):ind2(2)) =...
                                                        rot90(squeeze(MMI(:, selected.iSlice.x-ind1(3)+1, :)));

set(hPlotObj.CT(2), 'CData', []); 
set(hPlotObj.CT(2), 'CData', ICB{2}); 
set(hPlotObj.CT(2), 'visible', 'on'); 
set(hAxis.CT(2), 'CLim', [CB(iDate).Lim(1) CB(iDate).Lim(2)]);

%Coronal
ICB{3}(P-ind2(1)+1:P-ind1(1)+1, ind1(3):ind2(3)) =...
                                                        rot90(squeeze(MMI(selected.iSlice.y-ind1(2)+1, :, :)));

set(hPlotObj.CT(3), 'CData', []); 
set(hPlotObj.CT(3), 'CData', ICB{3}); 
set(hPlotObj.CT(3), 'visible', 'on'); 
set(hAxis.CT(3), 'CLim', [CB(iDate).Lim(1) CB(iDate).Lim(2)]);

% contrast bar
set(get(hAxis.contrast1, 'children'), 'visible', 'on')
showContrast_MV(hFig_main, hAxis.CT, hAxis.contrast1, ICB{1}, CB(iDate).Lim);
set(get(hAxis.contrast2, 'children'), 'visible', 'off')

% CBDate table
hPanel = data_main.hPanel;
hTable = data_main.hTable;
hMenuItem = data_main.hMenuItem;

CBDate = cell(length(CBinfo), 1);
for iDate = 1:size(CBDate, 1)
    CBDate{iDate} = CBinfo(iDate).date;
end
set(hTable.CBDate, 'Data', CBDate);
set(hPanel.CBDate, 'Visible', 'on');
set(hMenuItem.CBDate, 'Enable', 'on', 'Checked', 'on');
jScroll = findjobj(hTable.CBDate);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

% set(hTable.PL, 'Visible', 'off');
% set(hMenuItem.Patient, 'Checked', 'off');
% set(hTable.SS, 'Visible', 'off');
% set(hMenuItem.SS, 'Checked', 'off');

% menu on/off
set(hMenuItem.CT, 'Checked', 'off');
set(hMenuItem.CB, 'Checked', 'on');
set(hMenuItem.CTCB, 'Checked', 'off');

set(hMenuItem.CBInfo, 'Enable', 'on');

set(data_main.hPanel.ptInfo, 'visible', 'off');

% set(hText.playInterval, 'Visible', 'on');
% set(hPopup.playInterval, 'Visible', 'on');
% set(hPushbutton.playCBDate, 'Visible', 'on');