function hMenuItem_dcmInfo_Callback(hObject, eventdata)
global CT
global CB
global flag

flag.dcmInfoFig = isdcmInfoFigOpen;
if ~flag.dcmInfoFig
    % figure
    hFig_dcmInfo = figure('MenuBar',            'none', ...
                        'Toolbar',              'none', ...
                        'HandleVisibility',  'callback', ...
                        'Name',                'DICOM Info', ...
                        'NumberTitle',      'off', ...
                        'Units',                 'normalized',...
                        'Position',             [0.25 0.25 0.5 0.5],...
                        'Color',                 'black', ...
                        'Visible',               'on');
                    
    % dcmInfo Table
    hTable.dcmInfo = uitable('parent',                 hFig_dcmInfo,...
                                   'Units',                          'normalized', ...
                                   'Position',                      [0 0  1 1],...
                                   'ForegroundColor',         [1 1 1],...
                                   'BackgroundColor',         [0 0 0],...
                                    'ColumnName',             [],...
                                    'ColumnFormat',           [],...
                                    'RowName',                  [],...
                                    'FontSize',                     10,....
                                    'Visible',                        'on');
    
    flag.dcmInfotFig = true;
    
    columnName{1} = 'CB Date';
    columnName{2} = 'StationName';
    columnName{3} = 'ManufacturerModelName';
    columnName{4} = 'SliceThickness';
    columnName{5} = 'KVP';
    columnName{6} = 'DataCollectionDiameter';
columnName{7} = 'ReconstructionDiameter';
columnName{9} = 'DistanceSourceToDetector';
columnName{9} = 'DistanceSourceToPatient';
columnName{10} = 'ExposureTime';
columnName{11} = 'XrayTubeCurrent';
columnName{12} = 'Exposure';
columnName{13} = 'FilterType';
columnName{14} = 'FocalSpot';

    tableData.dcmInfo = cell(size(CB.dateCreated, 1), 14);
    for iDate = 1:size(CB.dateCreated, 1)
        tableData.dcmInfo{iDate, 1} = ['<html><font color = white >' CB.dateCreated(iDate, :) '</font></html>'];
        tableData.dcmInfo{iDate, 2} = ['<html><font color = white >' CB.dcmInfo{iDate}.StationName '</font></html>'];
        tableData.dcmInfo{iDate, 3} = ['<html><font color = white >' CB.dcmInfo{iDate}.ManufacturerModelName '</font></html>'];
        tableData.dcmInfo{iDate, 4} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.SliceThickness) '</font></html>'];
        tableData.dcmInfo{iDate, 5} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.KVP) '</font></html>'];
                tableData.dcmInfo{iDate, 6} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.DataCollectionDiameter) '</font></html>'];
tableData.dcmInfo{iDate, 7} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.ReconstructionDiameter) '</font></html>'];
        tableData.dcmInfo{iDate, 8} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.DistanceSourceToDetector) '</font></html>'];
        tableData.dcmInfo{iDate, 9} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.DistanceSourceToPatient) '</font></html>'];
        tableData.dcmInfo{iDate, 10} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.ExposureTime) '</font></html>'];
        tableData.dcmInfo{iDate, 11} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.XrayTubeCurrent) '</font></html>'];
        tableData.dcmInfo{iDate, 12} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.Exposure) '</font></html>'];
        
        if isfield(CB.dcmInfo{iDate}, 'FilterType')
            tableData.dcmInfo{iDate, 13} = ['<html><font color = white >' CB.dcmInfo{iDate}.FilterType '</font></html>'];
        end
        
        tableData.dcmInfo{iDate, 14} = ['<html><font color = white >' num2str(CB.dcmInfo{iDate}.FocalSpot) '</font></html>'];
    end
    set(hTable.dcmInfo, 'Data',      tableData.dcmInfo, ...
                                  'ColumnName',   columnName);
    
end