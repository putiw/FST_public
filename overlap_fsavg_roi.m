function [overlap, overlap_lh, overlap_rh] = overlap_fsavg_roi(subject,serverDir,valName,roiName)
% overlap_fsavg_roi(subject,serverDir,valName,roiName)
% Calculate overlap between functional ROIs in fsaverage space
% subject: subject ID
% serverDir: server directory
% valName: value name
% roiName: ROI name

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '~/Desktop/MRI/FSTloc';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,bidsDir,githubDir,fsDir);

% load data
vals = load_mgz(subject,serverDir,valName);
lcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'lh.curv'));
rcurv = read_curv(fullfile(serverDir,'/derivatives/freesurfer', subject,'surf', 'rh.curv'));
leftidx  = 1:numel(lcurv);
rightidx = (1:numel(rcurv))+numel(lcurv);

% get ROI
[roi, roil, roir, numl, numr] =  get_my_roi(subject,serverDir);

% calculate overlap
overlap = zeros(numel(roi),numel(roi));
overlap_lh = zeros(numel(roil),numel(roil));
overlap_rh = zeros(numel(roir),numel(roir));

for ii = 1:numel(roi)
    for jj = 1:numel(roi)
        overlap(ii,jj) = numel(intersect(roi{ii},roi{jj})) / numel(union(roi{ii},roi{jj}));
    end
end

for ii = 1:numel(roil)
    for jj = 1:numel(roil)
        overlap_lh(ii,jj) = numel(intersect(roil{ii},roil{jj})) / numel(union(roil{ii},roil{jj}));
    end
end

for ii = 1:numel(roir)
    for jj = 1:numel(roir)
        overlap_rh(ii,jj) = numel(intersect(roir{ii},roir{jj})) / numel(union(roir{ii},roir{jj}));
    end
end 