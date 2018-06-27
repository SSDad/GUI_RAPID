function II = fun_imHistTruncate(I, newLim);

I(I>newLim(2)) = newLim(2);
I(I<newLim(1)) = newLim(1);
II = mat2gray(I);