%% normalize data to 0 mean and 1 std
Qv_log_norm = normalize(log(Qv));
stage_norm = normalize(stage);

%% plot data and hist
figure;
plot(t, Qv);
title("Discharge at Vicksburg")
figure;
histogram(log(Qv));
title("log discharge Vicksburg")
figure;
histogram(Qv_log_norm);
title("log normalized discharge Vicksburg")
% test for normality of log discharge (which it doesn't terribly fails)
[h_discharge, p_discharge] = adtest(Qv_log_norm);
figure;
plot(t, stage);
title("Stage at Grand isle")
figure;
histogram(stage_norm);
title("normalized Grand Isle")

%% find the breakpoint in the stage data (apparent bimodal stage distribution)
[break_stage, X] = ischange(stage,"linear","MaxNumChanges",1);
breakpoint = find(break_stage);
breaktime = t(breakpoint);

%% split data into the two "almost normal" parts
index = 1:length(t);
before = (index < breakpoint);
after = (index >= breakpoint);

figure;
histogram(stage_norm(before), 15);
title("stage before the breakpoint");

figure;
histogram(stage_norm(after), 15);
title("stage after the breakpoint");

%% detrending and normal testing for stage (which it passes okay)
lm_before = fitlm(t(before),stage_norm(before));
stage_res_before = lm_before.Residuals.Raw;

lm_after = fitlm(t(after),stage_norm(after));
stage_res_after = lm_after.Residuals.Raw;

stage_res = cat(1, stage_res_before, stage_res_after);
figure;
histogram(stage_res, 15);
title("stage residuals")
[h_stage, p_stage] = adtest(stage_res);

%% detrending discharge and re testing normality (this time it passes well)
lm_discharge = fitlm(t,Qv_log_norm);
Qv_res = lm_discharge.Residuals.Raw;
figure;
histogram(stage_res, 15);
title("discharge residuals")
[h_Qv, p_Qv] = adtest(stage_res);

%% normalize residuals again as per request
stage_res = normalize(stage_res);
Qv_res = normalize(Qv_res);

%% FFT of detrended data
stage_res_fft = fft(stage_res);
Qv_res_fft = fft(Qv_res);
highest_frequency = 12;
n_sample = length(t);
frequency = linspace(0,1,n_sample) * highest_frequency;

figure;
plot(frequency, abs(stage_res_fft))
title("detrended stage power spectra")

figure;
plot(frequency, abs(Qv_res_fft))
title("detrended discharge power spectra")

%% Deseasonalizing the time series by removing month averages from each time series
close all
Qv_de = Qv_res;
stage_de = stage_res;
for month = 1:12
    index = 0;
    % create a mask
    mask = false(size(t));
    while(index + month <= length(t))
        mask(index + month) = true;
        index = index + 12;
    end
    % find the mean of every month
    mean_Qv = mean(Qv_res(mask));
    mean_stage = mean(stage_res(mask));
    % remove it from the data
    Qv_de = Qv_de - mask * mean_Qv;
    stage_de = stage_de - mask * mean_stage;
end





