function isOpen = isStatFigOpen
set(0, 'ShowHiddenHandles', 'on');
hOpenFig = get(0, 'Children');

isOpen = false;
for iFig = 1:length(hOpenFig)
    figName = hOpenFig(iFig).Name;
    if strcmp(figName, 'Statistics Analysis')
        isOpen = true;
        break
    end
end