clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '~/Desktop/forOSF/test';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,bidsDir,githubDir,fsDir);

% Load data log
dataLog = readtable(['helper/dataLog.xlsx']);

% Subject and space configuration
sub = 'sub-0037';
space = 'fsnative';

tmp = strsplit(sub, '-');
fsSubDir = fullfile(bidsDir,'derivatives/freesurfer');

subfolder = dir(sprintf('%s/*%s*',fsSubDir,tmp{2})); % in freesurfer folder check for any subject folder matches our subject ID
subfolderName = subfolder([subfolder.isdir]).name; % get the folder name
fspth = sprintf('%s/%s',fsSubDir,subfolderName); % build the path for subject directory

switch space
    case 'fsnative'
        spaceMap = subfolderName;
    otherwise
        spaceMap = space;
end

% Task analysis setup
whichTask = 'motion';

matchingRows = dataLog(strcmp(dataLog.subject, sub) & strcmp(dataLog.task, whichTask), :);
datafiles = load_dataLog(matchingRows,space);

[dsm, ds1, ds2, myNoise] = load_dsm(matchingRows);

% Get beta values
[data, betas, R2] = get_beta(datafiles,dsm,myNoise);

% Process task-specific data
switch whichTask
    case 'hand'
        hand1 = mean(cell2mat(cellfun(@(x) x(:,1), betas, 'UniformOutput', false)), 2);
        hand2 = mean(cell2mat(cellfun(@(x) x(:,2), betas, 'UniformOutput', false)), 2);
        hand = hand1-hand2;
        handrun = cellfun(@(x) x(:,1) - x(:,2), betas, 'UniformOutput', false);
        resultsdir = [bidsDir '/derivatives/hand/' sub];

    case 'motion'
        whichrun = 1:size(betas,2);
        out = mean(cell2mat(cellfun(@(x) x(:,1) - x(:,5), betas(whichrun), 'UniformOutput', false)), 2);
        in = mean(cell2mat(cellfun(@(x) x(:,2) - x(:,5), betas(whichrun), 'UniformOutput', false)), 2);
        cw = mean(cell2mat(cellfun(@(x) x(:,3) - x(:,5), betas(whichrun), 'UniformOutput', false)), 2);
        ccw = mean(cell2mat(cellfun(@(x) x(:,4) - x(:,5), betas(whichrun), 'UniformOutput', false)), 2);
        static = mean(cell2mat(cellfun(@(x) x(:,5), betas(whichrun), 'UniformOutput', false)), 2);
        moving = (cw+ccw+in+out)/4;
        cwccw = (cw+ccw)/2;
        inout = (in+out)/2;
        resultsdir = [bidsDir '/derivatives/motion_base/' sub];

    case 'transmotion'
        unpair = mean(cell2mat(cellfun(@(x) x(:,1), betas, 'UniformOutput', false)), 2);
        pair = mean(cell2mat(cellfun(@(x) x(:,2), betas, 'UniformOutput', false)), 2);
        oppo = unpair - pair;
        resultsdir = [bidsDir '/derivatives/transparent/' sub];

    case 'cd'
        cd2 =  mean(cell2mat(cellfun(@(x) x(:,1) - x(:,2), betas, 'UniformOutput', false)),2);
        resultsdir = [bidsDir '/derivatives/cd/' sub];

    case 'loc'
        mt = (betas{1}(:,1)+betas{5}(:,1))./2-(betas{1}(:,2)+betas{5}(:,2))./2;
        mstl = (betas{2}(:,1)+betas{6}(:,1))./2-(betas{2}(:,2)+betas{6}(:,2))./2;
        mstr = (betas{3}(:,1)+betas{7}(:,1))./2-(betas{3}(:,2)+betas{7}(:,2))./2;
        fst = (betas{4}(:,1)+betas{8}(:,1))./2-(betas{4}(:,2)+betas{8}(:,2))./2;
        resultsdir = [bidsDir '/derivatives/loc_old/' sub];

    case 'biomotion'
        bio1 = mean(cell2mat(cellfun(@(x) x(:,1) - x(:,2), betas, 'UniformOutput', false)),2);
        resultsdir = [bidsDir '/derivatives/biomotion/' sub];
end

%% Save results as mgz files 
% mkdir(resultsdir)
% val = inout;
% valName = 'inout';
% lcurv = read_curv(fullfile(fspth, 'surf', 'lh.curv'));
% rcurv = read_curv(fullfile(fspth, 'surf', 'rh.curv'));
% leftidx  = 1:numel(lcurv);
% rightidx = (1:numel(rcurv))+numel(lcurv);
% mgz = MRIread(fullfile(fspth, 'mri', 'orig.mgz'));
% mgz.vol = [];
% mgz.vol = val(leftidx);
% MRIwrite(mgz, fullfile(resultsdir, ['lh.' valName '.mgz']));
% mgz.vol = val(rightidx);
% MRIwrite(mgz, fullfile(resultsdir, ['rh.' valName '.mgz'])); 