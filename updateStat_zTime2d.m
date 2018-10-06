function updateStat_zTime2d(data_main)

hFig_main = data_main.hFig_main;
selected = data_main.selected;
statFileName = fullfile(data_main.fd_data, data_main.RadoncIDFolder,...
                                [data_main.RadoncID, '_StatData_', num2str(selected.idxSS), '.mat']);
hAxis = data_main.hAxis;

if ~data_main.flag.statData_z(selected.idxSS)
    for iT = 1:6
        set(data_main.hPlotObj.Stat_zTime2d(iT), 'xdata', [], 'ydata', []);
        set(data_main.hPlotObj.StatSub_zTime2d(iT), 'xdata', [], 'ydata', []);
    end

    if exist(statFileName, 'file')
        load(statFileName);
    else
        jhOn = false;
        if strcmp(data_main.hMenuItem.jhZ.Checked, 'on')
            jhOn = true;
        end        
        [CBCB, CBCT, tumor, jh] = fun_getStat(data_main.CT, data_main.CB, data_main.SS, selected, data_main.CBinfo, jhOn);
        save(statFileName, 'CBCB', 'CBCT', 'tumor');
    end
     data_main.CBCB(selected.idxSS) = CBCB;
     data_main.CBCT(selected.idxSS) = CBCT;
     data_main.tumor(selected.idxSS) = tumor;
%     data_main.jh(selected.idxSS) = jh;
     data_main.flag.statData_z(selected.idxSS) = true;
     guidata(hFig_main, data_main);
end

CBCB = data_main.CBCB(selected.idxSS);
if strcmp(get(data_main.hMenuItem.AnalysisZ_CBCT, 'checked'), 'on')
    CBCB = data_main.CBCT(selected.idxSS);
end

dataColor = data_main.SS.contourColor{selected.idxSS}/255;

xTickLabel = {data_main.CBinfo.date};
date1 = selected.idxDate;
nSub = min(length(xTickLabel)-date1+1, 4);
date2 = date1+nSub-1;
for n = date1:date2
    xTickLabel{n} = ['\color{green}', xTickLabel{n}];
end

fieldName = fields(CBCB);
for iT = 1:length(fieldName)
    fieldVal = getfield(CBCB, fieldName{iT});
    ydata = fieldVal(selected.iSlice.z, :);
    xdata = 1:length(ydata);
    set(data_main.hPlotObj.Stat_zTime2d(iT), 'xdata', xdata', 'ydata', ydata, 'Color', dataColor)

    nSubData = NaN(size(ydata));
    nSubData(date1:date2) = ydata(date1:date2);
    set(data_main.hPlotObj.StatSub_zTime2d(iT), 'xdata', xdata, 'ydata', nSubData,...
        'MarkerEdgeColor', 'g')

    set(hAxis.Stat_zTime2d(iT), 'XTick', 1:length(xTickLabel))

    set(hAxis.Stat_zTime2d(iT), 'xticklabel',   xTickLabel)
    set(hAxis.Stat_zTime2d(iT), 'xticklabelrotation', -45)
    grid(hAxis.Stat_zTime2d(iT), 'on')
    
    % set y limit
    if ~all(isnan(fieldVal(:)))
        set(hAxis.Stat_zTime2d(iT), 'ylim', [min(fieldVal(:)) max(fieldVal(:))]); 
    end
end