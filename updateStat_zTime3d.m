function updateStat_zTime3d(data_main)

hFig_main = data_main.hFig_main;
data_main = guidata(hFig_main);
selected = data_main.selected;

CBCB = data_main.CBCB(selected.idxSS);
if strcmp(get(data_main.hMenuItem.AnalysisZ_CBCT, 'checked'), 'on')
    CBCB = data_main.CBCT(selected.idxSS);
end

dataColor = data_main.SS.contourColor{selected.idxSS}/255;
dColor = 0.3*[1 1 1];

%% plot
fieldName = fields(CBCB);
for iT = 1:length(fieldName)
    fieldVal = getfield(CBCB, fieldName{iT});
    
    if ~isempty(fieldVal)
        [M, N] = size(fieldVal);
    
    xx = 1:N;
    for iy = 1:M
        yy = iy*ones(1,N);
        zz = fieldVal(iy, :);
        set(data_main.hPlotObj.stat_zTime3d(iT, iy), 'xdata', xx, 'ydata', yy, 'zdata', zz);
    end
    set(data_main.hPlotObj.stat_zTime3d(iT, :), 'Color', dColor,...
        'MarkerFaceColor', dColor, 'MarkerEdgeColor', dColor);
    set(data_main.hPlotObj.stat_zTime3d(iT, selected.iSlice.z), 'Color', dataColor,...
        'MarkerFaceColor', dataColor, 'MarkerEdgeColor', dataColor);

    ylim = get(data_main.hAxis.Stat_zTime2d(iT), 'ylim');
    set(data_main.hAxis.Stat_zTime3d(iT), 'zlim',   ylim)
    
    end
    %     set(data_main.hAxis.Stat_zTime3d(iT), 'zlim', [0 0.2]);
%    rotate3d(data_main.hAxis.Stat_zTime3d(iT), 'on')
%     for ix = 1:N
%         hPx(ix) = plot3(NaN, NaN, NaN, 'parent', hA);
%         set(hPx(ix), 'Color', 'c', 'Marker', '.', 'MarkerSize', 24,...
%             'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'c')
%     end
    
    
%     ydata = fieldVal(selected.iSlice.z, :);
%     xdata = 1:length(ydata);
%     set(data_main.hPlotObj.Stat(iT), 'xdata', xdata', 'ydata', ydata, 'Color', dataColor)
% 
%     nSubData = NaN(size(ydata));
%     nSubData(date1:date2) = ydata(date1:date2);
%     set(data_main.hPlotObj.StatSub(iT), 'xdata', xdata, 'ydata', nSubData,...
%         'MarkerEdgeColor', 'g')
% 
%     set(hAxis.Stat(iT), 'XTick', 1:length(xTickLabel))
% 
%     set(hAxis.Stat(iT), 'xticklabel',   xTickLabel)
%     set(hAxis.Stat(iT), 'xticklabelrotation', 45)
%     grid(hAxis.Stat(iT), 'on')
end

% guidata(hFig_main, data_main);

% xTickLabel = {data_main.CBinfo.date};
% date1 = selected.idxDate;
% nSub = min(length(xTickLabel)-date1+1, 4);
% date2 = date1+nSub-1;
% for n = date1:date2
%     xTickLabel{n} = ['\color{green}', xTickLabel{n}];
% end
% 
% fieldName = fields(CBCB);
% 
% for iT = 1:length(fieldName)
%     fieldVal = getfield(CBCB, fieldName{iT});
%     ydata = fieldVal(selected.iSlice.z, :);
%     xdata = 1:length(ydata);
%     set(data_main.hPlotObj.Stat(iT), 'xdata', xdata', 'ydata', ydata, 'Color', dataColor)
% 
%     nSubData = NaN(size(ydata));
%     nSubData(date1:date2) = ydata(date1:date2);
%     set(data_main.hPlotObj.StatSub(iT), 'xdata', xdata, 'ydata', nSubData,...
%         'MarkerEdgeColor', 'g')
% 
%     set(hAxis.Stat(iT), 'XTick', 1:length(xTickLabel))
% 
%     set(hAxis.Stat(iT), 'xticklabel',   xTickLabel)
%     set(hAxis.Stat(iT), 'xticklabelrotation', 45)
%     grid(hAxis.Stat(iT), 'on')
% end
% axis(hAxis.Stat, 'on')