function hMenuItem_CTCB_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

CT = data_main.CT;
selected = data_main.selected;
hPlotObj = data_main.hPlotObj;
hAxis = data_main.hAxis;

if ~data_main.flag.CBLoaded
    
    [CBinfo, CB] = loadCB(hFig_main);
    data_main.flag.CBLoaded = true;
%     set(data_main.hMenuItem.dcmInfo, 'Enable', 'on');
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

ICB_z = zeros(M, N);
ICB_x = zeros(P, M);
ICB_y = zeros(P, N);

iDate = selected.idxDate;
MMI = CB(iDate).MMI;
ind1 = CB(iDate).ind1;
ind2 = CB(iDate).ind2;
CBLim = CB(iDate).Lim;
% Axial
ICB_z(ind1(2):ind2(2), ind1(3):ind2(3)) = MMI(:,:,selected.iSlice.z-ind1(1)+1);
ICBn_z = mat2gray(ICB_z, CBLim);

ICT_z = CT.MM(:,:,selected.iSlice.z);
ICTn_z = mat2gray(ICT_z, CT.Lim);

III_z(:,:,1) = ICTn_z;
III_z(:,:,2) = ICBn_z;
III_z(:,:,3) = ICTn_z;
set(hPlotObj.CT(1), 'CData', III_z); 
set(hPlotObj.CT(1), 'visible', 'on'); 

set(hPlotObj.CT(1), 'userdata', [0 1 0 1]);
set(hAxis.CT(1), 'clim', [0 1]);
IIO(1).CTn = ICTn_z;
IIO(1).CBn = ICBn_z;

% set(hText.Slice, 'String', ['Slice ', num2str(selected.iSlice.z)], 'visible', 'on')
% set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')
% set(hText.CBDate, 'String', CB.dateCreated(selected.idxDate, :), 'visible', 'on')
% set(hPushbutton.showTumor, 'visible', 'off')

%Sagittal
ICB_x(P-ind2(1)+1:P-ind1(1)+1, ind1(2):ind2(2)) = rot90(squeeze(MMI(:,selected.iSlice.x-ind1(3)+1, :)));
ICBn_x = mat2gray(ICB_x, CBLim);

ICT_x = rot90(squeeze(CT.MM(:, selected.iSlice.x, :)));
ICTn_x = mat2gray(ICT_x, data_main.CT.Lim);

III_x(:,:,1) = ICTn_x;
III_x(:,:,2) = ICBn_x;
III_x(:,:,3) = ICTn_x;
set(hPlotObj.CT(2), 'CData', III_x); 
set(hPlotObj.CT(2), 'visible', 'on'); 
set(hAxis.CT(2), 'clim', [0 1]);

IIO(2).CTn = ICTn_x;
IIO(2).CBn = ICBn_x;

%Coronal
ICB_y(P-ind2(1)+1:P-ind1(1)+1, ind1(3):ind2(3)) = rot90(squeeze(MMI(selected.iSlice.y-ind1(2)+1, :, :)));
ICBn_y = mat2gray(ICB_y, CBLim);

ICT_y = rot90(squeeze(CT.MM(selected.iSlice.y, :, :)));
ICTn_y = mat2gray(ICT_y, data_main.CT.Lim);

III_y(:,:,1) = ICTn_y;
III_y(:,:,2) = ICBn_y;
III_y(:,:,3) = ICTn_y;
set(hPlotObj.CT(3), 'CData', III_y); 
set(hPlotObj.CT(3), 'visible', 'on'); 
set(hAxis.CT(3), 'clim', [0 1]);

IIO(3).CTn = ICTn_y;
IIO(3).CBn = ICBn_y;

%% Contrast
hCC(1) = hAxis.contrast1;
hCC(2) = hAxis.contrast2;

showContrast2_MV(hFig_main, hPlotObj.CT, hCC, IIO)
set(hAxis.contrast1, 'visible', 'on')
set(get(hAxis.contrast1, 'children'), 'visible', 'on')
set(hAxis.contrast2, 'visible', 'on')
set(get(hAxis.contrast2, 'children'), 'visible', 'on')

%% on/off
% CB date table on
set(data_main.hTable.CBDate, 'Visible', 'on');

% menu on/off
set(data_main.hMenuItem.CT, 'Checked', 'off');
set(data_main.hMenuItem.CB, 'Checked', 'off');
set(data_main.hMenuItem.CTCB, 'Checked', 'on');

%% Analysis
if data_main.flag.SSLoaded
    set(data_main.hMenuItem.AnalysisZ, 'Enable', 'on');
end
updatePDF(data_main);
