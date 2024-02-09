%% (1) READ GSIM METADATA FROM CSV-FILE AS TABLE AND EXTRACT BASIC
% INFORMATION

T = readtable(gsim_metadata,VariableNamingRule="preserve"); % Please ensure that this path corresponds to the directory on your computer

% Metadata in common MATLAB format
LRD = table2array(T(:,[12 11])); % Longitude/Latitude Information
NRD = table2array(T(:,8)); % Gauge Names
MRDID = table2array(T(:,1)); % Gauge IDs in GSIM
ARD = table2array(T(:,14)); % Drainage Area 

%% (2) LOAD THE RESPECTIVE RIVER DISCHARGE INDICES AND STORE THEM IN A 
% STRUCTURE ARRAY

for i = 1:size(LRD,1);
%     progressbar(i/size(LRD,1));
    dataRD(i).longitude = LRD(i,1);
    dataRD(i).latitude = LRD(i,2);
    dataRD(i).ID = MRDID{i,1};
    dataRD(i).ARD = ARD(i,1);

    % Load indices
    Path1 = gsim_indices; % Please ensure that this path corresponds to the directory on your computer
    [ AF ] = READ_RiverDischarge( MRDID{i,1}, Path1 );
    dataRD(i).time = table2array(AF(:,1));
    dataRD(i).height = table2array(AF(:,2));
    dataRD(i).stdv = table2array(AF(:,3));
end

save('GSIM_Full.mat','dataRD')

%% (3) TRANSFORM DATA INTO COMMON MATRIX FROM 1900 TO 2021

si = size(dataRD);
tRD = [1900:1/12:2021.99]';
MRD = NaN(numel(tRD),si(2));
for i = 1:si(2);
%     progressbar(i/si(2))
    t1 = datenum(dataRD(i).time);
    ts = dataRD(i).height;
    s = find(t1>=datenum('01-Jan-1900')&t1<datenum('01-Jan-2022'));
    if length(s>=0);
        vec = datevec(t1(s(1)));
        num = vec(1,1)+vec(1,2)/12-1/12;
        idx = knnsearch(tRD,num);
        MRD(idx:idx+length(s)-1,i) = ts(s);
    end
end

save('GSIM_Matrix_Global.mat','MRD','MRDID','NRD','tRD','LRD','ARD')

