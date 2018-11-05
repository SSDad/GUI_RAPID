function [jh_u16] = fun_imgJH(I, J, maxV, nib)

% I, J - integer image, min is 0
% maxV - max intensity for joint histogram
% jh - joint histogram, square matrix, size maxV+1 by maxV+1 if nib = 1;

maxV = double(maxV);
if nib == 1
    binEdges = -0.5:1:maxV-0.5; 
else
    binEdges = 1:nib:maxV;
end
jh = histcounts2(I, J, binEdges, binEdges);
jh_u16 = uint16(jh);