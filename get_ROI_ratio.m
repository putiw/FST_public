function [ratio, ratio_lh, ratio_rh] = get_ROI_ratio(subject,serverDir,valName,roiName)
% get_ROI_ratio(subject,serverDir,valName,roiName)
% Calculate ratio between functional ROIs
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

% calculate ratio
ratio = zeros(numel(roi),numel(roi));
ratio_lh = zeros(numel(roil),numel(roil));
ratio_rh = zeros(numel(roir),numel(roir));

for ii = 1:numel(roi)
    for jj = 1:numel(roi)
        ratio(ii,jj) = mean(vals(roi{ii})) / mean(vals(roi{jj}));
    end
end

for ii = 1:numel(roil)
    for jj = 1:numel(roil)
        ratio_lh(ii,jj) = mean(vals(roil{ii})) / mean(vals(roil{jj}));
    end
end

for ii = 1:numel(roir)
    for jj = 1:numel(roir)
        ratio_rh(ii,jj) = mean(vals(roir{ii})) / mean(vals(roir{jj}));
    end
end 