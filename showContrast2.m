function showContrast2(hFig, hI, hCC, II, Lim)

    global pt1
    global xC
    global CTorCB
    global hC
    global patchTag
    
    ylim = 1;
    
    CLimAll = get(hI, 'userdata');
    CLim{1} = CLimAll(1:2);
    CLim{2} = CLimAll(3:4);
    patchColor = 'mg';
    
    CTCB = {'CT', 'CB'};
        
    for nC = 1:2
    
        plotHist(II{nC}, hCC(nC), Lim{nC}, CTCB{nC})

        hPH = get(hCC(nC), 'children');
        tag = get(hPH, 'Tag');
        
        % contrast window
        x1.C = CLim{nC}(1);
        x2.C = CLim{nC}(2);
        y1.C = 0;
        y2.C = ylim;
        X.C = [x1.C x2.C x2.C x1.C];
        Y.C = [y1.C y1.C y2.C y2.C];
        iCP = find(strcmp(tag, 'CenterPatch'));
        hContrastWin(nC).C = hPH(iCP);
        set(hContrastWin(nC).C, 'xdata', X.C, 'ydata', Y.C, 'FaceColor', patchColor(nC));
        set(hContrastWin(nC).C, 'ButtonDownFcn', @startDragFcn_hWin);
       
        xW.L = xbuff/4;
        x1.L = x1.C-xW.L;
        x2.L = x1.C;
        y1.L = (y1.C+y2.C)/2-(y1.C+y2.C)/4;
        y2.L = (y1.C+y2.C)/2+(y1.C+y2.C)/4;
        X.L = [x1.L x2.L x2.L x1.L];
        Y.L = [y1.L y1.L y2.L y2.L];
        iLP = find(strcmp(tag, 'LeftPatch'));
        hContrastWin(nC).L = hPH(iLP);
        set(hContrastWin(nC).L, 'xdata', X.L, 'ydata', Y.L, 'FaceColor', patchColor(nC));
        set(hContrastWin(nC).L, 'ButtonDownFcn', @startDragFcn_hWin);

        xW.R = xW.L;
        x1.R = x2.C+xW.R;
        x2.R = x2.C;
        y1.R = y1.L;
        y2.R = y2.L;
        X.R = [x1.R x2.R x2.R x1.R];
        Y.R = [y1.R y1.R y2.R y2.R];
        iRP = find(strcmp(tag, 'RightPatch'));
         hContrastWin(nC).R = hPH(iRP);
        set(hContrastWin(nC).R, 'xdata', X.R, 'ydata', Y.R, 'FaceColor', patchColor(nC));
        set(hContrastWin(nC).R, 'ButtonDownFcn', @startDragFcn_hWin);

    end

    set(hFig, 'WindowButtonUpFcn', @stopDragFcn);

    function plotHist(I, hC, Lim, CTorCB)
        % hist
        y = histcounts(I, max(I(:))+1);
        x = 1:length(y);
        y = log10(y);
        y = y/max(y);

        hPH = get(hC, 'children');
        tag = get(hPH, 'Tag');
        iHist = find(strcmp(tag, 'Hist'));
        set(hPH(iHist), 'xdata', x, 'ydata', y);

        minCT = Lim(1);
        maxCT = Lim(2);
        xbuff = (maxCT-minCT)*0.125;
        xlim1 = minCT-xbuff;
        xlim2 = maxCT+xbuff;

        ylim = 1;
        set(hC, 'XLim', [xlim1 xlim2])                                
        set(hC, 'YLim', [0 ylim])                                
        set(hC, 'color', 'k')
        
        set(hC, 'Tag', CTorCB)

        % vertical
        set(hC,'ydir','reverse')
        view(hC, [-90 90])
    end

    function startDragFcn_hWin(hObject, eventdata)
        
        patchTag = get(hObject, 'Tag');
        hC = get(hObject, 'parent');
        pt1 = get(hC, 'CurrentPoint');
        CTorCB = get(hC, 'Tag');

        set(hFig, 'WindowButtonMotionFcn', @draggingFcn_hWin);
        
    end

    function draggingFcn_hWin(hObject, eventdata)

        if strcmp(CTorCB, 'CT')
            minCT = Lim{1}(1);
            maxCT = Lim{1}(2);
            winIdx = 1;
        else
            minCT = Lim{2}(1);
            maxCT = Lim{2}(2);
            winIdx = 2;
        end
        
        pt2 = get(hC, 'CurrentPoint');
        
        if strcmp(patchTag, 'RightPatch')
            d = pt1(1) - pt2(1);
            xR = get(hContrastWin(winIdx).R, 'xdata');
            xR = xR-d;
            xR(1) = min(xR(1), maxCT);
            xL = get(hContrastWin(winIdx).L, 'xdata');
            xR(1) = max(xR(1), xL(2)+10);
        
            xR(4) = xR(1);
            xR(2:3) = xR(1)+xW.R;
            set(hContrastWin(winIdx).R, 'xdata', xR);

            xC = get(hContrastWin(winIdx).C, 'xdata');
            xC(2:3) = xR(1);
            set(hContrastWin(winIdx).C, 'xdata', xC);
        elseif strcmp(patchTag, 'LeftPatch')
            d = pt2(1) - pt1(1);
            xL = get(hContrastWin(winIdx).L, 'xdata');
            xL = xL+d;
            xL(2) = max(xL(2), minCT);
            xR = get(hContrastWin(winIdx).R, 'xdata');
            xL(2) = min(xL(2), xR(1)-10);

            xL(3) = xL(2);
            xL(1) = xL(2)-xW.L;
            xL(4) = xL(1);
            set(hContrastWin(winIdx).L, 'xdata', xL);

            xC = get(hContrastWin(winIdx).C, 'xdata');
            xC(1) = xL(2);
            xC(4) = xC(1);
            set(hContrastWin(winIdx).C, 'xdata', xC);
        elseif strcmp(patchTag, 'CenterPatch')
            d = pt2(1) - pt1(1);
            xC = get(hContrastWin(winIdx).C, 'xdata');
            xC = xC+d;
            xC(1) = max(xC(1), minCT); xC(4) = xC(1);
            xC(2) = min(xC(2), maxCT); xC(3) = xC(2);
            set(hContrastWin(winIdx).C, 'xdata', xC);

            xL(2) = xC(1);        xL(3) = xL(2);
            xL(1) = xL(2)-xW.L;        xL(4) = xL(1);
            set(hContrastWin(winIdx).L, 'xdata', xL);

            xR(1) = xC(2); xR(4) = xR(1);
            xR(2) = xR(1)+xW.R;        xR(3) = xR(2);
            set(hContrastWin(winIdx).R, 'xdata', xR);
            
        end
        
        pt1 = get(hC, 'CurrentPoint');
        
        In = mat2gray(II{winIdx}, [xC(1) xC(2)]);
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