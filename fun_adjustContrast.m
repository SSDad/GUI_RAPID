function fun_adjustContrast(varargin)

    % QA Dicom Image View
    global I hLevel hDcm hHist hBW hWinLeft hWinRight hWinBar ...
              pt1
    
    S1 = (32-6)^2;
    S2 = (79-12)^2;

    %%%%%%%%
    % GUI set up
    %%%%%%%%
    % main GUI figure
    hFig = figure(...     
                        'MenuBar','none', ...
                        'Toolbar','none', ...
                        'HandleVisibility','callback', ...
                        'Name', 'QA Image Viewer', ...
                        'NumberTitle','off', ...
                        'Units', 'normalized', 'Position', [.1 .2 .8 .7],...
                        'Color', 'black');

    hNewToolbar = uitoolbar ('parent',hFig);
    hButton = uitoolfactory(hNewToolbar,'Exploration.ZoomIn');
    hButton = uitoolfactory(hNewToolbar,'Exploration.ZoomOut');
    hButton = uitoolfactory(hNewToolbar,'Exploration.Pan');

    % file manu                       
    hFileMenu = uimenu(...      
                            'Parent', hFig,...
                            'HandleVisibility', 'callback', ...
                            'Label', 'QA Image');

    hOpenMenuitem  =   uimenu(...      
                            'Parent',hFileMenu,...
                            'Label','Open',...
                            'HandleVisibility','callback', ...
                            'Callback', @hOpenMenuitem_Callback);

    % image info panel_
    x_hPanel_patientInfo = 0.0;
    w_hPanel_patientInfo = 0.2;
    h_hPanel_patientInfo = 0.5;
    y_hPanel_patientInfo =0.5;

    hPanel_patientInfo = uipanel('Parent',hFig,...
                'Title','Image Information','FontSize',12,...
                 'TitlePosition', 'lefttop',...
                'Units', 'normalized', ...
                'Position', [x_hPanel_patientInfo ...
                                 y_hPanel_patientInfo ...
                                 w_hPanel_patientInfo ...
                                 h_hPanel_patientInfo],...
                 'ForegroundColor','white',...
                 'BackgroundColor','black',...
                 'BorderType', 'etchedout',...
                 'HighlightColor', 'cyan',...
                 'ShadowColor', 'blue',...
                 'BorderWidth', 2);

    % image info Table
    x_hTable_Info = 0;
    w_hTable_Info = 1;
    h_hTable_Info = 1;
    y_hTable_Info = 1-h_hTable_Info;

    ColumnName = {'Value'};
    ww = 100;
    ColumnWidth =  {ww};
    RowName = {'RTImageLabel',...
                          'CreationDate', ...
                          'CreationTime'};


    hTable_Info = uitable('parent', hPanel_patientInfo,...
                'Units', 'normalized', ...
                'Position', [x_hTable_Info ...
                                y_hTable_Info ...
                                w_hTable_Info ...
                                h_hTable_Info],...
                'ColumnName', ColumnName,...
                'Columnwidth', ColumnWidth,...
                'ColumnFormat', {'char'},...
                'RowName', RowName,...
                'BackgroundColor', [0 0 0],...             
                'ForegroundColor', [0 1 0],...             
                'FontSize', 9);
                        
    % view panel
    x_hPanel_sliceView = 0.2;
    w_hPanel_sliceView = 0.8;
    h_hPanel_sliceView = 1;
    y_hPanel_sliceView =0;

    hPanel_sliceView = uipanel('Parent',hFig,...
                'Title','Image View','FontSize',12,...
                 'TitlePosition', 'centertop',...
                'Units', 'normalized', ...
                'Position', [x_hPanel_sliceView ...
                                 y_hPanel_sliceView ...
                                 w_hPanel_sliceView ...
                                 h_hPanel_sliceView],...
                 'ForegroundColor','blue',...
                 'BackgroundColor','white',...
                 'BorderType', 'etchedout',...
                 'HighlightColor', 'cyan',...
                 'ShadowColor', 'blue',...
                 'BorderWidth', 2);

    % dcm axes
    x_hAxes_SliceImage = 0.0;
    w_hAxes_SliceImage = 0.5;
    y_hAxes_SliceImage = 0.4;
    h_hAxes_SliceImage = 0.6;

    hAxes_SliceImage = axes(...
                        'Parent', hPanel_sliceView, ...
                        'Color', 'white',...
                        'Units', 'normalized', ...
                        'HandleVisibility','callback', ...
                        'Position',[x_hAxes_SliceImage ...
                                        y_hAxes_SliceImage ...
                                        w_hAxes_SliceImage ...
                                        h_hAxes_SliceImage]);
                        %'box','off','xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1]);
    axis(hAxes_SliceImage, 'on')
    hold(hAxes_SliceImage, 'on');

    % hist axes
    x_hAxes_hist = 0.05;
    w_hAxes_hist = 1-x_hAxes_hist-0.05;
    y_hAxes_hist = 0.06;
    h_hAxes_hist = 1-h_hAxes_SliceImage-y_hAxes_hist;

    hAxes_hist = axes(...
                        'Parent', hPanel_sliceView, ...
                        'Color', 'black',...
                        'Units', 'normalized', ...
                        'HandleVisibility','callback', ...
                        'Position',[x_hAxes_hist ...
                                        y_hAxes_hist ...
                                        w_hAxes_hist ...
                                        h_hAxes_hist]);
                        %'box','off','xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1]);
    axis(hAxes_hist, 'on')
    hold(hAxes_hist, 'on');

    % BW axes
    x_hAxes_BW = 1-w_hAxes_SliceImage;
    w_hAxes_BW = 0.5;
    y_hAxes_BW = 0.4;
    h_hAxes_BW = 0.6;

    hAxes_BW = axes(...
                        'Parent', hPanel_sliceView, ...
                        'Color', 'white',...
                        'Units', 'normalized', ...
                        'HandleVisibility','callback', ...
                        'Position',[x_hAxes_BW ...
                                        y_hAxes_BW ...
                                        w_hAxes_BW ...
                                        h_hAxes_BW]);
                        %'box','off','xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1]);
    axis(hAxes_BW, 'on')
    hold(hAxes_BW, 'on');

    %%%%%%%%
    % Callback     
    %%%%%%%%
    function hOpenMenuitem_Callback(hObject, eventdata)

        %%%%%%%%%%%
        % load structures
        %%%%%%%%%%%
        [fn, Folder] = uigetfile('*.*');

        if Folder
            if ishandle(hLevel)
                delete(hLevel)
                delete(hHist)
                delete(hWinLeft)
                delete(hWinRight)
                delete(hWinBar)
            end
            
            ffn = fullfile(Folder, fn);
            dcmInfo = dicominfo(ffn);
            tableData{1} = dcmInfo.RTImageLabel;
            tableData{2} = dcmInfo.InstanceCreationDate;
            tableData{3} = dcmInfo.InstanceCreationTime;
            set(hTable_Info, 'data', tableData');

            I = dicomread(ffn);
            hDcm = imshow(I, [], 'parent', hAxes_SliceImage);

            [counts, binLocations] = imhist(I, 2^16);
            idx = find(counts>0);
            x = binLocations(idx);
            y = counts(idx);
            hHist = plot(x, y, '.-', 'parent', hAxes_hist);
            set(hAxes_hist, 'Xlim', [min(x) max(x)]);
            
%             % kV level
%             n = 0;
%             SS = 0;
%             while SS < S1+S2
%                 n = n+1;
%                 SS = sum(counts(end-n+1:end));
%             end
%             level = binLocations(end-n+1)/2^16;
            
            level = graythresh(I);
            
            yLimit = get(hAxes_hist, 'YLim');
            hLevel = line([level level]*2^16, yLimit,...
                                    'color', 'r', 'linewidth', 4,...
                                    'parent', hAxes_hist,...
                                    'ButtonDownFcn', @startDragFcn_hLevel);
   
            cLimit = get(hAxes_SliceImage, 'CLim');
            hWinLeft = line(cLimit(1)*[1 1], yLimit,...
                                    'color', 'g', 'linewidth', 4,...
                                    'parent', hAxes_hist, ...
                                    'ButtonDownFcn', @startDragFcn_hWinLeft);

            hWinRight = line(cLimit(2)*[1 1], yLimit,...
                                    'color', 'g', 'linewidth', 4,...
                                    'parent', hAxes_hist, ...
                                    'ButtonDownFcn', @startDragFcn_hWinRight);
                                
            hWinBar = line(cLimit, yLimit,...
                                    'color', 'c', 'linewidth', 4,...
                                    'parent', hAxes_hist, ...
                                    'ButtonDownFcn', @startDragFcn_hWinBar);

            set(hFig, 'WindowButtonUpFcn', @stopDragFcn);
                                
            BW = im2bw(I, level);
            hBW = imshow(BW, 'parent', hAxes_BW);

        end
    end

    function startDragFcn_hLevel(hObject, eventdata)
        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hLevel);
    end

    function draggingFcn_hLevel(hObject, eventdata)
        pt = get(hAxes_hist, 'CurrentPoint');
        set(hLevel, 'XData', pt(1)*[1 1])
        
        if pt(1) <= 2^16-1
            level = pt(1)/2^16;
            BW = im2bw(I, level);
            %imshow(BW, 'parent', hAxes_BW)
            set(hBW, 'CData', BW);
        end
    end

    function startDragFcn_hWinLeft(hObject, eventdata)
        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hWinLeft);
    end
    function draggingFcn_hWinLeft(hObject, eventdata)
        pt = get(hAxes_hist, 'CurrentPoint');
        set(hWinLeft, 'XData', pt(1)*[1 1])
        
        xD = get(hWinRight, 'XData');
        set(hWinBar, 'XData', [pt(1) xD(1)]); 
        
        cLimit = get(hAxes_SliceImage, 'CLim');
        set(hAxes_SliceImage, 'CLim', [pt(1) cLimit(2)]);
    end

    function startDragFcn_hWinRight(hObject, eventdata)
        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hWinRight);
    end
    function draggingFcn_hWinRight(hObject, eventdata)
        pt = get(hAxes_hist, 'CurrentPoint');
        set(hWinRight, 'XData', pt(1)*[1 1])

        xD = get(hWinLeft, 'XData');
        set(hWinBar, 'XData', [xD(1) pt(1)]); 
        
        cLimit = get(hAxes_SliceImage, 'CLim');
        set(hAxes_SliceImage, 'CLim', [cLimit(1) pt(1)]);
    end

    function startDragFcn_hWinBar(hObject, eventdata)
        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hWinBar);
        pt1 = get(hAxes_hist, 'CurrentPoint');
    end
    function draggingFcn_hWinBar(hObject, eventdata)
        pt2 = get(hAxes_hist, 'CurrentPoint');
        d = pt2(1) - pt1(1);
        
        xD_L = get(hWinLeft, 'XData');
        set(hWinLeft, 'XData', xD_L+d); 
        xD_R = get(hWinRight, 'XData');
        set(hWinRight, 'XData', xD_R+d); 

        set(hWinBar, 'XData', [xD_L(1) xD_R(1)]); 

        set(hAxes_SliceImage, 'CLim', [xD_L(1) xD_R(1)]);

        pt1 = get(hAxes_hist, 'CurrentPoint');
        
    end

    function stopDragFcn(hObject, eventdata)
        set(hFig, 'WindowButtonMotion', '')
    end

end