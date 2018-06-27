function showContrast2(hFig, hI, hC, I, Lim, CTorCB)

    global pt1
    global xC
    
    cla(hC)
    
    % hist
    y = histcounts(I, max(I(:))+1);
    x = 1:length(y);
    
    y = log10(y);
    y = y/max(y);

    % y norm
%     level = graythresh(I);
%     n1 = round(2^16*level);
%     y = y/max(y(n1:end));
    
    plot(hC, x, y , 'color', 'w')
    hold(hC,  'on');
    axis(hC, 'off');
    H = area(hC, x, y); 
    set(H, 'FaceColor', [1 1 1]);

    minCT = Lim(1);
    maxCT = Lim(2);
    xbuff = (maxCT-minCT)*0.1;
    xlim1 = minCT-xbuff;
    xlim2 = maxCT+xbuff;

    ylim = 1;
    set(hC, 'XLim', [xlim1 xlim2])                                
    set(hC, 'YLim', [0 ylim])                                
    set(hC, 'color', 'k')
%     axis(hC, 'fill')
%     set(hC, 'xtick', [], 'ytick', [])
%     axis(hC, 'on')

    % contrast window
    CLimAll = get(hI, 'userdata');
    if strcmp('CT', CTorCB)
        CLim = CLimAll(1:2);
        patchColor = 'm';
    else
        CLim = CLimAll(3:4);
        patchColor = 'g';
    end
    
    x1.C = CLim(1);
    x2.C = CLim(2);
    y1.C = 0;
    y2.C = ylim;
    X.C = [x1.C x2.C x2.C x1.C];
    Y.C = [y1.C y1.C y2.C y2.C];
    hContrastWin.C = patch(hC, X.C, Y.C, patchColor, 'FaceAlpha', .2, 'Tag', 'CenterPatch', ...
                                        'ButtonDownFcn', @startDragFcn_hWinC);

    xW.L = xbuff/4;
    x1.L = x1.C-xW.L;
    x2.L = x1.C;
    y1.L = (y1.C+y2.C)/2-(y1.C+y2.C)/10;
    y2.L = (y1.C+y2.C)/2+(y1.C+y2.C)/10;
    X.L = [x1.L x2.L x2.L x1.L];
    Y.L = [y1.L y1.L y2.L y2.L];
    hContrastWin.L = patch(hC, X.L, Y.L, patchColor, 'FaceAlpha', 1, ...
                                        'ButtonDownFcn', @startDragFcn_hWinL);

    xW.R = xW.L;
    x1.R = x2.C+xW.R;
    x2.R = x2.C;
    y1.R = y1.L;
    y2.R = y2.L;
    X.R = [x1.R x2.R x2.R x1.R];
    Y.R = [y1.R y1.R y2.R y2.R];
    hContrastWin.R = patch(hC, X.R, Y.R, patchColor, 'FaceAlpha', 1, ...
                                        'ButtonDownFcn', @startDragFcn_hWinR);

    set(hFig, 'WindowButtonUpFcn', @stopDragFcn);

    % vertical
    set(hC,'ydir','reverse')
    view(hC, [-90 90])


    function startDragFcn_hWinR(hObject, eventdata)
        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hWinR);
        pt1 = get(hC, 'CurrentPoint');
    end

    function draggingFcn_hWinR(hObject, eventdata)
        pt2 = get(hC, 'CurrentPoint');
        d = pt1(1) - pt2(1);
        xR = get(hContrastWin.R, 'xdata');
        xR = xR-d;
        xR(1) = min(xR(1), maxCT);
        xL = get(hContrastWin.L, 'xdata');
        xR(1) = max(xR(1), xL(2)+10);
        
        xR(4) = xR(1);
        xR(2:3) = xR(1)+xW.R;
        set(hContrastWin.R, 'xdata', xR);

        xC = get(hContrastWin.C, 'xdata');
        xC(2:3) = xR(1);
        set(hContrastWin.C, 'xdata', xC);
        pt1 = get(hC, 'CurrentPoint');
        
        In = mat2gray(I, [xC(1) xC(2)]);
        C = im2uint8(In);
        cdata = get(hI, 'cdata');
        
        if strcmp('CT', CTorCB)
            cdata(:,:,1) = C;
            cdata(:,:,3) = C;
        else
            cdata(:,:,2) = C;
        end
        set(hI, 'cdata', cdata)

        LimAll = get(hI, 'userdata');
        if strcmp('CT', CTorCB)
            LimAll(1:2) = [xC(1) xC(2)];
        else
            LimAll(3:4) = [xC(1) xC(2)];
        end
        set(hI, 'userdata', LimAll)

    end

    function startDragFcn_hWinL(hObject, eventdata)
        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hWinL);
        pt1 = get(hC, 'CurrentPoint');
    end

    function draggingFcn_hWinL(hObject, eventdata)
        pt2 = get(hC, 'CurrentPoint');
        d = pt2(1) - pt1(1);
        xL = get(hContrastWin.L, 'xdata');
        xL = xL+d;
        xL(2) = max(xL(2), minCT);
        xR = get(hContrastWin.R, 'xdata');
        xL(2) = min(xL(2), xR(1)-10);
        
        xL(3) = xL(2);
        xL(1) = xL(2)-xW.L;
        xL(4) = xL(1);
        set(hContrastWin.L, 'xdata', xL);

        xC = get(hContrastWin.C, 'xdata');
        xC(1) = xL(2);
        xC(4) = xC(1);
        set(hContrastWin.C, 'xdata', xC);
        pt1 = get(hC, 'CurrentPoint');
        
        In = mat2gray(I, [xC(1) xC(2)]);
        C = im2uint8(In);
        cdata = get(hI, 'cdata');
        
        if strcmp('CT', CTorCB)
            cdata(:,:,1) = C;
            cdata(:,:,3) = C;
        else
            cdata(:,:,2) = C;
        end
        set(hI, 'cdata', cdata)

        LimAll = get(hI, 'userdata');
        if strcmp('CT', CTorCB)
            LimAll(1:2) = [xC(1) xC(2)];
        else
            LimAll(3:4) = [xC(1) xC(2)];
        end
        set(hI, 'userdata', LimAll)

    end

    function startDragFcn_hWinC(hObject, eventdata)
        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hWinC);
        pt1 = get(hC, 'CurrentPoint');
    end

    function draggingFcn_hWinC(hObject, eventdata)
        pt2 = get(hC, 'CurrentPoint');
        d = pt2(1) - pt1(1);
        xC = get(hContrastWin.C, 'xdata');
        xC = xC+d;
        xC(1) = max(xC(1), minCT); xC(4) = xC(1);
        xC(2) = min(xC(2), maxCT); xC(3) = xC(2);
        set(hContrastWin.C, 'xdata', xC);

        xL(2) = xC(1);        xL(3) = xL(2);
        xL(1) = xL(2)-xW.L;        xL(4) = xL(1);
        set(hContrastWin.L, 'xdata', xL);

        xR(1) = xC(2); xR(4) = xR(1);
        xR(2) = xR(1)+xW.R;        xR(3) = xR(2);
        set(hContrastWin.R, 'xdata', xR);
        
        pt1 = get(hC, 'CurrentPoint');
        
        In = mat2gray(I, [xC(1) xC(2)]);
        C = im2uint8(In);
        cdata = get(hI, 'cdata');
        
        if strcmp('CT', CTorCB)
            cdata(:,:,1) = C;
            cdata(:,:,3) = C;
        else
            cdata(:,:,2) = C;
        end
        set(hI, 'cdata', cdata)

        LimAll = get(hI, 'userdata');
        if strcmp('CT', CTorCB)
            LimAll(1:2) = [xC(1) xC(2)];
        else
            LimAll(3:4) = [xC(1) xC(2)];
        end
        set(hI, 'userdata', LimAll)
        
    end

    function stopDragFcn(hObject, eventdata)
        set(hFig, 'WindowButtonMotion', '')
    end

end