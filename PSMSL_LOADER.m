% LOAD PSMSL DATA AND SELECT CERTAIN TIDE GAUGE(S)

%% (1) LOAD .MAT FILE FROM FOLDER
load('PSMSL_Full.mat')

si = size(data);
t = [1900:1/12:2022-1/12]'; % Note: start year depends on availability and region

% This is a Matrix M that contains all tide gauges (time,station) from the
% database; Matrix "Flag" contains potential dataflags
M = NaN(length(t),si(2));
Flag = NaN(length(t),si(2));
for i = 1:si(2);
    t1 = data(i).time;
    ts = data(i).height;
    s = find(t1>=datenum('01-Jan-1900')&t1<datenum('01-Jan-2022'));
    if length(s>=0);
        vec = datevec(t1(s(1)));
        num = vec(1,1)+vec(1,2)/12-1/12;
        idx = knnsearch(t,num);
        M(idx:idx+length(s)-1,i) = ts(s);
        Flag(idx:idx+length(s)-1,i) = data(i).dataflag(s); % includes potential data flags
    end
    N{i,1} = data(i).name; % Location Name
    L(i,1) = data(i).longitude; % Geographical Location
    L(i,2) = data(i).latitude; % Geographical Location
    MID(i,1) = data(i).id; % PSMSL ID (required for identification purposes)
end
clearvars -except M N MID L Flag t

save('PSMSL_Matrix_Global.mat')
