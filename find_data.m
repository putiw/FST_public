% copy_fmriprep_for_osf.m
% Reads an Excel listing subjects/sessions/runs, finds the matching
% fMRIPrep outputs, and copies only those files—preserving the BIDS
% folder structure—for OSF upload.

clear; clc;

%% 1. User‐editable paths
excelFile = '/Users/pw1246/Desktop/forOSF/code/dataLog.xlsx';  % update
targetBase = '/Users/pw1246/Desktop/forOSF';                   % OSF prep folder

%% 2. Read the Excel
T = readtable(excelFile);

% Verify required columns
req = {'subject','task','bids','session','run'};
assert(all(ismember(req, T.Properties.VariableNames)), ...
    'Excel must have columns: %s', strjoin(req,','));

%% 3. Loop over each row
for i = 1:height(T)
    subj   = T.subject{i};       % e.g. 'sub-0037'
    task   = T.task{i};          % e.g. 'cd', 'motion'
    bidsDir= T.bids{i};          % e.g. '/Users/pw1246/Documents/MRI/bigbids'
    ses    = T.session{i};       % e.g. 'ses-01'
    runNum = T.run(i);           % numeric or string
    
    % Build source func directory
    srcFuncDir = fullfile(bidsDir, 'derivatives','fmriprep', subj, ses, 'func');
    if ~exist(srcFuncDir,'dir')
        warning('Missing func directory: %s', srcFuncDir);
        continue;
    end
    
    % Wildcard pattern for run & task
    pattern = sprintf('%s_%s*task-%s_*run-%d*', subj, ses, task, runNum);
    D = dir(fullfile(srcFuncDir, pattern));
    if isempty(D)
        warning('No files for pattern "%s" in %s', pattern, srcFuncDir);
        continue;
    end
    
    % Destination func directory (preserve structure)
    destFuncDir = fullfile(targetBase, 'derivatives','fmriprep', subj, ses, 'func');
    if ~exist(destFuncDir,'dir')
        mkdir(destFuncDir);
    end
    
    % Copy each matched file
    for k = 1:numel(D)
        srcFile = fullfile(D(k).folder, D(k).name);
        destFile= fullfile(destFuncDir, D(k).name);
        copyfile(srcFile, destFile);
    end
end

fprintf('Finished copying %d entries to %s\n', height(T), targetBase);