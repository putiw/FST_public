clear all; close all; clc;

% setup path
addpath(genpath(pwd));
projectName = 'FSTLoc';
bidsDir = '~/Desktop/MRI/FSTloc';
serverDir = '/Volumes/Vision/MRI/recon-bank';
githubDir = '~/Documents/GitHub';
fsDir = '/Applications/freesurfer/7.4.1';
addpath(genpath(fullfile(githubDir, 'wpToolbox')));
setup_user(projectName,bidsDir,githubDir,fsDir);

%%
subjects = {'sub-0037','sub-0201','sub-0248','sub-0250','sub-0255','sub-0392','sub-0395','sub-0397','sub-0426'};
whichSub = 7;
subject = subjects{whichSub};
[roi, roil, roir, numl, numr] = get_my_roi(subject,serverDir);
roil{3}(ismember(roil{3},intersect(roil{3},roil{5})))=[];
vals = load_mgz(subject,serverDir,'motion_base/mt+2','cd/cd','transparent/oppo3','T1MapMyelin/myelin0.5','prfvista_mov/vexpl','prfvista_mov/eccen','prfvista_mov/sigma');
%%
% 2D motion
[~, bb, ~, dd] = ttest2(vals(roil{5},1),vals(roil{3},1))

% 3D motion
[~, bb, ~, dd] = ttest2(vals(roil{3},2),vals(roil{5},2))

% MT 2/3D
[~, bb, ~, dd] = ttest2(vals(roil{5},1),vals(roil{5},2))
% FST 2/3D
[~, bb, ~, dd] = ttest2(vals(roil{3},1),vals(roil{3},2))
% MT 2D 3D FST 2D 3D
[~, bb, ~, dd] = ttest(vals(roil{5},1))
[~, bb, ~, dd] = ttest(vals(roil{5},2))
[~, bb, ~, dd] = ttest(vals(roil{3},1))
[~, bb, ~, dd] = ttest(vals(roil{3},2))
% oppo
[~, bb, ~, dd] = ttest2(vals(roil{5},3),vals(roil{3},3))
[~, bb, ~, dd] = ttest(vals(roil{3},3))
[~, bb, ~, dd] = ttest(vals(roil{5},3))

% myelin
[~, bb, ~, dd] = ttest2(vals(roil{5},4),vals(roil{3},4))
[~, bb, ~, dd] = ttest(vals(roil{3},4)- 0.7492)
[~, bb, ~, dd] = ttest(vals(roil{5},4)- 0.7492)
 %%
 close all
% 2D motion
plot_shift(vals(:,1),roil([5 3]));xlim([0.5 2.5]);ylim([0 0.8]);box on;
[prctile(vals(1:numl,1),90) prctile(vals(1:numl,1),99.9)]
plot_shift(vals(:,2),roil([5 3]));xlim([0.5 2.5]);ylim([-0.05 0.5]);box on;
[prctile(vals(1:numl,2),90) prctile(vals(1:numl,2),99.9)]
plot_shift(vals(:,3),roil([5 3]));xlim([0.5 2.5]);ylim([-0.05 0.395]);box on;
[prctile(vals(1:numl,3),90) prctile(vals(1:numl,3),99.9)]
plot_shift(vals(:,4),roil([5 3]));xlim([0.5 2.5]);ylim([0.65 0.98]);box on;
[prctile(vals(1:numl,4),90) prctile(vals(1:numl,4),99.9)]


%%

%%
ttest2(valsl(roil{5},end),valsl(roil{3},end),"Tail","right");

%%
subjects = 'sub-0037';
mycolor = [52, 152, 219 ; 243, 156, 18]./255;

figure(1);clf;hold on;
for ii = 1:numel(subjects)
    plot([1;2],resultMat(ii,:),'-','Color',mycolor(double(resultMat(ii,2)>resultMat(ii,1))+1,:),'LineWidth',2);
