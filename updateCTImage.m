function updateCTImage(hFig_main, panelTag, iSlice)

data_main = guidata(hFig_main);
hPlotObj = data_main.hPlotObj;
hText = data_main.hText;
CT = data_main.CT;
if data_main.flag.CBLoaded
    CB = data_main.CB;
end
hAxis = data_main.hAxis;
selected = data_main.selected;

overlay = false;

if strcmp(get(data_main.hMenuItem.CT, 'Checked'), 'on')
    MM = CT.MM;
elseif strcmp(get(data_main.hMenuItem.CB, 'Checked'), 'on')
    MM = CB.MMI(:, :, :, data_main.selected.idxDate);
elseif strcmp(get(data_main.hMenuItem.CTCB, 'Checked'), 'on')
    overlay = true;
    MM = CT.MM;
    MMI = CB.MMI(:, :, :, data_main.selected.idxDate);
    CBLim = [double(CB.minI(selected.idxDate)) double(CB.maxI(selected.idxDate))];
end

switch panelTag
    case '1'
        if overlay
            ICB_z = MMI(:,:,iSlice);
            ICBn_z = mat2gray(ICB_z, CBLim);
            
            ICT_z = MM(:,:,iSlice);
            ICTn_z = mat2gray(ICT_z, CT.Lim);

            CLimAll = get(hPlotObj.CT(1), 'userdata');

            III_z(:,:,1) = mat2gray(ICTn_z, CLimAll(1:2));
            III_z(:,:,2) = mat2gray(ICBn_z, CLimAll(3:4));
            III_z(:,:,3) = III_z(:,:,1);
            set(hPlotObj.CT(1), 'CData', III_z); 
        else
            I = MM(:, :, iSlice);
            set(hPlotObj.CT(1), 'CData', I); 
        end

        iz = size(MM, 3) - iSlice +1;
        set(hPlotObj.CrossLine.z,  'YData', [CT.zz(iz), CT.zz(iz)]);

        set(hText.CT(1), 'String', ['Axial slice: ', num2str(iSlice-1)])
        set(hText.CTcm(1), 'String', ['Y: ', num2str((CT.zz(iSlice)-0)/10, '%5.2f'), ' cm'])

    case '2'
        if overlay
            ICB_x = rot90(squeeze(MMI(:, iSlice, :)));
            ICBn_x = mat2gray(ICB_x, CBLim);
            
            ICT_x = rot90(squeeze(MM(:, iSlice, :)));
            ICTn_x = mat2gray(ICT_x, CT.Lim);

            CLimAll = get(hPlotObj.CT(1), 'userdata');
            III_x(:,:,1) = mat2gray(ICTn_x, CLimAll(1:2));
            III_x(:,:,2) = mat2gray(ICBn_x, CLimAll(3:4));
            III_x(:,:,3) = III_x(:,:,1);
            set(hPlotObj.CT(2), 'CData', III_x); 
        else
            I = rot90(squeeze(MM(:, iSlice, :)));
            set(hPlotObj.CT(2), 'CData', I); 
        end

        ix = iSlice;
        set(hPlotObj.CrossLine.x,  'XData', [CT.xx(ix), CT.xx(ix)]);

        set(hText.CT(2), 'String', ['Sagittal slice: ', num2str(iSlice-1)])
        set(hText.CTcm(2), 'String', ['X: ', num2str((CT.xx(iSlice)-0)/10, '%5.2f'), ' cm'])
    
    case '3'
        if overlay
            ICB_y = rot90(squeeze(MMI(iSlice, :, :)));
            ICBn_y = mat2gray(ICB_y, CBLim);
            
            
            ICT_y = rot90(squeeze(MM(iSlice, :, :)));
            ICTn_y = mat2gray(ICT_y, CT.Lim);
            
            CLimAll = get(hPlotObj.CT(1), 'userdata');

            III_y(:,:,1) = mat2gray(ICTn_y, CLimAll(1:2));
            III_y(:,:,2) = mat2gray(ICBn_y, CLimAll(3:4));
            III_y(:,:,3) = III_y(:,:,1);
            set(hPlotObj.CT(3), 'CData', III_y); 
        else
            I = rot90(squeeze(MM(iSlice, :, :)));
            set(hPlotObj.CT(3), 'CData', I); 
        end

        iy = iSlice;
        set(hPlotObj.CrossLine.y(1),  'YData', [CT.yy(iy), CT.yy(iy)]);
        set(hPlotObj.CrossLine.y(2),  'XData', [CT.yy(iy), CT.yy(iy)]);

        set(hText.CT(3), 'String', ['Coronal slice: ', num2str(iSlice-1)])
        set(hText.CTcm(3), 'String', ['Z: ', num2str((-CT.yy(iSlice)-0)/10, '%5.2f'), ' cm'])
    
end

if overlay
    hCC(1) = hAxis.contrast1;
    hCC(2) = hAxis.contrast2;

    jCB = MMI(:,:,selected.iSlice.z);
    jCT = MM(:,:,selected.iSlice.z);
    IIO(1).CBn = mat2gray(jCB, CBLim);
    IIO(1).CTn = mat2gray(jCT, CT.Lim);
    
     jCB = rot90(squeeze(MMI(:, selected.iSlice.x, :)));
     jCT = rot90(squeeze(MM(:, selected.iSlice.x, :)));
     IIO(2).CBn = mat2gray(jCB, CBLim);
     IIO(2).CTn = mat2gray(jCT, CT.Lim);

     jCB = rot90(squeeze(MMI(selected.iSlice.y, :, :)));
     jCT = rot90(squeeze(MM(selected.iSlice.y, :, :)));
     IIO(3).CBn = mat2gray(jCB, CBLim);
     IIO(3).CTn = mat2gray(jCT, CT.Lim);

    showContrast2_MV(hFig_main, hPlotObj.CT, hCC, IIO)
else
end
