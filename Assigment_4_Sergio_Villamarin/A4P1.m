% normalize data to 0 mean and 1 std
Qv_norm = normalize(Qv);
stage_norm = normalize(stage);
%% plot data and hist
figure;
plot(t, Qv);
title("Discharge at Vicksburg")
figure;
plot(t, stage_norm);
title("Stage at Grand isle")
figure;
histogram(Qv_norm);
title("normalized Vicksburg")
figure;
histogram(stage_norm);
title("normalized Grand Isle")
%% find the brakpoint in the stage data (apparent bimodal stage distribution)
[location, X] = ischange(stage,"linear","MaxNumChanges",1);
plot(t,stage)
plot(t,X)
breakpoint = find(location);
breaktime = t(breakpoint);
%% log normal test and transformation of discharge
stage_log = log(stage);
stage_log_norm = normalize(stage_log);
histogram(stage_log_norm,30)




