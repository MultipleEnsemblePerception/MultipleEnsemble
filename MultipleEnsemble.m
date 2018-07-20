% Multiple Ensemble Code
 
% At the start of the experiment, the user will input 
% their initials so we can store data alongside their 
% participants. Then, a window will open. For any given 
% trial, a set of faces will be shown at set spots on 
% the screen for a set amount of time (1s). For the 
% first N trials, we show the faces, then ask for 1 
% aspect (average emotion, gender, or race) of the set. 
% Then, for the next N trials, we ask for 2 aspects of 
% the set, and so on up to M aspects. Thus, the total 
% amount of trials will be N*M. The user will input 
% their response by typing a number 1-10 (key 0 will 
% correspond to 10), where the endpoints on the scale 
% will be told (i.e. african american to caucasian, 
% sad to happy). Sets of 1 face will also be mixed 
% in with larger sets.
 
 
clear all;
close all;
clc;
 
try
    
    % Setup for rest of experiment. 
    int = input('Participant Initial: ', 's');
    nameID = upper(int);
    
    current = pwd();
    
    if ~isfolder(strcat(strcat(current,'/Participant_Data/'),nameID))
        mkdir(strcat(strcat(current,'/Participant_Data/'),nameID));
    end
    
    Screen('Preference', 'SkipSyncTests', 1);
    [window, rect] = Screen('OpenWindow', 0);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    HideCursor();
    window_w = rect(3);
    window_h = rect(4);
    
    KbName('UnifyKeyNames');
    
    
    
catch
    rethrow(lasterror);
    Screen('CloseAll');
end