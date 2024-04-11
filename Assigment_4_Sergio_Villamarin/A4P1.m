% normalize data to 0 mean and 1 std
Qv_norm = normalize(Qv);
stage_norm = normalize(stage);
% plot data and hist
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
% find the brakpoint in the data (apparent bimodal stage distribution)
[location, X] = ischange(stage,"MaxNumChanges",1);