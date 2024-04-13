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
histogram(stage_norm(before), 30);
title("stage before the breakpoint");

figure;
histogram(stage_norm(after), 30);
title("stage after the breakpoint");

%% detrending and normal testing for stage (which it passes)
lm_before = fitlm(t(before),stage_norm(before));
stage_res_before = lm_before.Residuals.Raw;

lm_after = fitlm(t(after),stage_norm(after));
stage_res_after = lm_after.Residuals.Raw;

stage_res = cat(1, stage_res_before, stage_res_after);
histogram(stage_res, 15);
[h, p] = adtest(stage_res);

%% normalize residuals again as per request and plot
stage_res_norm = normalize(stage_res);
histogram(stage_res_norm, 19);

%% FFT
stage_fft = fft(stage_res_norm);






