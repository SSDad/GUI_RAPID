function [areaDelta, morphDelta] = fun_getDelta(pointsR, points, M, N)

areaDelta = NaN;
morphDelta = NaN;

P{1} = pointsR;
P{2} = points;
for n = 1:2
    if isempty(P{n})
        return
    else
        BW{n} = poly2mask(P{n}(:,2), P{n}(:,1), M, N);
        A(n) = polyarea(P{n}(:,1), P{n}(:,2));
    end
end

areaDelta = (A(1)-A(2))/A(1);

J1 = xor(BW{1}, BW{2});
J2 = and(BW{1}, BW{2});
if any(J2(:))
    morphDelta = bwarea(J1)/bwarea(J2);
end
