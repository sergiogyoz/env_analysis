Q = transpose(MRD);
Qnew = zeros(size(Q));
nstation = length(MRD(1,:));
newQmean = zeros(nstation,1);
for station = 1:nstation
    t = tRD;
    % compute the log of Q
    Qnew(station,:) = log10(Q(station,:));
    % remove the mean of (log)Q for each time series
    newQmean(station) = mean(Qnew(station,:),"omitnan");
    Qnew(station,:) = Qnew(station,:) - newQmean(station);
end
% compute ensemble average
ensemblemean = zeros(size(t));
for time = 1:length(t)
    ensemblemean(time) = mean(Qnew(:,time),"omitnan");
end
% add individual means to ensemble average
for station = 1:nstation
    Qnew(station,:) = ensemblemean + newQmean(station);
    % and exponentiate
    Qnew(station,:) = power(10,Qnew(station,:));
end
% plot original values
figure;
hold on
grid on
for station = 1:nstation
    plot(t, Q(station,:))
    xlabel("Time")
    ylabel("Discharge (m3/s)")
end
hold off
% plot new transformed values
figure;
hold on
grid on
for station = 1:nstation
    plot(t, Qnew(station,:))
    xlabel("Time")
    ylabel("Discharge (m3/s)")
end
hold off
% keep only Vicksburg station info (southmost)
[min, argmin] = min(LRD(:,2));
Qv = Qnew(argmin,:);
figure;
plot(t,Qv)
title("Vicksburg")
xlabel("Time")
ylabel("Discharge (m3/s)")
clearvars nstation newQmean time station ensemblemean min argmin



