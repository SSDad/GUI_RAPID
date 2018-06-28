function varargout = RAPID(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%
% RAPID GUI redesign v5
% v2 - 3-cut view
% v3 - contours on sagittal and coronal
% v4 - Save and load daily CBCT seperately (memory reduction)
% v5 - Add analysis
%
% Zhen Ji
% Feb. 2018 
%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(fullfile(fileparts(pwd), 'fun'));   

%% main window
hFig_main = figure('MenuBar',            'none', ...
                    'Toolbar',              'none', ...
                    'HandleVisibility',  'callback', ...
                    'Name',                'RAPID_5', ...
                    'NumberTitle',      'off', ...
                    'Units',                 'normalized',...
                    'Position',             [0.1 0.1 0.8 0.8],...
                    'Color',                 'black', ...
                    'Visible',               'on', ...
                    'WindowScrollWheelFcn', @mscb);
                
[hToolbar] = addToolbar(hFig_main);
data_main.hToolbar = hToolbar;
[hMenu, hMenuItem] = addManu(hFig_main);
data_main.hMenu = hMenu;
data_main.hMenuItem = hMenuItem;
[hPanel, hTable, hPushbutton, hAxis, hPlotObj, hText, Param] = addPanel(hFig_main);
data_main.hPanel = hPanel;
data_main.hTable = hTable;
data_main.hPushbutton = hPushbutton;
data_main.hAxis = hAxis;
data_main.hPlotObj = hPlotObj;
data_main.hText = hText;
data_main.Param = Param;
data_main.hFig_main = hFig_main;

guidata(hFig_main, data_main);