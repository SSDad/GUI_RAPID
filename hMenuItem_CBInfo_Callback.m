function hMenuItem_CBInfo_Callback(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);
CBinfo = data_main.CBinfo;

if strcmp(get(data_main.hMenuItem.CBInfo, 'checked'), 'off')
    if data_main.flag.CBInfoTableFilled
        set(data_main.hPanel.CBInfo, 'visible', 'on');
        set(data_main.hMenuItem.CBInfo, 'checked', 'on');
    else
        % dcmInfo Table
        data_main.hTable.CBInfo = uitable('parent',          data_main.hPanel.CBInfo,...
                                       'Units',                          'normalized', ...
                                       'Position',                      [0 0  1 1],...
                                       'ForegroundColor',         [1 1 1],...
                                       'BackgroundColor',         [0 0 0],...
                                        'ColumnName',             [],...
                                        'ColumnFormat',           [],...
                                        'RowName',                  [],...
                                        'FontSize',                     10,....
                                        'Visible',                        'on');


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

        tableData.dcmInfo = cell(length(CBinfo), 14);

        for iDate = 1:length(CBinfo)
            tableData.dcmInfo{iDate, 1} = ['<html><font color = white >' CBinfo(iDate).date '</font></html>'];
            tableData.dcmInfo{iDate, 2} = ['<html><font color = white >' CBinfo(iDate).dcmInfo.StationName '</font></html>'];
            tableData.dcmInfo{iDate, 3} = ['<html><font color = white >' CBinfo(iDate).dcmInfo.ManufacturerModelName '</font></html>'];
            tableData.dcmInfo{iDate, 4} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.SliceThickness) '</font></html>'];
            tableData.dcmInfo{iDate, 5} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.KVP) '</font></html>'];
            tableData.dcmInfo{iDate, 6} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.DataCollectionDiameter) '</font></html>'];
            tableData.dcmInfo{iDate, 7} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.ReconstructionDiameter) '</font></html>'];
            tableData.dcmInfo{iDate, 8} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.DistanceSourceToDetector) '</font></html>'];
            tableData.dcmInfo{iDate, 9} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.DistanceSourceToPatient) '</font></html>'];
            tableData.dcmInfo{iDate, 10} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.ExposureTime) '</font></html>'];
            tableData.dcmInfo{iDate, 11} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.XrayTubeCurrent) '</font></html>'];
            tableData.dcmInfo{iDate, 12} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.Exposure) '</font></html>'];

            if isfield(CBinfo(iDate).dcmInfo, 'FilterType')
                tableData.dcmInfo{iDate, 13} = ['<html><font color = white >' CBinfo(iDate).dcmInfo.FilterType '</font></html>'];
            end

            tableData.dcmInfo{iDate, 14} = ['<html><font color = white >' num2str(CBinfo(iDate).dcmInfo.FocalSpot) '</font></html>'];
        end

        set(data_main.hTable.CBInfo, 'Data',      tableData.dcmInfo, ...
                                          'ColumnName',   columnName);

        data_main.flag.CBInfoTableFilled = true;     
        set(data_main.hMenuItem.CBInfo, 'checked', 'on');
        set(data_main.hPanel.CBInfo, 'visible', 'on');
        
        jScroll = findjobj(data_main.hTable.CBInfo);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

    end
else
    set(data_main.hMenuItem.CBInfo, 'checked', 'off');
    set(data_main.hPanel.CBInfo, 'visible', 'off');
end

guidata(hFig_main, data_main);