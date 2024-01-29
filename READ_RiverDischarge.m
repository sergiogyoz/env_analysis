function [ AF ] = READ_RiverDischarge( MRDID, Path1 )

%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: C:\DATA\GSIM_indices\GSIM_indices\TIMESERIES\monthly\AF_0000001.mon
%
% Auto-generated by MATLAB on 09-Aug-2022 09:25:03

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 11);

% Specify range and delimiter
opts.DataLines = [23, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["date", "MEAN", "SD", "CV", "IQR", "MIN", "MAX", "MIN7", "MAX7", "nmissing", "navailable"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "date", "InputFormat", "yyyy-MM-dd");

% Specify path and file

Path = Path1 + MRDID + '.mon';

% Import the data
AF = readtable(string(Path), opts);


%% Clear temporary variables
clear opts

end