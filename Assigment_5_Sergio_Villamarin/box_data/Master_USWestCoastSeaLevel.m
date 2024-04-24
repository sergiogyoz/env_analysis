%% (1) Load Data
load('USWestCoastTG.mat')
load('GMSL.mat')
load('MEI.mat')

% Plot Locations on Map
figure
m_proj('Miller','lon',[-125 -115],'lat',[32 50]);
m_gshhs_i('patch',[.8 .8 .8],'EdgeColor',[.6 .6 .6]);
hold on
[x1,y1] = m_ll2xy(L(:,1),L(:,2));
scatter(x1,y1,'ko','Markerfacecolor','k')
m_grid('linestyle','none','Fontsize',8);hold on

%% (2) Deseasonalize the sea level data

Mdt = M-GMSL; % remove the nonlinear GMSL (interested only in local variability)
Mds = detrend(Mdt,'omitnan'); % removes linear vertcial land motion effects
for i = 1:12;
    Mds(i:12:end,:) = Mds(i:12:end,:)-nanmean(Mds(i:12:end,:));
end

% Plot all time series before and after corrections with vertical offsets
figure
ha = tight_subplot(1,4,[.01 .01],[.1 .1],[.1 .1]);
set(ha(1),'visible','off')
axes(ha(2));
col = colormap(turbo(size(M,2)));
for i = 1:size(M,2);
    plot(t,detrend(M(:,i),'constant','omitnan')+i*300,'Color',col(i,:));
    hold on
end
xlabel('Year','Fontsize',10)
title('Raw','Fontsize',10)
set(ha(2),'XTick',[1950:20:2010],'Xlim',[1945 2025],'YTick',[300:300:5100],...
    'YTickLabel',N,'YLim',[0 5400],'Layer','top','FontSize',8,'box','off')
axes(ha(3));
col = colormap(turbo(size(M,2)));
for i = 1:size(M,2);
    plot(t,detrend(Mdt(:,i),'constant','omitnan')+i*300,'Color',col(i,:));
    hold on
end
xlabel('Year','Fontsize',10)
title('GMSL corrected','Fontsize',10)
set(ha(3),'XTick',[1950:20:2010],'Xlim',[1945 2025],'YTick',[300:300:5100],...
    'YTickLabel',[],'YLim',[0 5400],'Layer','top','FontSize',8,'box','off',...
    'Ycolor','none')
axes(ha(4));
col = colormap(turbo(size(M,2)));
for i = 1:size(M,2);
    plot(t,detrend(Mds(:,i),'constant','omitnan')+i*300,'Color',col(i,:));
    hold on
end
xlabel('Year','Fontsize',10)
title('GMSL corrected & deseasonalized','Fontsize',10)
set(ha(4),'XTick',[1950:20:2010],'Xlim',[1945 2025],'YTick',[300:300:5100],...
    'YTickLabel',[],'YLim',[0 5400],'Layer','top','FontSize',8,'box','off',...
    'Ycolor','none')


%% (3) Prepare a "virtual station" of variability

SI = nanmean(Mds,2);

% % Plot both time series
figure
ha = tight_subplot(2,1,[.01 .01],[.1 .1],[.1 .1]);
axes(ha(1))
plot(t,SI,'Color',[.6 .6 .6]);
hold on
plot(t,movmean(SI,12),'k','Linewidth',1.5);
ylabel('Sea Level [mm]','Fontsize',12)
xlabel('Year','Fontsize',12)
set(ha(1),'Ylim',[-250 250],'Xlim',[1950 2020],'XTick',[1960:10:2010],...
    'YTick',[-200:100:200],'Layer','top','Box','off','Xaxislocation','top',...
    'Fontsize',10)

axes(ha(2));
plot(t,MEI,'Color',[.6 .6 .6]);
hold on
anomaly(t,movmean(MEI,12),'Linewidth',1.5);
ylabel('MEI [mm]','Fontsize',12)
xlabel('Year','Fontsize',12)
set(ha(2),'Ylim',[-2.5 2.5],'Xlim',[1950 2020],'XTick',[1960:10:2010],...
    'YTick',[-2:2],'Layer','top','Box','off','Fontsize',10)

