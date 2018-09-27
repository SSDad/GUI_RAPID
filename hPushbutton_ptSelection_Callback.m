function hPushbutton_ptSelection_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
RadoncIDFolder = data_main.RadoncIDfromTable;

%% initialize
% main figure
% set(hFig_main, 'Name', ['RAPID_6 - ', RadoncIDFolder]);
set(hFig_main, 'WindowScrollWheelFcn', @mscb);
data_main.RadoncIDFolder = RadoncIDFolder;

idx = strfind(RadoncIDFolder, '_');
if ~isempty(idx)
     data_main.RadoncID = RadoncIDFolder(1:idx-1);
else
    data_main.RadoncID = RadoncIDFolder;
end

% table
set(data_main.hPanel.PL, 'visible', 'off');

% menu
set(data_main.hMenuItem.Patient, 'checked', 'off');

% CT    
data_main.flag.CTLoaded = false;
set(data_main.hMenuItem.CT, 'Checked', 'off', 'Enable', 'on');

% CB   
data_main.flag.CBLoaded = false;
set(data_main.hMenuItem.CB, 'Checked', 'off', 'Enable', 'on');

% CBCT   
set(data_main.hMenuItem.CTCB, 'Checked', 'off', 'Enable', 'on');

% panel
set(data_main.hPanel.View, 'visible', 'off');

% contrast bar
set(get(data_main.hAxis.contrast1, 'children'), 'visible', 'off')
set(get(data_main.hAxis.contrast2, 'children'), 'visible', 'off')
set(data_main.hMenuItem.bar, 'Checked', 'off', 'Enable', 'off');

% cross lines
set(data_main.hPlotObj.CrossLine.z(1), 'XData', [], 'YData', [], 'visible', 'off');
set(data_main.hPlotObj.CrossLine.z(2), 'XData', [], 'YData', [], 'visible', 'off');

set(data_main.hPlotObj.CrossLine.x(1), 'XData', [], 'YData', [], 'visible', 'off');
set(data_main.hPlotObj.CrossLine.x(2), 'XData', [], 'YData', [], 'visible', 'off');

set(data_main.hPlotObj.CrossLine.y(1), 'XData', [], 'YData', [], 'visible', 'off');
set(data_main.hPlotObj.CrossLine.y(2), 'YData', [], 'XData', [], 'visible', 'off');

set(data_main.hMenuItem.CrossLine, 'Enable', 'off', 'Checked', 'off')

% Text
set(data_main.hText.CT, 'String', [])
set(data_main.hText.CTcm, 'String', [])

% structure set
set(data_main.hPlotObj.SS.z, 'xdata', (nan), 'ydata', (nan));    
set(data_main.hPlotObj.SS.x, 'xdata', (nan), 'ydata', (nan));    
set(data_main.hPlotObj.SS.y, 'xdata', (nan), 'ydata', (nan));    
set(data_main.hMenuItem.bar, 'Checked', 'off', 'Enable', 'off');
set(data_main.hMenuItem.SS, 'Checked', 'off', 'Enable', 'off');
data_main.flag.SSLoaded = false;
data_main.flag.SS_SagCorLoaded = false;

%iso
set(data_main.hPlotObj.iso.z, 'xdata', (nan), 'ydata', (nan));    
set(data_main.hPlotObj.iso.x, 'xdata', (nan), 'ydata', (nan));    
set(data_main.hPlotObj.iso.y, 'xdata', (nan), 'ydata', (nan));    
set(data_main.hMenuItem.iso, 'Enable', 'off')

% CB info
set(data_main.hPanel.CBInfo, 'visible', 'off');
set(data_main.hMenuItem.CBInfo, 'Enable', 'off', 'Checked', 'off')

% analysisZ
set(data_main.hMenuItem.AnalysisZ, 'Enable', 'off', 'Checked', 'off')
set(data_main.hMenuItem.AnalysisZ_CBCT, 'Enable', 'off', 'Checked', 'off')
set(data_main.hPanel.pdf_zTime, 'visible', 'off');
set(data_main.hPanel.Stat_zTime, 'visible', 'off');

data_main.flag.statData_z = false(100, 1);

set(data_main.hPanel.CT(1), 'Position',  [0 0 0.6 1]);
set(data_main.hPanel.CT(2), 'Position',  [0.6 0.5 0.4 0.5]);
set(data_main.hPanel.CT(3), 'Position',  [0.6 0    0.4 0.5]);

% selected
data_main.selected = [];

%% ptInfo
ptInfoFN = fullfile(data_main.fd_data, RadoncIDFolder, [data_main.RadoncID, '_CTinfo.mat']);
load(ptInfoFN)
ptInfoData{1} = data_main.RadoncID;
ptInfoData{2} = dcmInfo.PatientName.FamilyName;
ptInfoData{3} = dcmInfo.PatientName.GivenName;
ptInfoData{4} = dcmInfo.PatientSex;
ptInfoData{5} = dcmInfo.PatientBirthDate;

set(data_main.hTable.ptInfo, 'Data', ptInfoData');   
set(data_main.hPanel.ptInfo, 'visible', 'on');
jScroll = findjobj(data_main.hTable.ptInfo);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);


%% save data
guidata(hFig_main, data_main);