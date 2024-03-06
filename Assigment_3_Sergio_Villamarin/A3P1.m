
years = 1900:2021;
months = 1:12;
index = 1:numel(Qv);

%------ Delete all values before 1947 and after 2016
mask = ( (years >= 1947) & (years <= 2016) );
years = years(mask);
mask = ( (index > (1946-1900)*12) & (index <= (2017-1900)*12) );
index = index(mask);
% start with Vicksburg
Qv = Qv(mask);
t = t(mask);
% and now Grand isle
stage = stage(mask);

%------ Linearly detrend both time series. Omit any remaining NaNs
reg_sta = fitlm(t, stage);
reg_dis = fitlm(t, Qv);
det_stage = reg_sta.Residuals.Raw;
det_discharge = reg_dis.Residuals.Raw;

%------ Estimate the mean seasonal cycle... using the monthly averaging
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

%------ Plot the mean seasonal cycle for both
plot(months, sta_m_avg);
title("GRAND ISLE seasonal cycle");
xlabel("Month");
ylabel("stage (m)");
[M, I] = min(sta_m_avg);
disp("min stage: " + num2str(M) + " at: " + num2str(I));
[M, I] = max(sta_m_avg);
disp("max stage: " + num2str(M) + " at: " + num2str(I));

figure();
plot(months, dis_m_avg);
title("Vicksburg seasonal cycle");
xlabel("Month");
ylabel("discharge (m^3 /s)");
[M, I] = min(dis_m_avg);
disp("min discharge: " + num2str(M) + " at: " + num2str(I));
[M, I] = max(dis_m_avg);
disp("max discharge: " + num2str(M) + " at: " + num2str(I));

%------ Remove the mean seasonal cycle from the two
% find the seasonal signal
sta_season = transpose(index*0);
dis_season = transpose(index*0);
for year = 0:(numel(years)-1)
    sta_season(year*12 + months) = sta_m_avg;
    dis_season(year*12 + months) = dis_m_avg;
end
% remove it from the detrended timeseries
sta_final = det_stage - sta_season;
dis_final = det_discharge - dis_season;

figure();
plot(t, dis_final);
title("Vicksburg detrended/deseasonalized");
xlabel("time");
ylabel("discharge (m^3 /s)");

figure();
plot(t, sta_final);
title("GRAND ISLE detrended/deseasonalized");
xlabel("time");
ylabel("stage (m)");

clearvars -except t sta_final dis_final









