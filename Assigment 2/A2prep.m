%%
load('GSIM_Matrix_Global.mat')
name2find = "MISSISSIPPI RIVER";
mississippi_catchment = strcmp(NRD, 'MISSISSIPPI RIVER');
ind = and((LRD(:,1)<-85),mississippi_catchment);
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

% plot them to make sure they are correct
m_proj('lambert','lat',[20 50],'lon',[-100 -74]);
m_coast('patch',[.9 .9 .9],'edgecolor','none');
m_grid('tickdir','out','yaxislocation','right', 'xaxislocation','top','xlabeldir','end','ticklen',.02);
hold on 

lon = LRD(:,1);
lat = LRD(:,2);
[x,y] = m_ll2xy(lon,lat);
plt = plot(x,y,'*', 'Color','[0 0.5 0]','DisplayName','GSIM');

legend([plt])
clearvars -except ARD LRD MRD MRDID NRD tRD