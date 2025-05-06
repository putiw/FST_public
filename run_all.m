clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '~/Documents/MRI/bigbids';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,bidsDir,githubDir,fsDir);
if ~isfolder('/Volumes/Vision/MRI/recon-bank')
system(['open smb://pw1246@it-nfs.abudhabi.nyu.edu/Vision']);
pause(5)
end
dataLog = readtable(['/Volumes/Vision/MRI/recon-bank/code/dataLog.xlsx']);

sub = 'sub-0250';
space = 'fsnative';

tmp = strsplit(sub, '-');
fsSubDir = '~/Documents/MRI/bigbids/derivatives/freesurfer';

subfolder = dir(sprintf('%s/*%s*',fsSubDir,tmp{2})); % in freesurfer folder check for any subject folder matches our subject ID
subfolderName = subfolder([subfolder.isdir]).name; % get the folder name 
fspth = sprintf('%s/%s',fsSubDir,subfolderName); % build the path for subject directory
switch space
    case 'fsnative'
        spaceMap = subfolderName;
    otherwise
        spaceMap = space;
end

lcurv = read_curv(fullfile(fspth, 'surf', 'lh.curv'));
rcurv = read_curv(fullfile(fspth, 'surf', 'rh.curv'));
leftidx  = 1:numel(lcurv);
rightidx = (1:numel(rcurv))+numel(lcurv);
bidsDir = '/Volumes/Vision/MRI/recon-bank';
%%
whichTask = 'motion';
whichVersion =2;
matchingRows = dataLog(strcmp(dataLog.subject, sub) & strcmp(dataLog.task, whichTask) & (dataLog.version==whichVersion), :);
datafiles = load_dataLog(matchingRows,space);

[dsm, ds1, ds2, myNoise] = load_dsm(matchingRows);

%%
[data, betas, R2] = get_beta(datafiles,dsm,myNoise);

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
        if whichVersion == 2 % middle fixation
            moving = (cw+ccw+in+out)/4;
            cwccw = (cw+ccw)/2;
            inout = (in+out)/2;
            resultsdir = [bidsDir '/derivatives/motion_base/' sub];
        elseif whichVersion == 1 % fixation at top of screen
            lower = (cw+ccw+in+out)/4;
            resultsdir = [bidsDir '/derivatives/motion_meridian/' sub];
        elseif whichVersion == 3  % fixation at bottom of screen
            upper = (cw+ccw+in+out)/4;
            resultsdir = [bidsDir '/derivatives/motion_meridian/' sub];
        end

    case 'transmotion'
        unpair = mean(cell2mat(cellfun(@(x) x(:,1), betas, 'UniformOutput', false)), 2);
        pair = mean(cell2mat(cellfun(@(x) x(:,2), betas, 'UniformOutput', false)), 2);
        oppo = unpair - pair;
        resultsdir = [bidsDir '/derivatives/transparent/' sub];
    case 'cd'
        resultsdir = [bidsDir '/derivatives/cd/' sub];
        valName = 'cd3';
        val0 = [];
        % for whichrun = 1:numel(betas)
        %     tmp =  mean(cell2mat(cellfun(@(x) x(:,1) - x(:,2), betas(whichrun), 'UniformOutput', false)),2);
        %     %val0 = [val0 tmp];
        %     %val = nanmean(val0,2);
        %     val = tmp;
        %     mgz = MRIread(fullfile(fspth, 'mri', 'orig.mgz'));
        %     mgz.vol = [];
        %     mgz.vol = val(leftidx);
        %     MRIwrite(mgz, fullfile(resultsdir, ['lh.' valName '_' num2str(whichrun) 'run.mgz']));
        %     mgz.vol = val(rightidx);
        %     MRIwrite(mgz, fullfile(resultsdir, ['rh.' valName '_' num2str(whichrun) 'run.mgz']));
        % end

         cd2 =  mean(cell2mat(cellfun(@(x) x(:,1) - x(:,2), betas, 'UniformOutput', false)),2);   

        

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
mkdir(resultsdir)
 %% save mgz
val = inout;
valName = 'inout';
%
mgz = MRIread(fullfile(fspth, 'mri', 'orig.mgz'));
mgz.vol = [];
mgz.vol = val(leftidx);
MRIwrite(mgz, fullfile(resultsdir, ['lh.' valName '.mgz']));
mgz.vol = val(rightidx);
MRIwrite(mgz, fullfile(resultsdir, ['rh.' valName '.mgz'])); 