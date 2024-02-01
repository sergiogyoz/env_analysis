addpath m_map;
addpath rlr_monthly;
rlr_directory = pwd + "\rlr_monthly";
disp(rlr_directory)
data = readRlrMonthly(rlr_directory);
PSMSL_LOADER;
gsim_metadata = pwd + "\GSIM_metadata\GSIM_catalog\GSIM_metadata.csv";
disp(gsim_metadata)
gsim_indices = pwd + "\GSIM_indices\TIMESERIES\monthly\";
disp(gsim_indices)
GSIM_LOADER
