addpath m_map;
load(pwd + "\Assigment 1\PSMSL_GoM.mat")
load(pwd + "\Assigment 1\GSIM_GoM.mat")


m_proj('lambert','lat',[20 50],'lon',[-100 -74]);
m_coast('patch',[.9 .9 .9],'edgecolor','none');
m_grid('tickdir','out','yaxislocation','right', 'xaxislocation','top','xlabeldir','end','ticklen',.02);
hold on 

% PSMSL
lon1 = L(:,1);
lat1 = L(:,2);
[x1,y1] = m_ll2xy(lon1,lat1);
plt1 = plot(x1,y1,'rx','DisplayName','PSMSL');

% GSIM
lon2 = LRD(:,1);
lat2 = LRD(:,2);
[x2,y2] = m_ll2xy(lon2,lat2);
plt2 = plot(x2,y2,'*', 'Color','[0 0.5 0]','DisplayName','GSIM');

% legend
legend([plt1, plt2])