function hMenuItem_Patient_Callback(src, evnt)
    hFig_main = ancestor(src, 'Figure');
    data_main = guidata(hFig_main);
    
    mat_ptFolder = fullfile(tempdir, 'RAPID', 'PTFolder.mat');
    
    if isempty(get(data_main.hTable.PL, 'Data'))
        if exist(mat_ptFolder, 'file')
            load(mat_ptFolder)
        else
            fd_data = uigetdir();
            if ~exist(fullfile(tempdir, 'RAPID'), 'dir')
                mkdir(fullfile(tempdir, 'RAPID'));
            end
            save(mat_ptFolder, 'fd_data');
        end
        
        if fd_data ~= 0
            fn = dir(fd_data);
            m = 0;
            for n = 1:length(fn)
                if isstrprop(fn(n).name(1),'digit')
                    m = m+1;
                    ptNo{m} = fn(n).name;
                end
            end
        end
        set(data_main.hTable.PL, 'Data', ptNo'); 
        set(data_main.hTable.PL, 'visible', 'on');
        set(data_main.hMenuItem.Patient, 'checked', 'on');
        set(data_main.hPushbutton.ptSelection, 'visible', 'on');
        set(data_main.hTable.ptInfo, 'visible', 'off');
        
        data_main.fd_data = fd_data;
        guidata(hFig_main, data_main);

        set(hFig_main, 'WindowScrollWheelFcn', []);
    else
        if strcmp(get(data_main.hMenuItem.Patient, 'checked'), 'on')
            set(data_main.hMenuItem.Patient, 'checked', 'off');
            set(data_main.hTable.PL, 'visible', 'off');
            set(data_main.hPushbutton.ptSelection, 'visible', 'off');

            set(hFig_main, 'WindowScrollWheelFcn', @mscb);
        else
            set(data_main.hMenuItem.Patient, 'checked', 'on');
            set(data_main.hTable.PL, 'visible', 'on');
            set(data_main.hPushbutton.ptSelection, 'visible', 'on');
            set(data_main.hTable.ptInfo, 'visible', 'off');
            set(data_main.hTable.SS, 'visible', 'off');
            set(data_main.hMenuItem.CBDate, 'checked', 'off');
            set(data_main.hTable.CBDate, 'visible', 'off');

            set(hFig_main, 'WindowScrollWheelFcn', []);
        end
    end
    
