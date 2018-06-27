function addStat2Axes_Tab(selected, CBCB, hAxes, dataColor, dateLabel, nSub) 

MS = 36;
axisLabelColor = 'white';

fieldName = fields(CBCB);
date1 = selected.idxDate;
date2 = date1+nSub-1;
xTickLabel = dateLabel;
for n = date1:date2
    xTickLabel{n} = ['\color{green}', dateLabel{n}];
end

% nmse
% CC
% mie
% fsim
% area Delta
% morph Delta

for iT = 1:length(fieldName)
    fieldVal = getfield(CBCB, fieldName{iT});
    cla(hAxes.Stat(iT))
    plot(hAxes.Stat(iT), fieldVal(selected.Slice, :), '.-', 'color', dataColor, 'MarkerSize', MS)
    hold(hAxes.Stat(iT), 'on')
%     ylabel(hAxes.Stat(iT), 'nmse-CBCB', 'color', axisLabelColor)
    grid on

    nSubData = NaN(size(fieldVal(selected.Slice, :)));
    nSubData(date1:date2) = fieldVal(selected.Slice, date1:date2);
    plot(hAxes.Stat(iT),nSubData , 'g.', 'MarkerSize', MS)

% label
    set(hAxes.Stat(iT), 'XTick',        1:length(dateLabel),...
                                'color',        'k',...
                                'gridcolor',   'w',...
                                'xcolor',       axisLabelColor,...
                                'ycolor',       axisLabelColor)
    set(hAxes.Stat(iT), 'xticklabel',   xTickLabel)
    set(hAxes.Stat(iT), 'xticklabelrotation', 45)
    
    grid(hAxes.Stat(iT), 'on')
end
