function hMenuItem_Stat_Tab_Callback(hObject, eventdata)
global CT
global SS
global CB
global hAxes
global selected
global flag
global CBCB
global dateLabel
global dataColor
global CBCBmem
global RadoncID
global fd_data

fn_data = [RadoncID{1}, '_StatData_', SS.sNames{selected.idxSS}];
ffn = fullfile(fd_data, RadoncID{1}, [fn_data, '.mat']);

flag.CBCBcal = false;
for n = 1:length(CBCBmem)
    if selected.idxSS == CBCBmem(n).idx;
        CBCB = CBCBmem(n).data;
        flag.CBCBcal = true;
        break
    end
end

if ~flag.CBCBcal
    if exist(ffn, 'file')
        load(ffn);
        CBCB = statData;
    else
        [CBCB] = fun_getStat(CT, CB, SS, selected);
        saveStatData;
        nCBCB = length(CBCBmem);
        CBCBmem(nCBCB+1).idx = selected.idxSS;
        CBCBmem(nCBCB+1).data = CBCB;
    end
end

flag.statFig = isStatFigOpen;
if ~flag.statFig
%%%%%%%%%%%%%%%%%%%%%%%%%
% GUI Setup
%%%%%%%%%%%%%%%%%%%%%%%%%
    % main GUI figure
    hFig_Stat = figure('MenuBar',            'none', ...
                        'Toolbar',              'none', ...
                        'HandleVisibility',  'callback', ...
                        'Name',                'Statistics Analysis', ...
                        'NumberTitle',      'off', ...
                        'Units',                 'normalized',...
                        'Position',             [0.25 0.25 0.5 0.5],...
                        'Color',                 'black', ...
                        'Visible',               'on');
    hstatTabGroup = uitabgroup('Parent', hFig_Stat);
    
    titleName{1} = 'Mean Square Error';
    titleName{2} = 'Correlation Coefficient';
    titleName{3} = 'Mutual Information';
    titleName{4} = 'Feature Similarity';
    titleName{5} = 'Area Delta';
    titleName{6} = 'Morph Delta';
    
    for iT = 1:length(fields(CBCB))
        hStatTab(iT) = uitab('Parent', hstatTabGroup, 'Title', titleName{iT});
        set(hStatTab(iT), 'Backgroundcolor', 'k')
        % add axes
        hAxes.Stat(iT) = axes('Parent',                   hStatTab(iT), ...
                                            'Units',                    'normalized', ...
                                            'HandleVisibility',     'callback', ...
                                            'Position',                 [0.1 0.15 0.8 0.75]);
        axis(hAxes.Stat(iT), 'off')
    end
    
    dateLabel = cellstr(CB.dateCreated);
    dataColor = SS.contourColor{selected.idxSS}/255;

    addStat2Axes_Tab(selected, CBCB, hAxes, dataColor, dateLabel, CB.nSub)
    
    flag.statFig = true;
end