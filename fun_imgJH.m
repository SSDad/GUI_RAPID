function [jh_u16] = fun_imgJH(I, J, maxV)

% I, J - integer image, min is 0
% maxV - max intensity for joint histogram
% M - mutual information
% jh - joint histogram, square matrix, size maxV+1 by maxV+1

maxV = double(maxV);
binEdges = -0.5:1:maxV-0.5;
jh = histcounts2(I, J, binEdges, binEdges);
jh_u16 = uint16(jh);