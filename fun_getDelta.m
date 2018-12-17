function [areaDelta, morphDelta] = fun_getDelta(tumorR, tumor, M, N)

areaDelta = NaN;
morphDelta = NaN;

areaDelta = (bwarea(tumor.BWO)-bwarea(tumorR.BWO))/bwarea(tumorR.BWO);

J1 = xor(tumorR.BWO, tumor.BWO);
J2 = and(tumorR.BWO, tumor.BWO);
if any(J2(:))
    morphDelta = bwarea(J1)/bwarea(J2);
end