%% (4) Calculate the correlation coefficient between the Index and the MEI

R = corr(SI,MEI); 

% Significance: von Storch & Zwiers, 1999 Page 148
z = 1/2*log((1+R)/(1-R));
p = 0.05; 
n = length(MEI);
zL = z-norminv(1-p/2)/sqrt(n-3);
zU = z+norminv(1-p/2)/sqrt(n-3);
RL = tanh(zL);
RU = tanh(zU);

% Significance in a Monte-Carlo Simulation with Null Model based on White
% Noise
sim = 10000;
SIMC = normrnd(0,std(SI),n,sim);
MEIMC = normrnd(0,std(MEI),n,sim);
for i = 1:sim;
    KMC(i,1) = corr(SIMC(:,i),MEIMC(:,i));
end
TreshMC = prctile(abs(KMC(:,1)),95); 
pval = sum(abs(KMC(:,1)) > abs(R)) / sim;

% Significance in a Monte-Carlo Simulation with Null Model based on Red
% Noise
[phiSI,aSI,mu2SI]=ar1(SI);
[phiMEI,aMEI,mu2MEI]=ar1(MEI);

% Plot Autocorrelation
figure
subplot(2,2,1)
autocorr(SI,60)
subplot(2,2,2)
autocorr(MEI,60)

SIMCRed = ar1noise(n,sim,phiSI,aSI);
MEIMCRed = ar1noise(n,sim,phiMEI,aMEI);
for i = 1:sim;
    KMC(i,2) = corr(SIMCRed(:,i),MEIMCRed(:,i));
end
TreshMCRed = prctile(abs(KMC(:,2)),95); 
pvalRed = sum(abs(KMC(:,2)) > abs(R)) / sim;

figure
subplot(2,2,1)
histogram(KMC(:,1),20)
ylabel('#','Fontsize',16)
xlabel('R','Fontsize',16)
set(gca,'Fontsize',12)
set(gca,'Fontsize',12,'Ylim',[0 2000],'XLim',[-1 1])
subplot(2,2,2)
histogram(KMC(:,2),20)
ylabel('#','Fontsize',16)
xlabel('R','Fontsize',16)
set(gca,'Fontsize',12)
set(gca,'Fontsize',12,'Ylim',[0 2000],'XLim',[-1 1])

%% (5) Calculate the correlation coefficient between each individual tide 
%      gauge and the MEI

for i = 1:size(Mds,2);
    isn = find(~isnan(Mds(:,i)));
    KTG(i,1) = corr(Mds(isn,i),MEI(isn));
end

% % Plot Correlations on Map
m_proj('Miller','lon',[-125 -115],'lat',[32 50]);
m_gshhs_i('patch',[.8 .8 .8],'EdgeColor',[.6 .6 .6]);
hold on
[x1,y1] = m_ll2xy(L(:,1),L(:,2));
scatter(x1,y1,40,KTG,'filled','Markeredgecolor','k')
caxis([0 .8])
colormap(m_colmap('jet','step',8));
colorbar
m_grid('linestyle','none','Fontsize',8);hold on

% Coherence between individual stations
rTG = corrcoef(Mds,'Rows','pairwise');
SD = nanstd(Mds)';

