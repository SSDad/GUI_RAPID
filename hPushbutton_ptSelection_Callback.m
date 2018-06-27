function hPushbutton_ptSelection_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
RadoncIDFolder = data_main.RadoncIDfromTable;

%% initialize
% main figure
set(hFig_main, 'Name', ['RAPID_3 - ', RadoncIDFolder]);
set(hFig_main, 'WindowScrollWheelFcn', @mscb);
data_main.RadoncIDFolder = RadoncIDFolder;

idx = strfind(RadoncIDFolder, '_');
if ~isempty(idx)
     data_main.RadoncID = RadoncIDFolder(1:idx-1);
else
    data_main.RadoncID = RadoncIDFolder;
end

% table
set(data_main.hTable.PL, 'visible', 'off');
set(data_main.hTable.ptInfo, 'visible', 'on');
set(data_main.hPushbutton.ptSelection, 'visible', 'off');

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

% selected
data_main.selected = [];
% selected.Image = [];
% selected.Axis = [];
% selected.Panel = [];

% save data
guidata(hFig_main, data_main);