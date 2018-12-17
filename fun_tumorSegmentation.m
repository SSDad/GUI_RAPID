function [BWO, points] = fun_tumorSegmentation(I_CB, pointsOnSlice, ITViP)

%% detected mask
I_CB = uint16(I_CB);
[M, N] = size(I_CB);
% level = graythresh(I_CB);
level = 500/2^16;
BW = imbinarize(I_CB, level);

%% structure mask
BWSS = zeros(size(I_CB));
for n = 1:length(pointsOnSlice)
    pts = pointsOnSlice{n};
    BWS{n} = poly2mask(pts(:,1), pts(:,2), M, N);
    BWSS = or(BWSS, BWS{n});
end

%% overlap
BWO = and(BWSS, BW);
BD = bwboundaries(BWO);
points = [];

for iB = 1:length(BD)
    points = [points; BD{iB}];
end

%     cent = mean(ITViP{n});  % ITV centroid inside tumor
%     if inpolygon(cent(1), cent(2), pts(:,1), pts(:,2))
%         points = pts;
%         break;
%     end
