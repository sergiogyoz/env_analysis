%% wavelet calculation
A4P1;
clearvars Qv_fft stage_fft
n_sample = length(t);
highest_frequency = 12;
dt = 1/highest_frequency;

% the wavelet function doc already uses the same parameters
% except for J1 but I trust this choice and also this will
% help avoid cluttering the code
[wave, period, scale, coi] = wavelet(Qv_final, dt);
power = abs(wave).^2 ;

%% testing against white and red noise x_n+1 = alpha*x_n + z_n
% testing H0 of white noise
% default values for alpha = 0 anyway
[signif, fft_theor] = wave_signif(Qv_final, dt, scale);
sig95 = signif' * ones(1,n_sample);
sig95 = power ./ sig95;  % power > sig95 against null H0 (white noise)

%% 
% testing H0 of red noise with alpha = 0.8
alpha = 0.8;  % for red noise spectrum
averaged_ws = sum(power, 2) / n_sample;
% the code + the paper seem to sugest I used n_a as the dof
averaged_signif = wave_signif(Qv_final, dt, scale, ...
                            1, alpha,-1, n_sample);

%% plots
myplotwavelet(t, Qv_final, scale, coi, period, power, ...
              averaged_signif, averaged_ws, sig95)












