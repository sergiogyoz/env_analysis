load('PSMSL_Matrix_Global.mat')
lons = [-98, -81.8, -81.8, -84, -98];
lats = [22.5, 22.5,  28,    31,  31];

in = inpolygon(L(:,1), L(:,2), lons, lats);

M = M(:, in);
N = N(in);
MID = MID(in);
Flag = Flag(:, in);
L = L(in,:);
t = t;

clearvars -except M N MID L Flag t
save(pwd + "\Assigment 1\PSMSL_GoM.mat")