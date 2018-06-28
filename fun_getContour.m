function [cont] = fun_getContour(idx, structures, sNames, zz_CT)

cont.name = sNames{idx};
contours = structures(idx).contours;

iS = 0;
for iSC = 1:length(contours)
    segments = contours(iSC).segments;
    z = contours(iSC).z;
    junk = abs(z - zz_CT);
    ict = find(junk < 1e-2);
    if ~isempty(ict)
        cont.data{ict} = segments;
        cont.number(ict) = length(segments);
        iS = iS+1;
        cont.ind(iS) = ict;
        cont.z(iS) = z;
    end
end