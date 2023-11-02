%% SETUP
clear classes
clear mex
clear all
close all
% clear2 most

fprintf(1,'<strong>BANGLADESH | NIRS statistical learning | starting up...</strong>\n')

% create a new instance of the presenter, name the object 'pres'
pres=ECKPresenter;
keySpace=KbName('Space');
pres.UpdateKeysOnRefresh=true;
pres.DebugMode=true;

% load all fixation and stimuli images - note that all paths to
% individual tasks are set in the presenter - type pres.Paths into the
% console to see what they are, and edit ECKPaths.m to change them.
if ~NIRS_statlearn_loadstimuli(pres), error('Error loading stimuli.'), end

% set display preferences
pres.MonitorNumber=1;
pres.SetFullscreen;

% initialise screens
pres.InitialiseDisplay
pres.BackColour=[0 0 0];
pres.AutoMakeImageTextures
pres.PrepareAllMovies

% create a data tracker
track=ECKTracker('GENERIC');
track.DataRoot = '/users/gatesnirs/Desktop/Stim_scripts/logs';

% create a log file
log=ECKLog;

% connect to serial port to send markers
%portID = '/dev/tty.USA28X145P2.2';
portID = 1;
%portID='/dev/cu.usbserial-FTGWJLBI';
usbPorts=ls('/dev/cu.usbserial-F*');
portID=strtrim(usbPorts(1, :)); % if more than one USB port, take the first one
global markerID
if ~isnumeric(portID) & portID ~= 1
    [markerID, err] = fopen(portID, 'w');
else
    markerID = 1;
end

if exist('err', 'var') && ~isempty(err)
    error('An error was returned whilst connecting to the serial port to send markers. The error was:\n\t"%s"', err);
end

% % connect to titler
% global useTitler
% useTitler = ~isempty(strfind(input('Use titler? (y/n) >', 's'), 'y'));
% if useTitler
%     horitaID = '/dev/tty.USA28X145P1.1';
%     Horita('Open', horitaID);
%     Horita('Clear');
%     Horita('Write', 0, 0, ['ID: ', track.ParticipantID]);
%     Horita('Write', 0, 10, ['Visit: ', num2str(track.TimePoint), 'mo']);
% end

%fprintf('<strong>Press any key to begin tasks.</strong>\n')
%KbWait(-1);

% begin logging session timec
track.StartSession;

%% DESIGN
trials=ECKList;
trials.Name='task list';
trials.Presenter=pres;
trials.Tracker=track;
trials.Log=log;

global trialNum;
trialNum = 1;
%% Set up counterbalance


clipCounter=randi(2);
if clipCounter==1
    trainClip='24';
    testClip='15';
else
    trainClip='15';
    testClip='24';
end

scaleCounter=NIRSstatlearn_counter(track)
testCounter='1';


track.Counterbalance=['train' trainClip 'test' testClip 'scale' scaleCounter 'test' testCounter];

% trials.Table={...
%     'Nested',   'Function'          'VideoFile'                 'SoundType',    'SoundFile',        'VideoMarker';...
%     1,          'NIRS_statlearn_train'    'BiluMela24.mp4'      'TRAIN',      'FamPhaseA.wav',    'T'          ;
%     1,          'NIRS_statlearn_trial'    'BiluMela15Clip1.mp4'       'SILENCE',      '',   'X'             ;
%     1,          'NIRS_statlearn_trial'    'BiluMela15Clip2.mp4'      'TEST',      'lowTPblock_A1.wav',    'L'     ;
%     1,          'NIRS_statlearn_trial'    'BiluMela15Clip3.mp4'     'SILENCE',      '',   'X'           ;
%     1,          'NIRS_statlearn_trial'    'BiluMela15Clip4.mp4'      'TEST',      'noTPblock_A1.wav',    'Z'   ;
%     1,          'NIRS_statlearn_trial'    'BiluMela15Clip5.mp4'      'SILENCE',      '',    'X'   ;
%     1,          'NIRS_statlearn_trial'    'BiluMela15Clip6.mp4'      'TEST',      'highTPblock_A1.wav',    'H'   ;};

%%
numWords=3;
totalWordRep=4;
wordOrder=randperm(3);
allWordOrder=[];
for repInd=1:totalWordRep
    allWordOrder=[allWordOrder wordOrder];
    
    wordOrderNew=randperm(numWords);
    while wordOrderNew(1)==wordOrder(numWords)
        wordOrderNew=randperm(numWords);
    end
    
    wordOrder=wordOrderNew;
    
end

allTestTypes={
    ['lowTPblock_' scaleCounter testCounter '.wav'],    'L'     ;
    ['noTPblock_' scaleCounter testCounter '.wav'],    'Z'   ;
    ['highTPblock_' scaleCounter testCounter '.wav'],    'H'   ;};


trials.Table={...
    'Nested',   'Function'          'VideoFile'                 'SoundType',    'SoundFile',        'VideoMarker';...
    1,          'NIRS_statlearn_train'    ['BiluMela' trainClip '.mp4']       'TRAIN',      ['FamPhase' scaleCounter '.wav'],    'T'          ;
    1,          'NIRS_statlearn_trial'    'BiluMelaTitle1.mp4'                'TEST',      'testBlock1.wav',    'X'     ;
    1,          'NIRS_statlearn_trial'    'BiluMelaTitle2.mp4'                'SILENCE',      '',   'X'           ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip1.mp4']   'TEST',      'testBlock2.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip2.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip3.mp4']   'TEST',      'testBlock3.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip4.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip5.mp4']   'TEST',      'testBlock4.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip6.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip7.mp4']   'TEST',      'testBlock5.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip8.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip9.mp4']   'TEST',      'testBlock6.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip10.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip11.mp4']   'TEST',      'testBlock7.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip12.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip13.mp4']   'TEST',      'testBlock8.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip14.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip15.mp4']   'TEST',      'testBlock9.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip16.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip17.mp4']   'TEST',      'testBlock10.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip18.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip19.mp4']   'TEST',      'testBlock11.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip20.mp4']   'SILENCE',      '',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip21.mp4']   'TEST',      'testBlock12.wav',    'X'   ;
    1,          'NIRS_statlearn_trial'    ['BiluMela' testClip 'Clip22.mp4']   'SILENCE',      '',    'X'   ;};


% overwrite trials table with randomized sound order sound file and marker
trials.Table(3:2:end, 5:6)=allTestTypes(allWordOrder, :);

%%
trials.StartSample=1;
trials.ProgressReportEnabled=true;
trials.ImportVariables({...
    'ParticipantID',...
    'TimePoint',...
    'Counterbalance',...
    'Site'},...
    {track.ParticipantID,...
    track.TimePoint,...
    track.Counterbalance,...
    track.Site});
trials.Start();
track.EndSession;
fprintf(1,'<strong>Ran Version %s </strong>\n', scaleCounter)
log.SaveLogs(track.DataPath);

%% CLEAN UP
pres.CloseDisplay
