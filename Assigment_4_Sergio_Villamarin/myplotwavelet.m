% not interested in making a nice plot so I will copy
% and paste from the provided code
%------------------------------------------------------ Plotting
function [] = myplotwavelet(time, timeseries, scale, coi, period, power, ...
                            averaged_signif, averaged_ws, sig95, ...
                            num_bins, font_size)
    arguments
        time;
        timeseries;
        scale;
        coi;
        period;
        power;
        averaged_signif;
        averaged_ws;
        sig95;
        num_bins {mustBeInteger} = 15;
        font_size {mustBeInteger} = 16;
    end
    %--- Plot time series
    %subplot('position',[0.1 0.75 0.65 0.2])
    figure;
    tiledlayout(2,3,'TileSpacing','compact');
    nexttile([1,2]);
    plot(time,timeseries,'linewidth',1,'Color','#0072BD');
    set(gca,'XLim',[time(1), time(end)],'FontSize',font_size);
    %xlabel('Time (ms)')
    ylabel('X [a.u.]','FontSize',font_size+2,'Interpreter','latex');
    yl=yline(mean(timeseries),'linewidth',1.5,'linestyle','-');
    yl.Color = [.80 0 .40];
    grid on;
    hold off
    
    % SL Hist
    nexttile
    h1=histogram(timeseries,num_bins,'Normalization','countdensity','Orientation','horizontal');
    set(gca,'FontSize',font_size,'YTickLabel',[]);
    set(h1,'linewidth', .5,'FaceColor','#0072BD','EdgeColor','w','FaceAlpha',.5);
    grid on;
    
    %--- Contour plot wavelet power spectrum
    nexttile([1,2]);
    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
    %contour(time,log2(period),log2(power),log2(levels));  %*** or use 'contourfill'
    imagesc(time,log2(period),log2(power));  %*** uncomment for 'image' plot
    xlabel('Time (year)')
    ylabel('Pseudo-period (years)','FontSize',font_size+2,'Interpreter','latex')
    set(gca,'XLim',[time(1), time(end)],'FontSize',font_size)
    set(gca,'YLim',log2([min(period),max(period)]), ...
	    'YDir','reverse', ...
	    'YTick',log2(Yticks(:)), ...
	    'YTickLabel',Yticks)
    % 95% significance contour, levels at -99 (fake) and 1 (95% signif)
    % hold on
    % contour(time,log2(period),sig95,[-99,1],'k');
    
    hold on
        [~,h] = contour(time,log2(period),sig95,[-99,1],'k');     
        hold on
        set(h,'linewidth',1);    
        hold on;
    % hold on
    % cone-of-influence, anything "below" is dubious
    %plot(time,log2(coi),'k')
        ts = time;
        coi_area = [max(scale) coi max(scale) max(scale)];
        ts_area = [ts(1) ts(:)' ts(end) ts(1)];
        L = plot(ts_area,log2(coi_area),'k'); set(L,'linewidth',.3); hold on
        hatch(L,45,'k','-',5,.3); hold on
        hatch(L,135,'k','-',5,.3); hold on
    
    hold off
    
    %--- Plot global wavelet spectrum
    nexttile;
    plot(averaged_ws,log2(period),'linewidth',1,'Color','#0072BD')
    hold on
    plot(averaged_signif,log2(period),'--')
    hold off
    xlabel('$S_{SL}$ (a.u.$^2$)','FontSize',font_size+2,'Interpreter','latex')
    set(gca,'YLim',log2([min(period),max(period)]), ...
	    'YDir','reverse', ...
	    'YTick',log2(Yticks(:)), ...
	    'YTickLabel','')
    set(gca,'XLim',[0,1.25*max(averaged_ws)],'FontSize',font_size);
    grid on;

end