%% Script to demonstrate usage of Aurea
%% Add paths needed by aurea
dirList={'AUREA' 'AureaDemo' 'CardioRespiratory_Analysis'  'CR_Pattern_Scoring' 'METRICS' 'Signal_Processing' 'Utilities'}

P=which('aureaDemo') ;
nDir=length(dirList)'
% restore default paths
for iDir=1:nDir
    P1=strrep(P,'AureaDemo\aureaDemo.m',dirList{iDir})
    addpath(P1);
end

%% Load Demo Data 
load DemoData
%% Compute Metrics 
Fs=50; % Sample rat for raw data 
MetricParams=metricParamInit(Fs);

numCases=length(demoData)
for index=1:numCases
    disp(['Computing metrics for file #' num2str(index)]);
    [MetricsEach{index},MetricMetadataEach{index}]=CardiorespiratoryMetrics(demoData{index}(:,1), ...
        demoData{index}(:,2),demoData{index}(:,3),demoData{index}(:,4),[],MetricParams,false,Fs,true);
end


%% Train aurea using default paramters
AUREA=aurea; % Create aurea object 
% Train AUREA      
        ATP=train(AUREA,MetricsEach);
% Classify
        [ACP, aureaPatterns]=classify(ATP, MetricsEach);
        
%% Aurea patterns is a cell aray of categorial sequences continaing the aurea classifcations for each sample. 
%     Classified data.
%Plot raw data and aurea classifcations for an epoch 
ixCase=1;
ixEpoch=10000;
EpochLen=100;

aureaPlot ( ixCase, ixEpoch, EpochLen, demoData,  aureaPatterns)
streamer(['Epoch start = ' num2str(ixEpoch/Fs)])
