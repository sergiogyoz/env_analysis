load(pwd + "\Assigment_5_Sergio_Villamarin\box_data" + ...
           "\PSMSL_GoM_VLMcorrected_Assignment5.mat");
load(pwd + "\Assigment_5_Sergio_Villamarin\box_data\GMSL.mat");
% I'll make all the arrays the same size before I start all the analysis
n = length(t);
tGMSL = tGMSL(1:n);
GMSL = GMSL(1:n);

% and maybe sort them by latitude
[~, descend] = sort(L(:,2),"descend");

clearvars -except L GMSL Mc N t descend;