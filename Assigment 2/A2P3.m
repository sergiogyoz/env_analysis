load(pwd + "\Assigment 2\PSMSL_GoM.mat")
id = find(N=="GRAND ISLE");
stage = M(:,id);

years = 1900:2021;
months = 1:12;
% store means ...
annual_stage = nan * years;
for year = 1:length(years)
    miss_months = sum(isnan(stage(months)));
    % ... if no more than 3 months missing
    if miss_months<=3
        annual_stage(year) = mean(stage(months),"omitnan");
    end
    months = months + 12;
end

% fit linear regression to the annual
reg_sta = fitlm(years,annual_stage);
figure;
% and plot with the confidence interval
plot(reg_sta)
title("GRAND ISLE")
xlabel("Time")
ylabel("stage (m)")

clearvars id miss_months months year
