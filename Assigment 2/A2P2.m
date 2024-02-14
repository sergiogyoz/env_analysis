years = 1900:2021;
months = 1:12;
% store means ...
annual_discharge = nan * years;
for year = 1:length(years)
    miss_months = sum(isnan(Qv(months)));
    % ... if no more than 3 months missing
    if miss_months<=3
        annual_discharge(year) = mean(Qv(months),"omitnan");
    end
    months = months + 12;
end

% fit linear regression to the annual
reg_dis = fitlm(years,annual_discharge);
figure;
% and plot with the confidence interval
plot(reg_dis)
title("Vicksburg")
xlabel("Time")
ylabel("Discharge (m3/s)")

clearvars nstation newQmean time station ensemblemean min argmin
clearvars miss_months months year



