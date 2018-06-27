function [cont] = fun_getContour(idx, structures, sNames, zz_CT)

cont.name = sNames{idx};
contours = structures(idx).contours;
for iS = 1:length(contours)
    segments = contours(iS).segments;
    cont.z(iS) = contours(iS).z;
    junk = abs(cont.z(iS) - zz_CT);
    ict = find(junk < 1e-2);
    cont.data{ict} = segments;
    cont.number(ict) = length(segments);
    cont.ind(iS) = ict;
end