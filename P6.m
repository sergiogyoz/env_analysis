addpath m_map;
load("PSMSL_GoM.mat")
load("GSIM_GoM.mat")

% GSIM
[min, argmin] = min(LRD(:,2));
t1 = tRD;
Q = MRD(:,argmin);
plot(t1, Q)
grid on
ax = gca;
ax.YAxis.Exponent = 0;
xlabel("Time")
ylabel("Discharge (m3/s)")

% PSMSL
figure()
id = find(N=="GRAND ISLE");
t2 = t;
stage = M(:,32);
plot(t, stage)
grid on
xlabel("Time")
ylabel("stage (mm)")


