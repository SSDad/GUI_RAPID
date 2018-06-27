clear all

%%
load ('testImages')
h = imshowpair(ICB, ICT);
lim1 = 100;
lim2 = 200;
set(h, 'userdata', [lim1 lim2]) 