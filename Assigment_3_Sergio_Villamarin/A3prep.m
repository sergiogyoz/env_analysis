load(".\Assigment_3_Sergio_Villamarin\GSIM_MISSISSIPPI_RIVER.mat");
A2P1;
load(".\Assigment_3_Sergio_Villamarin\PSMSL_GoM.mat");
id = find(N=="GRAND ISLE");
stage = M(:,id);
clearvars -except t Qv stage;
close all