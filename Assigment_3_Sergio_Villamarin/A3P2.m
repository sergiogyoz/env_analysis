
%------ Smooth both time series with a 12-months MA filter
%------ Do the same for smoothing windows of 4 and 8 years

windows = [12, 48, 96];
for window = windows
    [~, dis_smooth] = smooth_plot(t, dis_final, window, ...
        "Vicksburg " + num2str(window) + "-month smooth", ...
        "discharge (m^3 /s)");
    
    [~, sta_smooth] = smooth_plot(t, sta_final, window, ...
        "GRAND ISLE" + num2str(window) + "-month smooth", ...
        "stage (m)");
    %------ Calculate correlation coeff between the two time series
    crr = corr_plot(dis_smooth, sta_smooth, window, ...
        num2str(window) + " MA stage vs discharge ", ...
        ["discharge", "stage"]);
end


% smoothing function
function [time, y] = smooth_plot(t, data, window, plot_title, ylab)
    y = smoothdata(data, "movmean", window,"omitmissing");
    % remove end points
    index = 1:numel(t);
    mask = (index>window) & (index<= index(end)-window);
    time = t(mask);
    y = y(mask);
    % plot
    figure();
    plot(time, y);
    title(plot_title);
    xlabel("time");
    ylabel(ylab);
end

% correlation plotting function
function crr = corr_plot(data1, data2, window, plot_title, lab)
    [crr,P,RL,RU] = corrcoef(data1, data2, "Rows", "complete");
    figure()
    scatter(data1, data2)
    title(plot_title)
    xlabel(lab(1))
    ylabel(lab(2))

    disp("------")
    disp(num2str(window) +" month smooth")
    disp("correlation " + num2str(window) + "-month: " + num2str(crr(2)))
    disp("CI bounds [" + num2str(RL(2)) + " , " + num2str(RU(2)) + "]")
    disp("p-value: " + num2str(P(2)))
end

