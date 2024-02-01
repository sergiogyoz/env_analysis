load('GSIM_Matrix_Global.mat')
name2find = "MISSISSIPPI RIVER";
ind = strcmp(NRD, 'MISSISSIPPI RIVER');

ARD = ARD(ind);
LRD = LRD(ind, :);
MRD = MRD(:,ind);
MRDID =MRDID(ind);
NRD = NRD(ind);
tRD = tRD;

clearvars -except ARD LRD MRD MRDID NRD tRD
save("GSIM_GoM.mat")