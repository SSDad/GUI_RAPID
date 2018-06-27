function [CB] = loadCB(hFig_main)

data_main = guidata(hFig_main);
ffd = fullfile(data_main.fd_data, data_main.RadoncIDFolder);
ffn_CB = fullfile(ffd, [data_main.RadoncID, '_allCB.mat']);

set(hFig_main, 'pointer', 'watch')
drawnow;

load (ffn_CB)

set(hFig_main, 'pointer', 'arrow')
CB.nCB = size(CB.dateCreated, 1);
CB.Lim = [min(CB.minI) max(CB.maxI)]; 
CB.Lim = double(CB.Lim);

% for n = 1:size(CB.MMI, 4)
%     CB.MMIn(:,:,:,n) = mat2gray(CB.MMI(:,:,:,n), [double(CB.minI(n)) double(CB.maxI(n))]);
% end