end
scatter(ones(numel(subjects),1),resultMat(:,1),50,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'linewidth',1);
scatter(2*ones(numel(subjects),1),resultMat(:,2),50,'o','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 1],'linewidth',1);
set(gca, 'FontSize',15, 'Color', 'w', 'XColor', 'k', 'YColor', 'k','linewidth',2); % 'k' for black, 'w' for white axes

%set(gca, 'FontSize',15, 'Color', 'k', 'XColor', 'w', 'YColor', 'w','linewidth',2); % 'k' for black, 'w' for white axes
xlim([0.5 2.5]);%ylim([-0.05 0.14]);
ylim([0.7 0.9]);
xlabel('');
set(gca, 'TickDir', 'out');
set(gca, 'XTick', [], 'XTickLabel', []);

%%
plot_shift(vals(:,1),roi([5 3]));xlim([0.5 2.5]);ylim([0.6 1]);
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w'); % 'k' for black, 'w' for white axes

%%
plot_shift(vals(:,2),roi([5 3]));xlim([0.5 2.5]);%ylim([0.6 1]);
set(gca, 'Color', 'k', 'XColor', 'w', 'YColor', 'w'); % 'k' for black, 'w' for white axes

%%
%roi = get_my_roi(subject,serverDir);
vals = load_mgz(subject,serverDir,'prfvista_mov/vexpl','prfvista_mov/sigma','prfvista_mov/eccen','cd/cd','motion_base/mt+2','transparent/oppo3');
%view_fv(subject,serverDir,'prfvista_mov/vexpl','prfvista_mov/sigma','prfvista_mov/eccen','cd/cd','motion_base/mt+2','transparent/oppo3');

%vals = load_mgz(subject,serverDir,'prfvista_mov/vexpl','prfvista_mov/sigma','prfvista_mov/eccen','T1MapMyelin/myelin0.5','cd/cd','motion_base/mt+2','transparent/oppo3');

%vals = load_mgz(subject,serverDir,'prfvista_mov/vexpl','prfvista_mov/sigma','prfvista_mov/eccen','T1MapMyelin/myelin0.5','cd/cd','motion_base/mt+2','transparent/oppo3','movbar/sigma','movwedge/sigma','movbar/eccen','movwedge/eccen');
%%
% valsR2 = load_mgz(subject,serverDir,'prfvista_mov/vexpl','movbar/vexpl','movwedge/vexpl'); 
% valsEcc = load_mgz(subject,serverDir,'prfvista_mov/eccen','movbar/eccen','movwedge/eccen');
% valsSig = load_mgz(subject,serverDir,'prfvista_mov/sigma','movbar/sigma','movwedge/sigma');
% %%
% plot_shift(valsR2(:,[2 3]),roi(1));xlim([0.5 2.5]);%ylim([0 30]);
% plot_shift(valsEcc(:,[2 3]),roi(1));xlim([0.5 2.5]);%ylim([0 30]);
% plot_shift(valsSig(:,[2 3]),roi(1));xlim([0.5 2.5]);%ylim([0 30]);

% plot_shift(vals(:,10),roi([1 3]));xlim([0.5 2.5]);ylim([0 30]);
% plot_shift(vals(:,11),roi([1 3]));xlim([0.5 2.5]);ylim([0 30]);
%% param
%% MT has higher R2 than FST
close all
whichSub = 7;
subject = subjects{whichSub};
roi = get_my_roi(subject,serverDir);
vals = load_mgz(subject,serverDir,'prfvista_mov/vexpl','prfvista_mov/sigma','prfvista_mov/eccen','T1MapMyelin/myelin0.5','cd/cd','motion_base/mt+2','transparent/oppo3');
plot_shift(vals(:,5),roi([5 3]));xlim([0.5 2.5]);ylim([prctile(vals(:,5),90) prctile(vals(:,5),99.9)]);box on;
 plot_shift(vals(:,6),roi([5 3]));xlim([0.5 2.5]);ylim([prctile(vals(:,6),90) prctile(vals(:,6),99.9)]);box on;
plot_shift(vals(:,7),roi([5 3]));xlim([0.5 2.5]);ylim([prctile(vals(:,7),90) prctile(vals(:,7),99.9)]);box on;
%%
minval = prctile(vals(:,4),96)-(prctile(vals(:,4),96)-prctile(vals(:,4),50))*4;
maxval = prctile(vals(:,4),96);

plot_shift(vals(:,4),roi([5 3]));xlim([0.5 2.5]);ylim([minval+(maxval-minval)/2 maxval]);box on;

%%

tmpVal = vals(:,3);
tmpVal(tmpVal>12.2) = nan;
tmpVal(vals(:,1)<0.1) = nan;
plot_shift(tmpVal,roi([5 3]));xlim([0.5 2.5]);ylim([0.2 12.2]);box on;set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');
tmpVal = vals(:,2);
tmpVal(vals(:,1)<0) = nan;
plot_shift(tmpVal,roi([5 3]));xlim([0.5 2.5]);set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');box on;
plot_shift(vals(:,1),roi([5 3]));xlim([0.5 2.5]);ylim([0 0.5]);set(gca, 'Color', 'w', 'XColor', 'k', 'YColor', 'k');box on;
%%
% badR2 =  vals(vals(:,1)<0.1,1);
% badR2size = vals(vals(:,1)<0.1,2);
%tmp = convert_pc(vals);
badR2size = vals(vals(:,1)>0.05,2);
histogram(badR2size,20)
