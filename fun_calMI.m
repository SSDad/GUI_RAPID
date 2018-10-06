function [M] = fun_calMI(jh)

% M - mutual information
% jh - joint histogram, square matrix, size maxV+1 by maxV+1

jhn = jh/sum(jh(:)); % normalized joint histogram
khn = sum(jhn,1); 
ihn = sum(jhn,2);

Hy = - sum(khn.*log2(khn + (khn == 0))); % Entropy of Y
Hx = - sum(ihn.*log2(ihn + (ihn == 0))); % Entropy of X

arg_2 = jhn.*(log2(jhn+(jhn==0)));
h_xy = sum(-arg_2(:)); % joint entropy
M = Hx + Hy - h_xy; % mutual information
