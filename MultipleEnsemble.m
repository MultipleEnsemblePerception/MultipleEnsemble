
 
%Multiple Ensemble Code
 
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
    
    cd('./UCB_Stimuli');
    image_data = csvread('UCB_Stimuli.csv');
    raw_textures = [];
    
    for i = 1:200
        tmp_bmp = imread([num2str(i) '.png']);
        raw_textures(i) = Screen('MakeTexture', window, uint8(tmp_bmp));
    end
    
    cd('../');
    
    %% Creating Grid Positions
    xStart = window_w*0.25;
    xEnd = window_w*0.75;
    yStart = window_h*(1/3);
    yEnd = window_h*(2/3);
    nRows = 2;
    nCols = 3;
    numSecs = 1;
    h_img = 250;
    w_img = 250;
    
    % enter in your starting and ending coordinates and how many rows and
    % columns you want in your grid pattern
    
    [x,y] = meshgrid(linspace(xStart ,xEnd ,nCols), ...
        linspace(yStart ,yEnd ,nRows));
    % this will output the x & y coordinates in a symmetrical grid pattern
    
    % combining all the positions into one matrix
    xy_rect = [x(:)'-w_img/2; y(:)'-h_img/2; x(:)'+w_img/2; y(:)'+h_img/2];
    
    trial_values = zeros(150,6);
    counter = 1;
    
    experiment_data = [];
    
    enabled_keys = [30 31 32 33 34 35 36 37 38 39];
    DisableKeysForKbCheck(setdiff([1:256], [enabled_keys]));
    
    for num_of_aspects = 1:3
        for trial_num = 1:50
            faces_shown = floor(randperm(200, 6));
            
            avg_values = zeros(1,3);
            for face_number = 1:6
                avg_values(1) = avg_values(1)+image_data(faces_shown(face_number),1);
                avg_values(2) = avg_values(2)+image_data(faces_shown(face_number),2);
                avg_values(3) = avg_values(3)+image_data(faces_shown(face_number),3);
            end
            avg_values(:) = avg_values(:)/6;
            
            trial_values(counter, 1:3) = avg_values(:);
            
            Screen('DrawTextures', window,...
                raw_textures(faces_shown), [], xy_rect);
            Screen('Flip', window);
            WaitSecs(numSecs);
            
            mask_mem = (rand(floor(window_w/4), floor(window_h/4))-1)*255;
            mask_mem = resizem(255.*round(rand(rect(4)/10, rect(3)/10)), [rect(4), rect(3)]);
            mask_mem_Tex = Screen('MakeTexture', window, mask_mem);  % make the mask_memory texture
            Screen('DrawTexture', window, mask_mem_Tex, [], [0, 0, window_w, window_h]); % draw the noise texture
            Screen('Flip',window);
            WaitSecs(numSecs);
            
            aspects_tested = randperm(3);
            aspects_tested = aspects_tested(1:num_of_aspects);
            
            responses = zeros(1, 3);
            
            times = zeros(1, 3);
            
            for aspect_num = 1:length(aspects_tested)
                if (aspects_tested(aspect_num) == 1)
                    Screen('DrawText', window,'What was the average race of the crowd? Rate 1-10 with the number keys (Key 0 is 10). 1 is African American, 10 is Caucasian.',window_h/2-400,window_w/2-300);
                elseif (aspects_tested(aspect_num) == 2)
                    Screen('DrawText', window,'What was the average gender of the crowd? Rate 1-10 with the number keys (Key 0 is 10). 1 is Male, 10 is Female.',window_h/2-400,window_w/2-300);
                elseif (aspects_tested(aspect_num) == 3)
                    Screen('DrawText', window,'What was the average emotion of the crowd? Rate 1-10 with the number keys (Key 0 is 10). 1 is Neutral, 10 is Happy.',window_h/2-400,window_w/2-300);
                end
                Screen('Flip',window);
                t0 = clock;
                key_number = 29;
                KbWait;
                while key_number < 30 || key_number > 39
                    key_number = 29;
                    [keyIsDown,seconds,keyCode] = KbCheck(-1);
                    while key_number <= 39 && keyCode(key_number) == 0
                        key_number = key_number+1;
                    end
                end
                response = key_number-29;
                responses(1, aspects_tested(aspect_num)) = response;
                while keyIsDown == 1
                    [keyIsDown,seconds,keyCode] = KbCheck(-1);
                end
                Screen('Flip',window);
                time = (round(etime(clock,t0) * 1000));
                times(aspects_tested(aspect_num)) = time;
            end
            trial_data = horzcat(horzcat(horzcat(responses, avg_values*9+1), faces_shown), times);
            if (num_of_aspects == 0 && trial_num == 0)
                experiment_data = trial_data;
            else
                experiment_data = vertcat(experiment_data, trial_data);
            end
        end
    end
    cd(strcat(strcat(current,'/Participant_Data/'),nameID));
    save('Results.mat', 'experiment_data');
catch
    Screen('CloseAll');
    rethrow(lasterror);
end
Screen('CloseAll');



