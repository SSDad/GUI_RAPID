 function varargout = RAPID(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1
% Zhen Ji, 2016
%%%%%%%%%%%%%%%%%%%%%%%%%

global RadoncID
% RadoncID{1} = '12160126';
% RadoncID{1} = '11152222';
% RadoncID{1} = '17150044';

%% global
global hFig_RAPID
global hAxes
global hTable
global hText
global flag
global fd_data
global hPanel
global CBCBmem
global hPushbutton
global hMenuItem

CBCBmem = [];

%% folder
fd_data = fullfile(['C:\Users\', getenv('username')], 'Box Sync\RAPID\Data\Data_Processed_old');  % image data folder
% fd_data = 'D:\Box Sync\RAPID\Data\Data_Processed';  % image data folder
% fd_data = 'Z:\Varian MRA\Lung\Data\Data_Processed';

%% flag
flag.CTLoaded = false;
flag.SSLoaded = false;
flag.CBLoaded = false;
flag.CBCBcal = false;
flag.statFig = false;
flag.dcmInfoFig = false;

%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI Setup
%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Figure
SS = get(0,'screensize');  % Screen Size

% main GUI figure
hFig_RAPID = figure('MenuBar',            'none', ...
                    'Toolbar',              'none', ...
                    'HandleVisibility',  'callback', ...
                    'Name',                'RAPID_1', ...
                    'NumberTitle',      'off', ...
                    'Units',                 'normalized',...
                    'Position',             [0.05 0.1 0.9 0.75],...
                    'Color',                 'black', ...
                    'Visible',               'on');

%% toolbar                
hToolbar = uitoolbar ('parent', hFig_RAPID);
uitoolfactory(hToolbar,'Exploration.ZoomIn');
uitoolfactory(hToolbar,'Exploration.ZoomOut');
uitoolfactory(hToolbar,'Exploration.Pan');                
uitoolfactory(hToolbar,'Exploration.DataCursor');                

%% file manu       
% File
hMenu.File = uimenu('Parent',                   hFig_RAPID,...
                                'HandleVisibility',      'callback', ...
                                'Label',                     'File');
                    
hMenuItem.Patient  =   uimenu('Parent',             hMenu.File,...
                                                'Label',                'Patient',...
                                                'HandleVisibility', 'callback', ...
                                                'Callback',            @hMenuItem_Patient_Callback);

hMenuItem.Close  =  uimenu('Parent',                 hMenu.File,...
                                              'Label',                   'Close',...
                                              'Separator',            'off',...
                                              'HandleVisibility',    'callback', ...
                                              'Callback',              @hMenuItem_Close_Callback);

% View
hMenu.View = uimenu('Parent',                   hFig_RAPID,...
                                    'HandleVisibility',      'callback', ...
                                    'Label',                     'View');
                    
hMenuItem.CT  =   uimenu('Parent',               hMenu.View,...
                                            'Label',                'Planning',...
                                            'HandleVisibility', 'callback', ...
                                            'Callback',            @hMenuItem_CT_Callback);

hMenuItem.CB  =   uimenu('Parent',               hMenu.View,...
                                            'Label',                'Localization',...
                                            'HandleVisibility', 'callback', ...
                                            'Callback',            @hMenuItem_CB_Callback);

hMenuItem.CTCB  =   uimenu('Parent',               hMenu.View,...
                                                'Label',                'Pink(iCT)-Green(CB)',...
                                                'HandleVisibility', 'callback', ...
                                                'Callback',            @hMenuItem_CTCB_Callback);

hMenuItem.dcmInfo  =   uimenu('Parent',               hMenu.View,...
                                                'Label',                'DICOM Info',...
                                                'Enable',               'off', ...
                                                'HandleVisibility', 'callback', ...
                                                'Callback',            @hMenuItem_dcmInfo_Callback);

hMenu.Analysis = uimenu('Parent',                   hFig_RAPID,...
                                    'HandleVisibility',      'callback', ...
                                    'Label',                     'Analysis');
                                
hMenuItem.pdf  =   uimenu('Parent',     hMenu.Analysis,...
                                                'Label',                'Segmentation & pdf',...
                                                'HandleVisibility', 'callback', ...
                                                'Callback',            @hMenuItem_pdf_Callback);
                                            
hMenuItem.Stat  =   uimenu('Parent',            hMenu.Analysis,...
                                                'Label',                'Statistics',...
                                                'HandleVisibility', 'callback', ...
                                                'Callback',            @hMenuItem_Stat_Tab_Callback);

hMenuItem.SaveStatData  =   uimenu('Parent',            hMenu.Analysis,...
                                                'Label',                'Save Stat Data',...
                                                'HandleVisibility', 'callback', ...
                                                'Callback',            @hMenuItem_SaveStatData_Callback);
                                            
%% slice table panel
w_hPanel_sliceTable = 0.9;
h_hPanel_sliceTable = 0.15;
y_hPanel_sliceTable =1-h_hPanel_sliceTable;

hPanel.sliceTable = uipanel('Parent',                   hFig_RAPID,...
                                            'Title',                      'Slice No',...
                                            'FontSize',                12,...
                                            'TitlePosition',          'lefttop',...
                                            'Units',                     'normalized', ...
                                            'Position',                 [0 ...
                                                                            y_hPanel_sliceTable ...
                                                                            w_hPanel_sliceTable ...
                                                                            h_hPanel_sliceTable],...
                                            'ForegroundColor',      'white',...
                                            'BackgroundColor',      'black',...
                                            'BorderType',              'etchedout',...
                                            'HighlightColor',          'cyan',...
                                            'ShadowColor',           'blue',...
                                            'BorderWidth',             2);
                                        
% Slice Table        
hTable.Slice = uitable('parent',                        hPanel.sliceTable,...
                                   'Units',                          'normalized', ...
                                   'Position',                      [0 0  1 1],...
                                   'ForegroundColor',         [1 1 1],...
                                   'BackgroundColor',         [0 0 0],...
                                    'ColumnName',             [],...
                                    'ColumnFormat',           [],...
                                    'RowName',                  [],...
                                    'FontSize',                     10,....
                                    'Visible',                        'off',...
                                    'CellSelectionCallback',  @hTable_Slice_Callback);        
         
%% View panel
w_hPanel_View = w_hPanel_sliceTable;
w_contrastWin = 0.05;

hPanel.View = uipanel('Parent',                        hFig_RAPID,...    
                                    'Title',                           'View',...
                                    'FontSize',                    12,...
                                    'TitlePosition',              'centertop',...
                                    'Units',                        'normalized', ...
                                    'Position',                     [0 0 w_hPanel_View y_hPanel_sliceTable],...
                                   'ForegroundColor',       'white',...
                                   'BackgroundColor',       'black',...
                                   'BorderType',               'etchedout',...
                                   'HighlightColor',           'cyan',...
                                   'ShadowColor',            'blue',...
                                   'BorderWidth',              2);      
                       
% axes
hAxes.sliceImage = axes('Parent',                   hPanel.View, ...
                                        'Units',                    'normalized', ...
                                        'HandleVisibility',     'callback', ...
                                        'Position',                 [w_contrastWin*2 0 1-w_contrastWin*4 1]);
axis(hAxes.sliceImage, 'off')
hold(hAxes.sliceImage, 'on');

% contrast
w_contrastWin = 0.05;
hAxes.contrast1 = axes('Parent',                   hPanel.View, ...
                                    'Units',                    'normalized', ...
                                    'HandleVisibility',     'callback', ...
                                    'Position',                 [0 0 w_contrastWin 1]);

X = zeros(1, 4);
Y = X;
area(hAxes.contrast1, X, Y, ...
                                'FaceColor', [1 1 1],...
                                'Tag', 'Hist');
F = [1 2 3 4];
patch(hAxes.contrast1, 'Faces', F,...
                                  'Vertices', [X' Y'],  ...
                                  'FaceColor', 'c',...
                                  'FaceAlpha', .2,...
                                  'Tag', 'CenterPatch');

patch(hAxes.contrast1, 'Faces', F,...
                                  'Vertices', [X' Y'],  ...
                                  'FaceColor', 'c',...
                                  'FaceAlpha', 1,...
                                  'Tag', 'LeftPatch');

patch(hAxes.contrast1, 'Faces', F,...
                                  'Vertices', [X' Y'],  ...
                                  'FaceColor', 'c',...
                                  'FaceAlpha', 1,...
                                  'Tag', 'RightPatch');

% vertical
set(hAxes.contrast1,'ydir','reverse')
view(hAxes.contrast1, [-90 90])

axis(hAxes.contrast1, 'off')
set(hAxes.contrast1, 'visible', 'off')

hAxes.contrast2 = axes('Parent',                   hPanel.View, ...
                                    'Units',                    'normalized', ...
                                    'HandleVisibility',     'callback', ...
                                    'Position',                 [w_contrastWin 0 w_contrastWin 1]);
area(hAxes.contrast2, X, Y, ...
                                'FaceColor', [1 1 1],...
                                'Tag', 'Hist');
patch(hAxes.contrast2, 'Faces', F,...
                                  'Vertices', [X' Y'],  ...
                                  'FaceColor', 'g',...
                                  'FaceAlpha', .2,...
                                  'Tag', 'CenterPatch');

patch(hAxes.contrast2, 'Faces', F,...
                                  'Vertices', [X' Y'],  ...
                                  'FaceColor', 'g',...
                                  'FaceAlpha', 1,...
                                  'Tag', 'LeftPatch');

patch(hAxes.contrast2, 'Faces', F,...
                                  'Vertices', [X' Y'],  ...
                                  'FaceColor', 'g',...
                                  'FaceAlpha', 1,...
                                  'Tag', 'RightPatch');
axis(hAxes.contrast2, 'off')
set(hAxes.contrast2, 'visible', 'off')


% Label text
FS_Text = 10;

x_hText = 0.9;
w_hText = 1-x_hText;
h_hText = 0.025;
y_hText_Slice = 1-h_hText;
y_hText_Struct = 1-h_hText*2;
y_hText_CBDate = 1-h_hText*3;

hText.Slice = uicontrol('parent',       hPanel.View,...
                                    'Style',         'text',...
                                    'Units',          'normalized', ...
                                    'Position',      [x_hText...
                                                          y_hText_Slice ...
                                                          w_hText ...
                                                          h_hText],...
                                    'String',          'Slice No',...
                                     'BackgroundColor', [0 0 0],...             
                                     'ForegroundColor', 'cyan',...             
                                      'FontSize', FS_Text,...
                                      'FontWeight', 'bold',...
                                      'visible', 'off');

hText.Struct = uicontrol('parent',       hPanel.View,...
                                    'Style',         'text',...
                                    'Units',          'normalized', ...
                                    'Position',      [x_hText...
                                                          y_hText_Struct ...
                                                          w_hText ...
                                                          h_hText],...
                                    'String',          'Structure',...
                                     'BackgroundColor', [0 0 0],...             
                                     'ForegroundColor', [0 1 0],...             
                                      'FontSize', FS_Text,...
                                      'FontWeight', 'bold', ...
                                      'visible', 'off');

hText.CBDate = uicontrol('parent',       hPanel.View,...
                                    'Style',         'text',...
                                    'Units',          'normalized', ...
                                    'Position',      [x_hText...
                                                          y_hText_CBDate ...
                                                          w_hText ...
                                                          h_hText],...
                                    'String',          'CB Date',...
                                     'BackgroundColor', [0 0 0],...             
                                     'ForegroundColor', 'cyan',...             
                                      'FontSize', FS_Text,...
                                      'FontWeight', 'bold',...
                                      'visible', 'off');
                                  
hText.iso = uicontrol('parent',       hPanel.View,...
                                    'Style',         'text',...
                                    'Units',          'normalized', ...
                                    'Position',      [0 0.975 0.075 0.025],...
                                    'String',          'iso Slice',...
                                     'BackgroundColor', [0 0 0],...             
                                     'ForegroundColor', 'yellow',...             
                                      'FontWeight', 'bold',...
                                      'visible', 'off');
                                  
hPushbutton.showTumor = uicontrol('parent',                 hPanel.View,...
                                                        'Style',                    'pushbutton',...
                                                        'String',                   'Hide Tumor Segmentation',...
                                                        'Units',                    'normalized', ...
                                                        'Position',                 [0.845, 0.4, 0.15, 0.04], ...
                                                        'ForeGroundColor',   [0.2 0.4 1],...
                                                        'BackgroundColor',   [153 255 255]/255,...             
                                                        'FontSize',                10,...
                                                        'FontWeight',            'bold', ...
                                                        'Visible',                    'off',...
                                                        'Callback',             @hPushbutton_showTumor_Callback);
        
%% structList panel
h_hPanel_structList = 0.5;
hPanel.structList = uipanel(  'Parent',             hFig_RAPID,...
                                            'Title',                        'Structure',...
                                            'FontSize',                 12,...
                                             'TitlePosition',           'lefttop',...
                                            'Units',                      'normalized', ...
                                            'Position',                 [w_hPanel_View ...
                                                                             1-h_hPanel_structList  ...
                                                                             1 - w_hPanel_View ...
                                                                             h_hPanel_structList ],...
                                             'ForegroundColor',     'white',...
                                             'BackgroundColor',     'black',...
                                             'BorderType',              'etchedout',...
                                             'HighlightColor',          'cyan',...
                                             'ShadowColor',            'blue',...
                                             'BorderWidth',             2);
         
% Structture Table
ColumnName =  [];
RowName = [];

hTable.structList = uitable('parent', hPanel.structList,...
                                           'Units', 'normalized', ...
                                           'Position', [0 0 1 1],...
                                             'ForegroundColor',         [1 1 1],...
                                            'BackgroundColor',         [0 0 0],...
                                            'ColumnName',               ColumnName,...
                                            'Columnwidth',                {200},...
                                            'ColumnFormat',             {'char'},...
                                            'RowName',                     RowName,...
                                            'FontSize',                       10,....
                                            'CellSelectionCallback',    @hTable_structList_Callback);

% CB date panel
hPanel.CBDate = uipanel(  'Parent',hFig_RAPID,...
                                            'Title',                        'CB Date',...
                                            'FontSize',                 12,...
                                             'TitlePosition',           'lefttop',...
                                            'Units',                      'normalized', ...
                                            'Position',                 [w_hPanel_View ...
                                                                             0  ...
                                                                             1 - w_hPanel_View ...
                                                                             1-h_hPanel_structList ],...
                                             'ForegroundColor',     'white',...
                                             'BackgroundColor',     'black',...
                                             'BorderType',              'etchedout',...
                                             'HighlightColor',          'cyan',...
                                             'ShadowColor',            'blue',...
                                             'BorderWidth',             2);
  
% CBDate Table        
hTable.CBDate = uitable('parent',                        hPanel.CBDate,...
                                   'Units',                          'normalized', ...
                                   'Position',                      [0 0 1 1],...
                                   'ForegroundColor',         [1 1 1],...
                                   'BackgroundColor',         [0 0 0],...
                                    'ColumnName',             [],...
                                    'Columnwidth',             {100},...
                                    'ColumnFormat',           {'char'},...
                                    'RowName',                  [],...
                                    'FontSize',                     10,....
                                    'visible',                         'off',...
                                    'CellSelectionCallback',  @hTable_CBDate_Callback);
                                
function hMenuItem_Patient_Callback(hObject, eventdata)

global RadoncID
global hFig_RAPID
global hTable
global hText
global hAxes
global fd_data

% prompt = {'Please enter RadoncID:'};
% dlg_title = 'RadoncID';
% num_lines = 1;
% RadoncID = inputdlg(prompt,dlg_title,num_lines);

% folder_name = uigetdir('Z:\Varian MRA\Lung\Data\Data_Processed');
folder_name = uigetdir();

idx = find(folder_name == '\', 1, 'last');
RadoncID{1} = folder_name(idx+1:end);
fd_data = folder_name(1:idx-1);

set(hFig_RAPID, 'Name', ['RAPID_1 - ', RadoncID{1}]);
set(hTable.Slice, 'Data', []);
set(hTable.Slice, 'RowName', []);
set(hTable.structList, 'Data', []);
set(hTable.CBDate, 'Data', []);
set(hText.Slice, 'Visible', 'off');
set(hText.Struct, 'Visible', 'off');
set(hText.CBDate, 'Visible', 'off');
set(hText.iso, 'Visible', 'off');

if ishandle(hAxes.sliceImage)
    cla(hAxes.sliceImage)
end

if isfield(hAxes, 'sliceSub')
    if ishandle(hAxes.sliceSub)
        for iSub = 1:length(hAxes.sliceSub)
            cla(hAxes.sliceSub(iSub))
            title(hAxes.sliceSub(iSub), [])

            cla(hAxes.histSub(iSub))
        end
    end
end

function hMenuItem_CT_Callback(hObject, eventdata)

global RadoncID
global hFig_RAPID
global hTable
global hAxes
global CT
global hPanel
global selected
global flag
global hText
global SS
global hPushbutton

% if isfield(hAxes, 'sliceImage')
%     if ishandle(hAxes.sliceImage)
%         cla(hAxes.sliceImage)
%     end
% end
% 
% if isfield(hAxes, 'sliceSub')
%     delete(hAxes.sliceSub)
%     delete(hAxes.histSub)
% end
% 
% hAxes.sliceImage = axes('Parent',                   hPanel.View, ...
%                                     'Units',                    'normalized', ...
%                                     'HandleVisibility',     'callback', ...
%                                     'Position',                 [0 0 1 1]);
% hold(hAxes.sliceImage, 'on');

if ishandle(hAxes.sliceImage)
   cla(hAxes.sliceImage)                           
elseif ishandle(hAxes.sliceSub)
   delete(hAxes.sliceSub)
   delete(hAxes.histSub)
   hAxes.sliceImage = axes('Parent',                   hPanel.View, ...
                                        'Units',                    'normalized', ...
                                        'Position',                 [0 0 1 1]);
    hold(hAxes.sliceImage, 'on');
end

set(hPanel.View, 'Title', 'initial CT');

if ~flag.CTLoaded
    loadCT(RadoncID)
    loadSS(RadoncID)
    fillStructTable
end

set(hTable.CBDate, 'Data', [])
set(hTable.CBDate, 'Visible', 'off')

CT.Lim = [min(CT.MM(:)) max(CT.MM(:))];
CT.Lim = double(CT.Lim);

ICT = CT.MM(:,:,selected.Slice);
imshow(ICT, [CT.Lim(1) CT.Lim(2)], 'parent', hAxes.sliceImage);
hold(hAxes.sliceImage, 'on')

if selected.Slice == CT.idx_iso
    addISO2Axes(hAxes.sliceImage)
end

addContour2Axes(hAxes.sliceImage)

fillSliceTable

set(hText.iso, 'String', ['iso Slice ', num2str(CT.idx_iso)], 'visible', 'on');
set(hText.Slice, 'String', ['Slice ', num2str(selected.Slice)], 'visible', 'on')
set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')
set(hPushbutton.showTumor, 'visible', 'off')

set(get(hAxes.contrast1, 'children'), 'visible', 'on')
showContrast(hFig_RAPID, hAxes.sliceImage, hAxes.contrast1, ICT, CT.Lim);
set(get(hAxes.contrast2, 'children'), 'visible', 'off')

function addISO2Axes(hA)

global CT

dx = CT.xx(2)-CT.xx(1);
dy = CT.yy(2)-CT.yy(1);
iso.x = (CT.iso(1)-CT.xx(1))/dx;
iso.y = (CT.iso(2)-CT.yy(1))/dy;
plot(iso.x, iso.y, '+y', 'MarkerSize', 50, 'parent', hA)  % iso point

function loadCT(RadoncID)

global fd_data
global flag
global CT
global selected

ffd = fullfile(fd_data, RadoncID{1});
junk = fullfile(ffd, [RadoncID{1}, '_initialCT*']);
fn_CT = dir(junk);
ffn_CT = fullfile(ffd, fn_CT.name);
load(ffn_CT)
flag.CTLoaded = true;

selected.Slice = CT.idx_iso;

function fillSliceTable

global hTable
global tableData
global CT
global selected
global SS
global CB
global hPanel

% CT & Structure
nCTslice = size(CT.MM, 3);
tableData.Slice = cell(2, nCTslice);

for iSlice = 1:nCTslice
    tableData.Slice{1, iSlice} = ['<html><font color = white >' num2str(iSlice) '</font></html>'];
end
tableData.Slice{1, CT.idx_iso} = ['<html><font color = yellow >' num2str(CT.idx_iso) '</font></html>'];

tableData.Slice(2, :) = [];
[cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
sCLR = dec2hex(SS.contourColor{selected.idxSS});
sCLR_Char = reshape(sCLR', 1, 6);
for iS = 1:length(cont.ind)
    iSlice = cont.ind(iS);
    tableData.Slice{2, iSlice} = ['<html><font color =' sCLR_Char '>' num2str(iSlice) '</font></html>'];
end

% rowName_ST = tableData.Struct{selected.idxSS, 1}; 
rowName_ST = SS.sNames{selected.idxSS};
if strcmp(get(hPanel.View, 'Title'), 'initial CT')
    if size(tableData.Slice, 1) > 2
        tableData.Slice(3:end, :) = [];
    end
    rowName = {'CT', rowName_ST};
elseif strcmp(get(hPanel.View, 'Title'), 'Pink(iCT)-Green(CB)')  || strcmp(get(hPanel.View, 'Title'), 'Localization')
    n1 = CB.ind{selected.idxDate}(1);
    n2 = CB.ind{selected.idxDate}(end);

    % table
    for iSlice = n1:n2
        tableData.Slice{3, iSlice} = ['<html><font color = white >' num2str(iSlice) '</font></html>'];
    end
    tableData.Slice{3, CT.idx_iso} = ['<html><font color = yellow >' num2str(CT.idx_iso) '</font></html>'];
    rowName = {'CT', rowName_ST, ['CB-', CB.dateCreated(selected.idxDate, :)]};
elseif strcmp(get(hPanel.View, 'Title'), 'Slice on CB1')
    
    rowName{2} = rowName_ST;
    
    for iDate = 1:min(CB.nCB-selected.idxDate+1, CB.nSub)
%     for iDate = 1:CB.nSub
        sDate = selected.idxDate+iDate-1;
        n1 = CB.ind{sDate}(1);
        n2 = CB.ind{sDate}(end);

        % table
        for iSlice = n1:n2
            tableData.Slice{2+iDate, iSlice} = ['<html><font color = white >' num2str(iSlice) '</font></html>'];
        end
        tableData.Slice{2+iDate, CT.idx_iso} = ['<html><font color = yellow >' num2str(CT.idx_iso) '</font></html>'];
        rowName{2+iDate} = ['CB-', CB.dateCreated(sDate, :)];
    end
end

rowName{1} = ['CT-', CT.dateCreated];

set(hTable.Slice, 'Data',           tableData.Slice, ...
                       'RowName',     rowName, ...
                       'Visible',         'on');
set(hTable.Slice, 'columnwidth', {25});

function loadSS(RadoncID)

global fd_data
global SS
global flag
global selected

ffd = fullfile(fd_data, RadoncID{1});
junk = fullfile(ffd, [RadoncID{1}, '_SS.mat']);
fn_SS = dir(junk);
ffn_SS = fullfile(ffd, fn_SS.name);
load(ffn_SS)
flag.SSLoaded = true;

SS.contourColor = contourColor;
SS.sNames = sNames;
SS.structures = structures;

selected.idxSS = 1;
for j = 1:length(SS.sNames)
    if strcmp('PTV', SS.sNames{j}(1:3))
        selected.idxSS = j;
        break
    end
end

function fillStructTable

global SS
global hTable
global tableData

nS = length(SS.structures);
tableData.Struct = cell(nS, 1);
for iS = 1:nS
    sCLR = dec2hex(SS.contourColor{iS});
    sCLR_Char = reshape(sCLR', 1, 6);
    tableData.Struct{iS, 1} = ['<html><font color =' sCLR_Char '>' SS.sNames{iS} '</font></html>'];
end

set(hTable.structList, 'Data',      tableData.Struct, ...
                                 'Visible',   'on');
                             
function addContour2Axes(hA)

global SS
global CT
global selected
global hObj
global hText

[cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
contData = cont.data;

if selected.Slice <= cont.ind(1) && selected.Slice >= cont.ind(end)

    dx = CT.xx(2)-CT.xx(1);
    dy = CT.yy(2)-CT.yy(1);
    xx = [];
    yy = [];
    for iS = 1:length(contData{selected.Slice})
        points = contData{selected.Slice}(iS).points;
        x = points(:,1);
        y = points(:,2);

        % shift and scale
        x = x-CT.xx(1); x = x/dx;
        y = y-CT.yy(1); y = y/dy;
        xx = [xx;x]; 
        yy = [yy;y];
    end
    hObj.Contour = plot(xx, yy, '.', 'color', SS.contourColor{selected.idxSS}/255, 'parent', hA);
    
    set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')

end

function hMenuItem_CB_Callback(hObject, eventdata)

global hFig_RAPID
global fd_data
global RadoncID
global hText
global flag
global CB
global CT
global hAxes
global hPanel
global selected
global SS
global hPushbutton

set(hPanel.View, 'Title', 'Localization')

ffd = fullfile(fd_data, RadoncID{1});

if ~flag.CBLoaded
    loadCB(RadoncID)
end

if ~flag.CTLoaded
    loadCT(RadoncID);
    loadSS(RadoncID)
    fillStructTable
end

if ishandle(hAxes.sliceImage)
   cla(hAxes.sliceImage)                           
elseif ishandle(hAxes.sliceSub)
   delete(hAxes.sliceSub)
   delete(hAxes.histSub)
   hAxes.sliceImage = axes('Parent',                   hPanel.View, ...
                                        'Units',                    'normalized', ...
                                        'Position',                 [0 0 1 1]);
    hold(hAxes.sliceImage, 'on');
end

CB.Lim = [min(CB.minI) max(CB.maxI)]; CB.Lim = double(CB.Lim);

% selected.Slice = CT.idx_iso;
selected.idxDate = 1;
ICB = CB.MMI(:,:,selected.Slice, selected.idxDate);
imshow(ICB, [CB.Lim(1) CB.Lim(2)], 'parent', hAxes.sliceImage);
addContour2Axes(hAxes.sliceImage)

if selected.Slice == CT.idx_iso
    addISO2Axes(hAxes.sliceImage);
end

fillSliceTable
fillCBDateTable
set(hText.Slice, 'String', ['Slice ', num2str(selected.Slice)], 'visible', 'on')
set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')
set(hText.CBDate, 'String', CB.dateCreated(selected.idxDate, :), 'visible', 'on')
set(hPushbutton.showTumor, 'visible', 'off')

set(get(hAxes.contrast1, 'children'), 'visible', 'on')
showContrast(hFig_RAPID, hAxes.sliceImage, hAxes.contrast1, ICB, CB.Lim);
set(get(hAxes.contrast2, 'children'), 'visible', 'off')

function hMenuItem_CTCB_Callback(hObject, eventdata)

global hFig_RAPID
global fd_data
global RadoncID
global hText
global flag
global CB
global CT
global hAxes
global hPanel
global selected
global SS
global hPushbutton
global hI

set(hPanel.View, 'Title', 'Pink(iCT)-Green(CB)')

ffd = fullfile(fd_data, RadoncID{1});

if ~flag.CBLoaded
    loadCB(RadoncID)
end

if ~flag.CTLoaded
    loadCT(RadoncID);
    loadSS(RadoncID)
    fillStructTable
end

if ishandle(hAxes.sliceImage)
   cla(hAxes.sliceImage)                           
elseif ishandle(hAxes.sliceSub)
   delete(hAxes.sliceSub)
   delete(hAxes.histSub)
   hAxes.sliceImage = axes('Parent',                   hPanel.View, ...
                                        'Units',                    'normalized', ...
                                        'Position',                 [0 0 1 1]);
    hold(hAxes.sliceImage, 'on');
end

% selected.Slice = CT.idx_iso;
selected.idxDate = 1;
ICB = CB.MMI(:,:,selected.Slice, selected.idxDate);
ICT = CT.MM(:,:,selected.Slice);

ICBn = mat2gray(ICB);
ICTn = mat2gray(ICT);
CB.Lim = [min(CB.minI) max(CB.maxI)]; CB.Lim = double(CB.Lim);
hI.pair = imshowpair(ICBn, ICTn, 'parent', hAxes.sliceImage);
set(hI.pair, 'userdata', [CT.Lim CB.Lim]);

set(get(hAxes.contrast2, 'children'), 'visible', 'on')

hCC(1) = hAxes.contrast1;
hCC(2) = hAxes.contrast2;
II{1} = ICT;
II{2} = ICB;
Lim{1} = CT.Lim;
Lim{2} = CB.Lim;
showContrast2(hFig_RAPID, hI.pair, hCC, II, Lim)

addContour2Axes(hAxes.sliceImage)

if selected.Slice == CT.idx_iso
    addISO2Axes(hAxes.sliceImage);
end

fillCBDateTable
set(hText.Slice, 'String', ['Slice ', num2str(selected.Slice)], 'visible', 'on')
set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')
set(hText.CBDate, 'String', CB.dateCreated(selected.idxDate, :), 'visible', 'on')
set(hPushbutton.showTumor, 'visible', 'off')

function loadCB(RadoncID)
global fd_data
global flag
global CB
global hMenuItem

ffd = fullfile(fd_data, RadoncID{1});
junk = fullfile(ffd, [RadoncID{1}, '_allCB*']);
fn_CB = dir(junk);
ffn_CB = fullfile(ffd, fn_CB.name);
load (ffn_CB)
CB.nCB = size(CB.dateCreated, 1);
flag.CBLoaded = true;

set(hMenuItem.dcmInfo, 'Enable', 'on');

function fillCBDateTable
global CB
global tableData
global hTable

tableData.CBDate = cell(CB.nCB, 1);
set(hTable.CBDate, 'Data', tableData.CBDate, 'Visible', 'on');
for iD = 1:size(CB.dateCreated, 1)
    tableData.CBDate{iD, 1} = CB.dateCreated(iD, :);
end
set(hTable.CBDate, 'Data', tableData.CBDate);
                              
function hMenuItem_Close_Callback(hObject, eventdata)
global hFig_RAPID
selection = questdlg(['Close ' get(hFig_RAPID,'Name') '?'],...
                                ['Close ' get(hFig_RAPID,'Name') '...'],...
                                 'Yes', 'No', 'Yes');
if strcmp(selection, 'No')
    return;
else
    delete(hFig_RAPID);
end

function hTable_Slice_Callback(hObject, eventdata)

global hFig_RAPID
global CT
global CB
global hAxes
global selected
global hPanel
global SS
global hText
global CBCB
global dateLabel
global dataColor
global flag
global hI

idcs = eventdata.Indices;

if numel(idcs)
    selected.Slice = idcs(2);
    if strcmp(get(hPanel.View, 'Title'), 'initial CT')
        cla(hAxes.sliceImage);
        
        ICT = CT.MM(:,:,selected.Slice);
        
        [clim1, clim2] = findPatchLimit(hAxes.contrast1);
        imshow(ICT, [clim1 clim2], 'parent', hAxes.sliceImage);
        addContour2Axes(hAxes.sliceImage)
        if selected.Slice == CT.idx_iso
            addISO2Axes(hAxes.sliceImage);
        end

        showContrast(hFig_RAPID, hAxes.sliceImage, hAxes.contrast1, ICT, CT.Lim);

    elseif strcmp(get(hPanel.View, 'Title'), 'Pink(iCT)-Green(CB)')  || strcmp(get(hPanel.View, 'Title'), 'Localization')

        ICB = CB.MMI(:,:,selected.Slice,selected.idxDate);
        
        if strcmp(get(hPanel.View, 'Title'), 'Pink(iCT)-Green(CB)')
            CLimAll = get(hI.pair, 'userdata');
            cla(hAxes.sliceImage);
            ICT = CT.MM(:,:,selected.Slice);
            if any(ICB(:))
                
                ICBn = mat2gray(ICB, CLimAll(3:4));
                ICTn = mat2gray(ICT, CLimAll(1:2));
                hI.pair = imshowpair(ICBn, ICTn, 'parent', hAxes.sliceImage);
                set(hI.pair, 'userdata', CLimAll);
                
                hCC(1) = hAxes.contrast1;
                hCC(2) = hAxes.contrast2;
                II{1} = ICT;
                II{2} = ICB;
                Lim{1} = CT.Lim;
                Lim{2} = CB.Lim;
                showContrast2(hFig_RAPID, hI.pair, hCC, II, Lim)

            else
                imshow(ICT, [], 'parent', hAxes.sliceImage);
            end
        else
%             cla(hAxes.sliceImage);
            [clim1, clim2] = findPatchLimit(hAxes.contrast1);
            imshow(ICB, [clim1 clim2], 'parent', hAxes.sliceImage);
            showContrast(hFig_RAPID, hAxes.sliceImage, hAxes.contrast1, ICB, CB.Lim);
        end
            
        addContour2Axes(hAxes.sliceImage)

        if selected.Slice == CT.idx_iso
            addISO2Axes(hAxes.sliceImage);
        end

    elseif strcmp(get(hPanel.View, 'Title'), 'Slice on CB1')
        addSubs2Axes(CT, CB, SS, selected, hAxes, CB.nSub)
    end
    
    set(hText.Slice, 'String', ['Slice ', num2str(selected.Slice)], 'visible', 'on')
    
    flag.statFig = isStatFigOpen;
    if flag.statFig
        addStat2Axes_Tab(selected, CBCB, hAxes, dataColor, dateLabel, CB.nSub)                
    end
    
end

function hTable_CBDate_Callback(hObject, eventdata)

global hFig_RAPID
global CB
global CT
global hText
global selected
global hAxes
global hPanel
global SS
global CBCB
global dateLabel
global flag
global dataColor
global hI

idcs = eventdata.Indices;
if numel(idcs)
    selected.idxDate = idcs(1);
    if strcmp(get(hPanel.View, 'Title'), 'Pink(iCT)-Green(CB)') || strcmp(get(hPanel.View, 'Title'), 'Localization')
        ICB = CB.MMI(:,:,selected.Slice,selected.idxDate);
        if strcmp(get(hPanel.View, 'Title'), 'Pink(iCT)-Green(CB)')
            CLimAll = get(hI.pair, 'userdata');
            cla(hAxes.sliceImage);
            ICT = CT.MM(:,:,selected.Slice);
            
            ICBn = mat2gray(ICB, CLimAll(3:4));
            ICTn = mat2gray(ICT, CLimAll(1:2));
            hI.pair = imshowpair(ICBn, ICTn, 'parent', hAxes.sliceImage);
            set(hI.pair, 'userdata', CLimAll);

            hCC(1) = hAxes.contrast1;
            hCC(2) = hAxes.contrast2;
            II{1} = ICT;
            II{2} = ICB;
            Lim{1} = CT.Lim;
            Lim{2} = CB.Lim;
            showContrast2(hFig_RAPID, hI.pair, hCC, II, Lim)
        else
            cla(hAxes.sliceImage);
            [clim1, clim2] = findPatchLimit(hAxes.contrast1);
            imshow(ICB, [clim1 clim2], 'parent', hAxes.sliceImage);
            showContrast(hFig_RAPID, hAxes.sliceImage, hAxes.contrast1, ICB, CB.Lim);
        end
        addContour2Axes(hAxes.sliceImage)

        if selected.Slice == CT.idx_iso
            addISO2Axes(hAxes.sliceImage);
        end

        set(hText.CBDate, 'String', CB.dateCreated(selected.idxDate, :), 'visible', 'on')
    elseif strcmp(get(hPanel.View, 'Title'), 'Slice on CB1')
        addSubs2Axes(CT, CB, SS, selected, hAxes, CB.nSub)
    end
    fillSliceTable
    set(hText.Slice,'visible', 'on')
    set(hText.Struct,'visible', 'on')

    flag.statFig = isStatFigOpen;
    if flag.statFig
        addStat2Axes_Tab(selected, CBCB, hAxes, dataColor, dateLabel, CB.nSub)                
    end

end

function hTable_structList_Callback(hObject, eventdata)
global hAxes
global hObj
global hText
global flag
global CT
global selected
global SS
global hPanel
global CB

idcs = eventdata.Indices;
if ~isempty(idcs)
    selected.idxSS = idcs(1);
    if strcmp(get(hPanel.View, 'Title'), 'initial CT') ||...
            strcmp(get(hPanel.View, 'Title'), 'Pink(iCT)-Green(CB)') || ...
            strcmp(get(hPanel.View, 'Title'), 'Localization')

        delete(hObj.Contour)
        addContour2Axes(hAxes.sliceImage)
    end
    
    if strcmp(get(hPanel.View, 'Title'), 'Slice on CB1')
        addSubs2Axes(CT, CB, SS, selected, hAxes, CB.nSub)
    end
    fillSliceTable
    set(hText.Struct, 'String', SS.sNames{selected.idxSS}, 'ForegroundColor', SS.contourColor{selected.idxSS}/255,  'visible', 'on')

    flag.statFig = isStatFigOpen;
    if flag.statFig
            close('Statistics Analysis')
    end

end 

function hMenuItem_pdf_Callback(hObject, eventdata)
global CT
global SS
global CB
global hAxes
global selected
global hPanel
global hText
global hPushbutton

set(hPanel.View, 'Title', 'Slice on CB1');
set(hText.CBDate, 'visible', 'off')
delete(hAxes.sliceImage)

CB.nSub = min(4, CB.nCB);

selected.idxDate = 1;
fillSliceTable
fillCBDateTable

ySub = 0.4;
hSub = 0.5;
for iSub = 1:CB.nSub
    xSub = (iSub-1)/CB.nSub;
    wSub = 1/CB.nSub;
    
    hAxes.sliceSub(iSub) = axes(   'parent',    hPanel.View, ...
                                                'Units',      'normalized', ...
                                                'Position',   [xSub ySub wSub hSub]);
    hAxes.histSub(iSub) = axes(   'parent',    hPanel.View, ...
                                                'Units',      'normalized', ...
                                                'Position',   [xSub 0 wSub ySub-0.05]);
end
set(hPushbutton.showTumor, 'visible', 'on')
addSubs2Axes(CT, CB, SS, selected, hAxes, CB.nSub);

set(get(hAxes.contrast1, 'children'), 'visible', 'off')
set(get(hAxes.contrast2, 'children'), 'visible', 'off')

function addSubs2Axes(CT, CB, SS, selected, hAxes, nSub)
global hPlot
global hPushbutton

nSub = min(nSub, CB.nCB-selected.idxDate+1);

for iSub = 1:CB.nSub
    cla(hAxes.sliceSub(iSub))
    title(hAxes.sliceSub(iSub), [])

    cla(hAxes.histSub(iSub))
end

[cont] = fun_getContour(selected.idxSS, SS.structures, SS.sNames, CT.zz);
if selected.Slice <= cont.ind(1) && selected.Slice >= cont.ind(end)

    [subImg, subPDF, iso] = fun_getPDF(CT, CB, SS, selected, nSub);

    if ~isempty(subImg)
        I1 = subImg.CB1;

        for iSub = 1:nSub
            I2 = subImg.CB(:,:,iSub);
            II = imfuse(I2, I1);
            imshow(II, 'parent', hAxes.sliceSub(iSub))
            hold(hAxes.sliceSub(iSub), 'on')
            plot(subImg.contCB.x, subImg.contCB.y, '.', 'color', SS.contourColor{selected.idxSS}/255,...
                'parent', hAxes.sliceSub(iSub))

            if selected.Slice == CT.idx_iso
                plot(iso.x, iso.y, '+y', 'MarkerSize', 50, 'parent', hAxes.sliceSub(iSub))  % iso point
            end
            
            % tumor
            if ~isempty(subImg.tumor{iSub})
            if ~isempty(subImg.tumor{iSub}.points) && ~isempty(subImg.tumor1.points)
                hPlot.Tumor(iSub) = plot(hAxes.sliceSub(iSub),...
                                subImg.tumor{iSub}.points(:, 2), subImg.tumor{iSub}.points(:, 1), 'g', ...
                                'visible', 'off');
                hPlot.Tumor1(iSub) = plot(hAxes.sliceSub(iSub),...
                                subImg.tumor1.points(:, 2), subImg.tumor1.points(:, 1), 'm', ...
                                'visible', 'off');

                currentString = get(hPushbutton.showTumor, 'String');
                if strcmp(currentString, 'Hide Tumor Segmentation')
                    set(hPlot.Tumor(iSub), 'visible', 'on')
                    set(hPlot.Tumor1(iSub), 'visible', 'on')
                end
            end
            end
%             else
%                 for n = 1:length(hPlot.Tumor)
%                     set(hPlot.Tumor(n), 'visible', 'on')
%                 end
%                 set(hPlot.Tumor1, 'visible', 'off')
%             end

            axis(hAxes.sliceSub(iSub), 'image')
            TTL{1} = ['\color{green}', subImg.Date{iSub}];
            TTL{2} = ['\color{green}', subImg.machineName{iSub}];
            hTT = title(hAxes.sliceSub(iSub),TTL);
%             set(hTT, 'interpreter', 'none');
        %     jk = SS.contourColor{selected.idxSS}'/255;
        %     rgbC = [num2str(jk(1)), ' ', num2str(jk(2)), ' ', num2str(jk(3))];
        %     SName = SS.sNames{selected.idxSS};
        %     SName(SName == '_') = [];
        %     title(hAxes.sliceSub(iSub),...
        %             ['\color{green}', subImg.Date{iSub}, ...
        %             '\color{cyan}', '  S-', num2str(selected.Slice), ...
        %             '  \color[rgb]{', rgbC, '}', SName]);

            hold(hAxes.histSub(iSub), 'on');
            plot(subPDF.CB.x{iSub}, subPDF.CB.y{iSub}, 'g', 'parent', hAxes.histSub(iSub), 'linewidth', 2);
            plot(subPDF.CB1.x, subPDF.CB1.y, 'm', 'parent', hAxes.histSub(iSub), 'linewidth', 2);
            set(gca, 'YLim', [0 subPDF.ymax*1.1])

            set(hAxes.histSub(iSub), 'xlim', [0 1]);
            axis(hAxes.histSub(iSub), 'off');
        end
    end
end

function hPushbutton_showTumor_Callback(hObject, eventdata)
global hPushbutton
global hPlot

currentString = get(hObject, 'String');
if strcmp(currentString, 'Show Tumor Segmentation')
    for n = 1:length(hPlot.Tumor)
        set(hPlot.Tumor(n), 'visible', 'on')
        set(hPlot.Tumor1(n), 'visible', 'on')
    end
    set(hPushbutton.showTumor, 'String', 'Hide Tumor Segmentation')
else
    for n = 1:length(hPlot.Tumor)
        set(hPlot.Tumor(n), 'visible', 'off')
        set(hPlot.Tumor1(n), 'visible', 'off')
    end
    set(hPushbutton.showTumor, 'String', 'Show Tumor Segmentation')
end

function [clim1, clim2] = findPatchLimit(hA)
ch = get(hA, 'children');
for n = 1:length(ch)
    if strcmp(get(ch(n), 'Tag'), 'CenterPatch')
        xdata = get(ch(n), 'xdata');
        clim1 = xdata(1);
        clim2 = xdata(2);
        break
    end
end

function hMenuItem_SaveStatData_Callback(hObject, eventdata)
saveStatData;