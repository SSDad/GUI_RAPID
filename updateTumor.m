function updateTumor(hFig_main, panelTag, iSlice)

data_main = guidata(hFig_main);
selected = data_main.selected;
hPlotObj = data_main.hPlotObj;
if strcmp(data_main.hMenuItem.CT.Checked, 'on')
    tumor1 =  data_main.tumor(selected.idxSS).CT(iSlice);
    tumor2 = [];
elseif strcmp(data_main.hMenuItem.CB.Checked, 'on')
    tumor1 =  [];
    tumor2 = data_main.tumor(selected.idxSS).CB(iSlice, selected.idxDate);
elseif strcmp(data_main.hMenuItem.CTCB.Checked, 'on')
    tumor1 =  data_main.tumor(selected.idxSS).CT(iSlice);
    tumor2 =  data_main.tumor(selected.idxSS).CB(iSlice, selected.idxDate);
end
tumorOffSet = data_main.tumor(selected.idxSS).OffSet;

dx = data_main.CT.xx(2)-data_main.CT.xx(1);
dy = data_main.CT.yy(2)-data_main.CT.yy(1);

switch panelTag
    case '1'
        if isempty(tumor2)
            xy{1} = tumor1.points;
            xy{2} = [nan nan];
        elseif isempty(tumor1)
            xy{1} = [nan nan];
            xy{2} = tumor2.points;
        else
            xy{1} = tumor1.points;
            xy{2} = tumor2.points;
        end
            
        OffSet = tumorOffSet(iSlice, :);
        
        if isnan(OffSet(1))
            set(hPlotObj.tumor, 'xdata', [], 'ydata', []);    
        else
            for n = 1:2
                x = xy{n}(:,2)+OffSet(1);
                y = xy{n}(:,1)+OffSet(2);
                xx = x*dx+data_main.CT.xx(1);
                yy = y*dy+data_main.CT.yy(1);
                set(hPlotObj.tumor(n), 'xdata', xx, 'ydata', yy, 'visible', 'on');    
            end
        end
end