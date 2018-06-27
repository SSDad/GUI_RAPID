% ImageButtonDownCallBack
function ibdcb(src, evnt)

hFig_main = ancestor(src, 'Figure');
data_main = guidata(hFig_main);

hCurrentAxis = src.Parent;
hCurrentPanel = hCurrentAxis.Parent;
hAllPanel = get(hCurrentPanel.Parent, 'children');
set(hAllPanel, 'HighLightColor', 'black', 'ShadowColor',  'black');

set(hCurrentPanel, 'HighLightColor', 'green', 'ShadowColor',  'green');

data_main.selected.Image = src;
data_main.selected.Axis = hCurrentAxis;
data_main.selected.Panel = hCurrentPanel;

guidata(hFig_main, data_main)