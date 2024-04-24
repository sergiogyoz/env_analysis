%% prep
A5prep;

%% detrend and deseason
Mcl = Mc - GMSL;
Mcldt = detrend(Mcl, "omitmissing");
month_trend = zeros([1 12]);
for month = 1:12
    month_mask = false(size(t));
    month_mask(month:12:end) = true;
    month_mean = mean(Mcldt(month_mask), "omitmissing");
    month_trend(month) = month_mean;
    Mcldt(month_mask) = Mcldt(month_mask) - month_mean;
end

%% checking the plots are actually different and the trend
figure;
plot(1:12, month_trend);
figure;
plot(Mc(:,1))
hold on
plot(Mcl(:,1))
hold on
plot(Mcldt(:,1))
legend("Mc","Mcl", "Mcldt")
hold off

%% plot using the code from the provided script slightly modified
figure;
n = length(N);
v_spacing = 300:300:(n*300);
x_lim = [1945 2025];
y_lim = [0 (n+1)*300];
x_ticks = 1950:20:2010;
ha = tight_subplot(1,4,[.01 .01],[.1 .1],[.1 .1]);
set(ha(1),'visible','off')
axes(ha(2));
col = colormap(turbo(n));

for i = 1:n
    plot(t,detrend(Mc(:,i),'constant','omitnan')+i*300,'Color',col(i,:));
    hold on
end

xlabel('Year','Fontsize',10)
title('Raw','Fontsize',10)
set(ha(2),'XTick',x_ticks,'Xlim',x_lim,'YTick',v_spacing,...
    'YTickLabel',N,'YLim',y_lim,'Layer','top','FontSize',8,'box','off')
axes(ha(3));

for i = 1:n
    plot(t,detrend(Mcl(:,i),'constant','omitnan')+i*300,'Color',col(i,:));
    hold on
end
xlabel('Year','Fontsize',10)
title('GMSL corrected','Fontsize',10)
set(ha(3),'XTick',x_ticks,'Xlim',x_lim,'YTick',v_spacing,...
    "YTickLabel", [], 'YLim',y_lim,'Layer','top','FontSize',8,'box','off')
axes(ha(4));

for i = 1:n
    plot(t,detrend(Mcldt(:,i),'constant','omitnan')+i*300,'Color',col(i,:));
    hold on
end
xlabel('Year','Fontsize',10)
title('GMSL corrected & deseasonalized','Fontsize',10)
set(ha(4),'XTick',x_ticks,'Xlim',x_lim,'YTick',v_spacing,...
    "YTickLabel", [], 'YLim',y_lim,'Layer','top','FontSize',8,'box','off')

%% clear vars for part 2
close all
clearvars -except Mcldt N t descend
