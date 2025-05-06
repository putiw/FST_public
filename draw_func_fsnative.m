function draw_func_fsnative(subject,serverDir,valName,roiName,roiColor,roiWidth,fontSize)
% draw_func_fsnative(subject,serverDir,valName,roiName,roiColor,roiWidth,fontSize)
% Draw functional ROIs in fsnative space
% subject: subject ID
% serverDir: server directory
% valName: value name
% roiName: ROI name
% roiColor: ROI color
% roiWidth: ROI width
% fontSize: font size

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

% draw ROI
cvnlookup(subject,6,vals,[min(vals) max(vals)],jet,[],[],1,{'overlayalpha',vals > min(vals),'roiname',roiName,'roicolor',roiColor,'drawroinames',1,'roiwidth',roiWidth,'fontsize',fontSize}); 