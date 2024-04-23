%% cross wavelet transform and coherence
A4P1;
clearvars Qv_fft stage_fft
%% params
dj = 0.25;
max_scale = 8;
j1 = 1;
%%
figure('color',[1 1 1])
tiledlayout(2,2,'TileSpacing','compact');
nexttile([1,2]);
xwt([t Qv_final],[t stage_final], "Dj", dj, "J1", j1)
%%
nexttile([1,2]);
wtc(Qv_final,stage_final, "Dj", dj, "MaxScale", max_scale)  