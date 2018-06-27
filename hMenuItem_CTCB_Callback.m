function hMenuItem_CTCB_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

CT = data_main.CT;
selected = data_main.selected;
hPlotObj = data_main.hPlotObj;
hAxis = data_main.hAxis;

if ~data_main.flag.CBLoaded
    [CB] = loadCB(hFig_main);
    data_main.flag.CBLoaded = true;
    set(data_main.hMenuItem.dcmInfo, 'Enable', 'on');
    selected.idxDate = 1;
    % save data
    data_main.selected = selected;
    data_main.CB = CB;
    guidata(hFig_main, data_main);
else
    CB = data_main.CB;
end

% CB.Lim = [min(CB.minI) max(CB.maxI)]; CB.Lim = double(CB.Lim);
% CBLim = [data_main.CB.minI(selected.idxDate) data_main.CB.maxI(selected.idxDate)];
% CBLim = double(CBLim);

% Axial
ICB_z = CB.MMI(:,:,selected.iSlice.z, selected.idxDate);
ICBn_z = mat2gray(ICB_z, [double(CB.minI(selected.idxDate)) double(CB.maxI(selected.idxDate))]);
% ICBn_z = CB.MMIn(:,:,selected.iSlice.z, selected.idxDate);

ICT_z = CT.MM(:,:,selected.iSlice.z);
ICTn_z = mat2gray(ICT_z, CT.Lim);
% ICTn_z = CT.MMn(:,:,selected.iSlice.z);

% ICBn_z = mat2gray(ICB_z, CBLim); %normalize
% ICTn_z = mat2gray(ICT_z, data_main.CT.Lim);

III_z(:,:,1) = ICTn_z;
III_z(:,:,2) = ICBn_z;
III_z(:,:,3) = ICTn_z;
set(hPlotObj.CT(1), 'CData', III_z); 
set(hPlotObj.CT(1), 'visible', 'on'); 

set(hPlotObj.CT(1), 'userdata', [0 1 0 1]);
set(hAxis.CT(1), 'clim', [0 1]);


% II{1} = ICTn_z;
% II{2} = ICBn_z;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


IIO(1).CTn = ICTn_z;
IIO(1).CBn = ICBn_z;

% set(hText.Slice, 'String', ['Slice ', num2str(selected.iSlice.z)], 'visible', 'on')
% set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')
% set(hText.CBDate, 'String', CB.dateCreated(selected.idxDate, :), 'visible', 'on')
% set(hPushbutton.showTumor, 'visible', 'off')

%Sagittal
ICB_x = rot90(squeeze(CB.MMI(:, selected.iSlice.x, :, selected.idxDate)));
ICBn_x = mat2gray(ICB_x, [double(CB.minI(selected.idxDate)) double(CB.maxI(selected.idxDate))]);

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
ICB_y = rot90(squeeze(CB.MMI(selected.iSlice.y, :, :, selected.idxDate)));
ICBn_y = mat2gray(ICB_y, [double(CB.minI(selected.idxDate)) double(CB.maxI(selected.idxDate))]);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contrast
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hCC(1) = hAxis.contrast1;
hCC(2) = hAxis.contrast2;

showContrast2_MV(hFig_main, hPlotObj.CT, hCC, IIO)
set(hAxis.contrast1, 'visible', 'on')
set(get(hAxis.contrast1, 'children'), 'visible', 'on')
set(hAxis.contrast2, 'visible', 'on')
set(get(hAxis.contrast2, 'children'), 'visible', 'on')

% CB date table on
set(data_main.hTable.CBDate, 'Visible', 'on');

% menu on/off
set(data_main.hMenuItem.CT, 'Checked', 'off');
set(data_main.hMenuItem.CB, 'Checked', 'off');
set(data_main.hMenuItem.CTCB, 'Checked', 'on');
