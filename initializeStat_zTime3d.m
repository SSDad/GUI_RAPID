function initializeStat_zTime3d(data_main)

hFig_main = data_main.hFig_main;
data_main = guidata(hFig_main);
selected = data_main.selected;

CBCB = data_main.CBCB(selected.idxSS);
dataColor = 0.3*[1 1 1];

xTickLabel = {data_main.CBinfo.date};
date1 = selected.idxDate;
nSub = min(length(xTickLabel)-date1+1, 4);
date2 = date1+nSub-1;

%% plot
fieldName = fields(CBCB);
for iT = 1:length(fieldName)
    fieldVal = getfield(CBCB, fieldName{iT});
    
    [M, N] = size(fieldVal);
    
    for iy = 1:M
        data_main.hPlotObj.stat_zTime3d(iT, iy) = line(NaN, NaN, NaN, 'parent', data_main.hAxis.Stat_zTime3d(iT));
%         set(data_main.hPlotObj.stat_zTime3d(iT, iy), 'Color', dataColor, 'Marker', '.', 'MarkerSize', 16,...
%             'MarkerFaceColor', dataColor, 'MarkerEdgeColor', dataColor)
        set(data_main.hPlotObj.stat_zTime3d(iT, iy), 'Marker', '.', 'MarkerSize', 16);
    end
    
    set(data_main.hAxis.Stat_zTime3d(iT), 'View', [-20.8000 25.2000]);
    set(data_main.hAxis.Stat_zTime3d(iT), 'XTick', 1:length(xTickLabel))
    set(data_main.hAxis.Stat_zTime3d(iT), 'xticklabel',   xTickLabel)
    set(data_main.hAxis.Stat_zTime3d(iT), 'xticklabelrotation', -45)

    % set y limit
    if ~all(isnan(fieldVal(:)))
        set(data_main.hAxis.Stat_zTime3d(iT), 'zlim', [min(fieldVal(:)) max(fieldVal(:))]); 
    end

%     for ix = 1:N
%         hPx(ix) = plot3(NaN, NaN, NaN, 'parent', hA);
%         set(hPx(ix), 'Color', 'c', 'Marker', '.', 'MarkerSize', 24,...
%             'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'c')
%     end
% 
%     nSubData = NaN(size(ydata));
%     nSubData(date1:date2) = ydata(date1:date2);
%     set(data_main.hPlotObj.StatSub(iT), 'xdata', xdata, 'ydata', nSubData,...
%         'MarkerEdgeColor', 'g')
% 
%     set(hAxis.Stat(iT), 'XTick', 1:length(xTickLabel))
% 
%     grid(hAxis.Stat(iT), 'on')
end
guidata(hFig_main, data_main);

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