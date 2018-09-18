function [CBinfo, CB] = loadCB(hFig_main)

data_main = guidata(hFig_main);
ffd = fullfile(data_main.fd_data, data_main.RadoncIDFolder);
ffn_CBinfo = fullfile(ffd, [data_main.RadoncID, '_CBinfo.mat']);
load (ffn_CBinfo)

%%%%%%%%%%%%%%%%%%%%
%remove duplicate
c = {CBinfo.date}';
[~, ind] = unique(c, 'stable');  % same hour
CBinfo = CBinfo(ind);

cc = {CBinfo.date}';
nn = 0;
ind_remove = [];
for n = 1:length(cc)-1
    d1 = cc{n};
    d2 = cc{n+1};
    if length(d1)>=8 && strcmp(d1(1:8), d2(1:8))
        h1 = str2num(d1(end-1:end));
        h2 = str2num(d2(end-1:end));
        
        if abs(h2-h1) == 1
            nn = nn+1;
            ind_remove(nn) = n+1;
        end
    end
end
CBinfo(ind_remove) = [];

%%%%%%%%%%%%%%%%%%%%

set(hFig_main, 'pointer', 'watch')
drawnow;

h = waitbar(0, 'Loading Cone Beam...');

for n = 1:length(CBinfo)
    ffn_CB = fullfile(ffd, [data_main.RadoncID, '_CB_', CBinfo(n).date, '_interp.mat']);
    load(ffn_CB)
    CB(n).MMI = MMI_CB;
    CB(n).ind1 = ind1;
    CB(n).ind2 = ind2;  
    
    CB(n).Lim = double([min(CB(n).MMI(:)) max(CB(n).MMI(:))]); 

    waitbar(n/length(CBinfo))
        
end
set(hFig_main, 'pointer', 'arrow')

close(h) 
