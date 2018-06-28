function [CBinfo, CB] = loadCB(hFig_main)

data_main = guidata(hFig_main);
ffd = fullfile(data_main.fd_data, data_main.RadoncIDFolder);
ffn_CBinfo = fullfile(ffd, [data_main.RadoncID, '_CBinfo.mat']);
load (ffn_CBinfo)

set(hFig_main, 'pointer', 'watch')
drawnow;

for n = 1:length(CBinfo)
    ffn_CB = fullfile(ffd, [data_main.RadoncID, '_CB_', CBinfo(n).date, '_interp.mat']);
    load(ffn_CB)
    CB(n).MMI = MMI_CB;
    CB(n).ind1 = ind1;
    CB(n).ind2 = ind2;  
    
    CB(n).Lim = double([min(CB(n).MMI(:)) max(CB(n).MMI(:))]); 
        
end
set(hFig_main, 'pointer', 'arrow')