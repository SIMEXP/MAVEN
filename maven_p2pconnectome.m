%% Run p2pconnectme based on a list of seeds
clear all
%% set parameters
run_name =  'rest1';
%% Set the template
files_in.network = '/home/yassinebha/database/cambridge_template/basc_cambridge_sc100.mnc.gz';

%%% Grabbing the results from the NIAK fMRI preprocessing pipeline
opt_g.min_nb_vol = 50;     % The minimum number of volumes for an fMRI dataset to be included. This option is useful when scrubbing is used, and the resulting time series may be too short.
opt_g.min_xcorr_func = 0.5; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of functional images in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.min_xcorr_anat = 0.5; % The minimum xcorr score for an fMRI dataset to be included. This metric is a tool for quality control which assess the quality of non-linear coregistration of the anatomical image in stereotaxic space. Manual inspection of the values during QC is necessary to properly set this threshold.
opt_g.type_files = 'glm_connectome'; % Specify to the grabber to prepare the files for the glm_connectome pipeline
% opt_g.exclude_subject = {};
opt_g.filter.session = {'session1'}; 
opt_g.filter.run = {run_name}; 

files_in.fmri = niak_grab_fmri_preprocess('/media/database6/MAVEN/fmri_preprocess_INKSCAPE_REST_all/',opt_g).fmri; % Replace the folder by the path where the results of the fMRI preprocessing pipeline were stored. 


%% Set the seeds
files_in.seeds = '/media/database6/MAVEN/seeds/maven_seeds_20150216.csv';

%% Options
opt.folder_out = ['/media/database6/MAVEN/qc_connectome/p2pconnectome_' run_name '/']; % Where to store the results
opt.connectome.type = 'Z'; % The type of connectome. See "help niak_brick_connectome" for more info.
% 'S': covariance;
%'R': correlation;
%'Z': Fisher transform of the correlation;
%'U': concentration;
%'P': partial correlation.
opt.connectome.thresh.type = 'sparsity_pos'; % The type of treshold used to binarize the connectome. See "help niak_brick_connectome" for more info.
% 'sparsity': keep a proportion of the largest connection (in absolute value);
% 'sparsity_pos' keep a proportion of the largest connection (positive only)
% 'cut_off' a cut-off on connectivity (in absolute value)
% 'cut_off_pos' a cut-off on connectivity (only positive)
opt.connectome.thresh.param = 0.2; % the parameter of the thresholding. The actual definition depends of THRESH.TYPE:
% 'sparsity' (scalar, default 0.2) percentage of connections
% 'sparsity_pos' (scalar, default 0.2) percentage of connections
% 'cut_off' (scalar, default 0.25) the cut-off
% 'cut_off_pos' (scalar, default 0.25) the cut-off      

%%%%%%%%%%%%
%% Run the pipeline
%%%%%%%%%%%%
opt.flag_test = false; % Put this flag to true to just generate the pipeline without running it. Otherwise the region growing will start.
%opt.psom.max_queued = 10; % Uncomment and change this parameter to set the number of parallel threads used to run the pipeline
[pipeline,opt] = niak_pipeline_connectome(files_in,opt);
