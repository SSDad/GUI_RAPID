function [mie, jpdf, entrp]=fun_mie(X, Y)
% mutual information estimation 
%   X,Y          : The time series to be analyzed, both column vectors


% joint pdf
uX = length(unique(X));
uY = length(unique(Y));

uX = 50;
uY = 50;

[jpdf, Xedges, Yedges] = histcounts2(X, Y, [uX uY], 'Normalization', 'probability');

% marginal pdf
xpdf = sum(jpdf, 2);  xpdfM = repmat(xpdf, 1, uY);
ypdf = sum(jpdf);  ypdfM = repmat(ypdf, uX, 1);

entrp(1) = -sum(xpdf.*log2(xpdf));
entrp(2) = -sum(ypdf.*log2(ypdf));

ind = jpdf > 0;
mie = sum(jpdf(ind).*log2(jpdf(ind)./(xpdfM(ind).*ypdfM(ind))));