figure
ha = tight_subplot(2,2,[.01 .01],[.1 .1],[.3 .1]);
axes(ha(1))
imagesc(rTG)
hold on
plot([.5 10.5 10.5 .5 .5],[.5 .5 10.5 10.5 .5],'Color',[0 0 0],'Linewidth',3)
plot([10.5 17.5 17.5 10.5 10.5],[10.5 10.5 17.5 17.5 10.5],'Color',[0 0 0],'Linewidth',3)
caxis([0 1])
colormap(m_colmap('jet','step',8));
set(gca,'Fontsize',8,'YTick',[1:17],'YTicklabel',N,'XTick',[])
colorbar('Location','Southoutside')
axes(ha(2));
plot(SD,flipud([.5:16.5]'),'k','Linewidth',1.5)
set(gca,'Fontsize',8,'YTick',[.5:16.5],'YTicklabel',[],'XTick',[60 80],...
    'xlim',[40 100],'ylim',[0 17])
xlabel('Stdv. [mm]','Fontsize',12)

%% (6) Built two virtual stations that are representative for the two clusters

SIN = nanmean(Mds(:,1:11),2); % North
SIS = nanmean(Mds(:,12:end),2); % South

%% (7) Assess the power and coherency of both indices using Aslak Grinsted's
%      wavelet package

% Continous wavelet transform (CWT)
figure
subplot(2,2,1)
wt([t,SIN])
title('Northern Stations','Fontsize',10)
colormap(m_colmap('jet','step',32));
subplot(2,2,2)
wt([t,SIS])
title('Southern Stations','Fontsize',10)

% Cross wavelet transform (XWT) and Wavelet Coherence (WTC)
figure
subplot(2,2,1)
xwt([t,SIN],[t,SIS])
title('Cross Wavelet Transform','Fontsize',10)
colormap(m_colmap('jet','step',32));
subplot(2,2,2)
wtc([t,SIN],[t,SIS])
title('Wavelet Coherence','Fontsize',10)
colormap(m_colmap('jet','step',32));

% Wavelet coherence with the MEI
figure
subplot(2,2,1)
wtc([t,SIN],[t,MEI])
title('Northern Stations vs MEI','Fontsize',10)
colormap(m_colmap('jet','step',32));
subplot(2,2,2)
wtc([t,SIS],[t,MEI])
title('Southern Stations vs MEI','Fontsize',10)
colormap(m_colmap('jet','step',32));

%% (8) Assess the forcing fields: Inverse Barometer Effect

% Sea Level Pressure
name = 'slp.mon.mean.nc';
ncdisp(name)
tSLP = ncread(name,'time')/24+datenum('01-Jan-1800');
% cross-check covered period
datestr(tSLP([1 end]))
% create datum vector coherent with the other datums in use
tSLP = [1948:1/12:2020+9/12]';
lat = double(ncread(name,'lat'));
lon = double(ncread(name,'lon'));
[lat,lon] = meshgrid(lat,lon);
slp = ncread(name,'slp');
name = 'uwnd.mon.mean.nc';
uwnd = ncread(name,'uwnd');
name = 'vwnd.mon.mean.nc';
vwnd = ncread(name,'vwnd');
s = find(tSLP>=1950&tSLP<2019);
slp = slp(:,:,s);
uwnd = uwnd(:,:,s);
vwnd = vwnd(:,:,s);
% contourf(lon,lat,slp(:,:,1))

% Reshape data to two dimensions
LSLP(:,1) = reshape(lon,size(lon,1)*size(lon,2),1);
LSLP(:,2) = reshape(lat,size(lat,1)*size(lat,2),1);
slp = reshape(slp,size(slp,1)*size(slp,2),size(slp,3));
uwnd = reshape(uwnd,size(uwnd,1)*size(uwnd,2),size(uwnd,3));
vwnd = reshape(vwnd,size(vwnd,1)*size(vwnd,2),size(vwnd,3));
slpds = slp;
uwndds = uwnd;
vwndds = vwnd;
for i = 1:12;
    slpds(:,i:12:end) = slpds(:,i:12:end)-mean(slpds(:,i:12:end),2);
    uwndds(:,i:12:end) = uwndds(:,i:12:end)-mean(uwndds(:,i:12:end),2);
    vwndds(:,i:12:end) = vwndds(:,i:12:end)-mean(vwndds(:,i:12:end),2);
end

% Identify nearest neighbour series
L(L(:,1)<=0,1) = L(L(:,1)<=0,1)+360; %Transform L from [-180;180] to [0;360]
idx = knnsearch(LSLP,L);
MIBE = -9.948*(slpds(idx,:)'-1013.3);
MIBE = MIBE-nanmean(MIBE);
for i = 1:size(Mds,2);
    isn = find(~isnan(Mds(:,i)));
    KIBE(:,i) = corr(detrend(MIBE(isn,i)),detrend(Mds(isn,i)));
end

SINIBE = nanmean(MIBE(:,1:11),2); % North
SISIBE = nanmean(MIBE(:,12:end),2); % South

MRes = Mds-MIBE;
SINRes = SIN-SINIBE;
SISRes = SIS-SISIBE;

% Plot Correlations on Map
figure
subplot(1,2,1)
m_proj('Miller','lon',[235 245],'lat',[32 50]);
m_gshhs_i('patch',[.8 .8 .8],'EdgeColor',[.6 .6 .6]);
hold on
[x1,y1] = m_ll2xy(L(:,1),L(:,2));
scatter(x1,y1,40,KIBE,'filled','Markeredgecolor','k')
caxis([0 1])
colormap(m_colmap('jet','step',10));
colorbar
m_grid('linestyle','none','Fontsize',8);hold on

% Plot the two indices before and after the IBE removal
figure
subplot(2,2,1)
plot(t,SIN);
hold on
plot(t,SIS);
ylabel('Sea Level [mm]','Fontsize',12)
xlabel('Year','Fontsize',12)
title('with IBE','Fontsize',12)
set(gca,'Ylim',[-300 300],'Xlim',[1950 2020],'XTick',[1960:20:2000],...
    'YTick',[-200:100:200],'Layer','top','Box','off','Fontsize',10)
subplot(2,2,2)
plot(t,SINRes);
hold on
plot(t,SISRes);
ylabel('Sea Level [mm]','Fontsize',12)
xlabel('Year','Fontsize',12)
title('without IBE','Fontsize',12)
set(gca,'Ylim',[-300 300],'Xlim',[1950 2020],'XTick',[1960:20:2000],...
    'YTick',[-200:100:200],'Layer','top','Box','off','Fontsize',10)

%% (9) Assess the forcing fields: SLP Gradients and Winds via Correlation

% Correlation with the SLP Field after the removal of the IBE
in = inpolygon(LSLP(:,1),LSLP(:,2),[100 300 300 100 100],[-20 -20 70 70 -20]);
slpds = slpds(in,:);
uwndds = uwndds(in,:);
vwndds = vwndds(in,:);
LSLP = LSLP(in,:);
for i = 1:size(slpds,1);
    progressbar(i/size(slpds,1));
    KSINSLP(i,1) = corr(detrend(SINRes),detrend(slpds(i,:)'));
    KSISSLP(i,1) = corr(detrend(SISRes),detrend(slpds(i,:)'));
    KSINuwnd(i,1) = corr(detrend(SINRes),detrend(uwndds(i,:)'));
    KSISuwnd(i,1) = corr(detrend(SISRes),detrend(uwndds(i,:)'));
    KSINvwnd(i,1) = corr(detrend(SINRes),detrend(vwndds(i,:)'));
    KSISvwnd(i,1) = corr(detrend(SISRes),detrend(vwndds(i,:)'));
end

% Transform 2D vectors back to 3D field
lon1 = reshape(LSLP(:,1),81,37);
lat1 = reshape(LSLP(:,2),81,37);
KSLP(:,:,1) = reshape(KSINSLP(:,1),81,37);
KSLP(:,:,2) = reshape(KSISSLP(:,1),81,37);

figure
subplot(1,2,1)
m_proj('Miller','lon',[100 300],'lat',[-20 70]);
[x1,y1] = m_ll2xy(LSLP(:,1),LSLP(:,2));
m_contourf(lon1,lat1,KSLP(:,:,1),10,'Linestyle','none')
hold on
quiver(x1(1:2:end),y1(1:2:end),KSINuwnd(1:2:end),KSINvwnd(1:2:end),3,'k')
caxis([-.7 .7])
m_coast('patch',[.8 .8 .8],'EdgeColor',[.6 .6 .6]);
[x1,y1] = m_ll2xy(L(:,1),L(:,2));
scatter(x1(1:11),y1(1:11),40,'Markerfacecolor','w','Markeredgecolor','k')
colormap(m_colmap('jet','step',14));
colorbar('Location','Southoutside')
m_grid('linestyle','none','Fontsize',8);hold on
title('Northern Stations','Fontsize',12)
subplot(1,2,2)
m_proj('Miller','lon',[100 300],'lat',[-20 70]);
[x1,y1] = m_ll2xy(LSLP(:,1),LSLP(:,2));
m_contourf(lon1,lat1,KSLP(:,:,2),10,'Linestyle','none')
hold on
quiver(x1(1:2:end),y1(1:2:end),KSISuwnd(1:2:end),KSISvwnd(1:2:end),3,'k')
caxis([-.7 .7])
m_coast('patch',[.8 .8 .8],'EdgeColor',[.6 .6 .6]);
[x1,y1] = m_ll2xy(L(:,1),L(:,2));
scatter(x1(12:end),y1(12:end),40,'Markerfacecolor','w','Markeredgecolor','k')
colormap(m_colmap('jet','step',14));
colorbar('Location','Southoutside')
m_grid('linestyle','none','Fontsize',8);hold on
title('Southern Stations','Fontsize',12)

%% (10) Assess the forcing fields: SLP Gradients and Winds via Composites

spS = find(SINRes>=mean(SISRes)+std(SISRes));
snS = find(SINRes<=mean(SISRes)-std(SISRes));

CompSLPspS = reshape(mean(slpds(:,spS),2),81,37);
CompSLPsnS = reshape(mean(slpds(:,snS),2),81,37);
CompuwndspS = reshape(mean(uwndds(:,spS),2),81,37);
CompuwndsnS = reshape(mean(uwndds(:,snS),2),81,37);
CompvwndspS = reshape(mean(vwndds(:,spS),2),81,37);
CompvwndsnS = reshape(mean(vwndds(:,snS),2),81,37);


ha = tight_subplot(2,2,[.12 .06],[.1 .1],[.1 .1]);
axes(ha(1));
plot(t,SISRes,'k')
hold on
plot([1950 2020],[mean(SISRes)+std(SISRes) mean(SISRes)+std(SISRes)],...
    'Linewidth',1.5,'Linestyle',':','Color',[.85 .33 .1])
plot([1950 2020],[mean(SISRes)-std(SISRes) mean(SISRes)-std(SISRes)],...
    'Linewidth',1.5,'Linestyle',':','Color',[0 .45 .74])
ylabel('Sea Level [mm]','Fontsize',12)
xlabel('Year','Fontsize',12)
set(ha(1),'Ylim',[-250 250],'Xlim',[1950 2020],'XTick',[1960:10:2010],...
    'YTick',[-200:100:200],'Layer','top','Box','off','Xaxislocation','top',...
    'Fontsize',12)
axes(ha(3));
m_proj('Miller','lon',[100 300],'lat',[-20 70]);
[x1,y1] = m_ll2xy(LSLP(:,1),LSLP(:,2));
m_contourf(lon1,lat1,CompSLPspS,10,'Linestyle','none')
hold on
m_quiver(lon1(1:2:end,1:2:end),lat1(1:2:end,1:2:end),CompuwndspS(1:2:end,1:2:end),CompvwndspS(1:2:end,1:2:end),3,'k')
caxis([-5 5])
m_coast('patch',[.8 .8 .8],'EdgeColor',[.6 .6 .6]);
[x1,y1] = m_ll2xy(L(:,1),L(:,2));
scatter(x1(12:end),y1(12:end),40,'Markerfacecolor','w','Markeredgecolor','k')
colormap(m_colmap('jet','step',14));
colorbar('Location','Southoutside')
m_grid('linestyle','none','Fontsize',12);hold on
title('Positive Anomalies','Fontsize',12)
axes(ha(4));
m_proj('Miller','lon',[100 300],'lat',[-20 70]);
[x1,y1] = m_ll2xy(LSLP(:,1),LSLP(:,2));
m_contourf(lon1,lat1,CompSLPsnS,10,'Linestyle','none')
hold on
m_quiver(lon1(1:2:end,1:2:end),lat1(1:2:end,1:2:end),CompuwndsnS(1:2:end,1:2:end),CompvwndsnS(1:2:end,1:2:end),3,'k')
caxis([-5 5])
m_coast('patch',[.8 .8 .8],'EdgeColor',[.6 .6 .6]);
[x1,y1] = m_ll2xy(L(:,1),L(:,2));
scatter(x1(12:end),y1(12:end),40,'Markerfacecolor','w','Markeredgecolor','k')
colormap(m_colmap('jet','step',14));
colorbar('Location','Southoutside')
m_grid('linestyle','none','Fontsize',12);hold on
title('Negative Anomalies','Fontsize',12)