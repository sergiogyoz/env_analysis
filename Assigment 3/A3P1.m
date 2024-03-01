
years = 1900:2021;
months = 1:12;
index = 1:numel(Qv);

% Delete all values before 1947 and after 2016
mask = ( (years >= 1947) & (years <= 2016) );
years = years(mask);
mask = ( (index >= (1947-1900)*12) & (index < (2017-1900)*12) );
index = index(mask);
% start with Vicksburg
Qv = Qv(mask);
t = t(mask);
% and now Grand isle
stage = stage(mask);


% Linearly detrend both time series. Omit any remaining NaNs
reg_sta = fitlm(t, stage);
reg_dis = fitlm(t, Qv);
det_stage = reg_sta.Residuals.Raw;
det_discharge = reg_dis.Residuals.Raw;

% Estimate the mean seasonal cycle... using the monthly averaging
sta_m_avg = months*0;
dis_m_avg = months*0;
n = numel(index);
index = index*0;

for month = months
    mask = month:12:numel(index);
    
    sta_single_month = nan*index;
    sta_single_month(mask) = det_stage(mask);
    sta_m_avg(month) = mean(sta_single_month, "omitnan");

    dis_single_month = nan*index;
    dis_single_month(mask) = det_discharge(mask);
    dis_m_avg(month) = mean(dis_single_month, "omitnan");
end

% Plot the mean seasonal cycle for both
plot(months, sta_m_avg);
title("GRAND ISLE");
xlabel("Time");
ylabel("stage (m)");
[M, I] = min(sta_m_avg);
disp("min stage: " + num2str(M) + " at: " + num2str(I));
[M, I] = max(sta_m_avg);
disp("max stage: " + num2str(M) + " at: " + num2str(I));

figure();
plot(months, dis_m_avg);
title("Vicksburg");
xlabel("Time");
ylabel("discharge (m^3 /s)");
[M, I] = min(dis_m_avg);
disp("min stage: " + num2str(M) + " at: " + num2str(I));
[M, I] = max(dis_m_avg);
disp("max stage: " + num2str(M) + " at: " + num2str(I));

%clearvars -except t Qv stage

