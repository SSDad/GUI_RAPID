function [points, A] = fun_tumorSegmentation(I_CB, x0, y0)

points = [];
A = NaN;

I_CB = uint16(I_CB);

level = graythresh(I_CB);
level = level*1.5;
BW = im2bw(I_CB, level);

BD = bwboundaries(BW);

for iB = 1:length(BD)
    pts = BD{iB};
    if inpolygon(x0, y0, pts(:,1), pts(:,2))
        points = pts;
        A = polyarea(pts(:,1), pts(:,2));
        break;
    end
end