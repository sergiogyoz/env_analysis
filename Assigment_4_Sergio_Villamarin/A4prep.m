
load(".\Assigment_4_Sergio_Villamarin\Data_for_Wavelet_Analysis.mat");
% renaming to keep it consistent across my code
stage = SL_GrandIsle;
Qv = MR_Index;
% fill 2 missing values at the end of Qv with a small moving mean 
Qv = fillmissing(Qv,"movmean",5);
clearvars -except t Qv stage;
close all