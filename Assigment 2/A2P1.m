%%
load('GSIM_Matrix_Global.mat')
name2find = "MISSISSIPPI RIVER";
mississippi_catchment = strcmp(NRD, 'MISSISSIPPI RIVER');
ind = and((LRD(:,1)>85),mississippi_catchment);
%%
ARD = ARD(ind);
LRD = LRD(ind, :);
MRD = MRD(:,ind);
MRDID =MRDID(ind);
NRD = NRD(ind);
tRD = tRD;
%%
clearvars -except ARD LRD MRD MRDID NRD tRD
save(pwd + "\Assigment 2\GSIM_MISSISSIPPI_RIVER.mat")