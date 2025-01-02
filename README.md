A Closed Economy Medium-Scale DSGE Model for Euro Area
Written by Katherine Dai
Contact: kdai@imf.org

Variables/Data setup: 
•	Input: Data US and euro area- update 2024.xlsx
•	Run Construct_data.m to setup and log data extract seven variables
•	Output data.mat

Solve DSGE:
Before run it, please download dynare 6.0 into ur C.Drive
Execute Dynare, command:
>> addpath("C:\dynare\6.0\matlab")
>> cd C:\Users\kdai\Desktop\RStar\DSGE
>> dynare NRI_baseline_euro_area_new
•	Run NRI_baseline_euro_area.mod for Inference (MCMC should take 2 hours)
•	Obtain r star estimates in GeraliNeri_full_sample_results.xlsx.
•	Output GeraliNeri_euro_area_full_sample_results.mat.

Estimation:
Main script: AAA_replicate_all.m
AAA_ReplicationFile1:
•	Input: 'GeraliNeri_euro_area_full_sample_results.mat';
•	Export a table (GeraliNeri_euro_area_full_sample_result.xlsx) of structural parameters: prior and posterior summary statistics. Tab EA_params was appended into excel file.

AAA_ReplicationFile2:
•	Compute Bayesian IRFs; 4 vars (plus gap = Real rate – Real rate flex price econ) resp to 4 shocks: 1) labor-augmenting tech shock 2) preference shock; marginal efficiency of investment shock; 4) risk premium
•	Export a IRFs panel and data into Tab EA_irfs result excel file.

AAA_ReplicationFile3/compute_NR.m:
•	Plot natural interest rate
•	Compute natural interest rate.

Factor Driver:
•	Run read_hist_decomp.m to plot shock decompositions. 
