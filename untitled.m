clear all;
close all;
clc;

try
    Screen('Preference', 'SkipSyncTests', 1);
    [window, rect] = Screen('OpenWindow', 0);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    HideCursor();

    KbName('UnifyKeyNames');
    % Initialize the window dimensions.
    window_w = rect(3);
    window_h = rect(4);

    a = imread('cat thing.jpg'); 
    texture = Screen('MakeTexture', window, uint8(a));
    Screen('DrawTexture',  window, texture);
    Screen('Flip', window);
    [keyIsDown,seconds,keyCode] = KbCheck(-1);
    while keyIsDown ~= 1
        [keyIsDown,seconds,keyCode] = KbCheck(-1);
        if keyCode == 80
            a = imrotate(a, -1);
        end
        if keyCode == 79
            a = imrotate(a, 1);
        end
        texture = Screen('MakeTexture', window, uint8(a));
        WaitSecs(1);
        Screen('DrawTexture',  window, texture);
        Screen('Flip', window);
    end
    Screen('CloseAll');
catch
    Screen('CloseAll');
    rethrow(lasterror);
end
