function hToolbar = addToolbar(hFig)

%% toolbar          
hToolbar = uitoolbar ('parent', hFig);

% standard
uitoolfactory(hToolbar,'Exploration.ZoomIn');
uitoolfactory(hToolbar,'Exploration.ZoomOut');
uitoolfactory(hToolbar,'Exploration.Pan');                
uitoolfactory(hToolbar,'Exploration.DataCursor');                
uitoolfactory(hToolbar, 'Exploration.Rotate');

% custom
[iconRoot, iconRootMATLAB] = ipticondir;  % Get roots for where to find icons

% Common properties for several push tools
t = [];
t.toolConstructor            = @uipushtool;
t.properties.Parent          = hToolbar;
t.properties.Interruptible   = 'off';    % Make buttons busy, cancel
t.properties.BusyAction      = 'cancel'; % any repeated click events.

% distance tool toolbar button
t.iconConstructor            = @makeToolbarIconFromGIF;
t.iconRoot                   = iconRoot;
t.icon                       = 'distance_tool.gif';
t.properties.TooltipString   = getString(message('images:imtoolUIString:measureDistanceTooltipString'));
t.properties.Tag             = 'distance tool toolbar button';
% t.properties.ClickedCallback = @distanceToolButton_ClickedCallback;
% distanceTool = makeToolbarItem(t);