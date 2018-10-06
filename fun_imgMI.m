function [jh_u16, M] = fun_imgMI(I, J, maxV)

% I, J - integer image, min is 0
% maxV - max intensity for joint histogram
% M - mutual information
% jh - joint histogram, square matrix, size maxV+1 by maxV+1

maxV = double(maxV);
binEdges = -0.5:1:maxV-0.5;
jh = histcounts2(I, J, binEdges, binEdges);
jh_u16 = uint16(jh);

jhn = jh/sum(jh(:)); % normalized joint histogram
khn = sum(jhn,1); 
ihn = sum(jhn,2);

Hy = - sum(khn.*log2(khn + (khn == 0))); % Entropy of Y
Hx = - sum(ihn.*log2(ihn + (ihn == 0))); % Entropy of X

arg_2 = jhn.*(log2(jhn+(jhn==0)));
h_xy = sum(-arg_2(:)); % joint entropy
M = Hx + Hy - h_xy; % mutual information
