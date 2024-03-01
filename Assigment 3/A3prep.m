load(".\Assigment 2\GSIM_MISSISSIPPI_RIVER.mat");
A2P1;
load(".\Assigment 1\PSMSL_GoM.mat");
id = find(N=="GRAND ISLE");
stage = M(:,id);
clearvars -except t Qv stage;
close all