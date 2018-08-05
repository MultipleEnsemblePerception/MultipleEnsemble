% ZYC36 = [.2699, .1920;.7826, 3.7795*10^-5; .3249, .1130];
% ZYC31 = [-.2655, .1996; -.0798, .7044; -.0348, .8689];
% ZYC26 = [-.1810, .3866;.1887, .3663;.1834, .3801];
% ZYC21 = [.1463, .4852;-.1363, .5159;.2342, .2599];
% ZYC16 = [-.0101, .9619; -.3446, .0916;.4969, .0115];
% ZYC11 = [0.1093, .6030;-.0083, .9685;.2050, .3255];
% 
% final = [vertcat(ZYC11, ZYC21, ZYC31), vertcat(ZYC16, ZYC26, ZYC36)];
% save('final.mat', 'final');

%data(9, 4)
%data(participant, num_questions, num_faces, aspect, R_or_P);
%data(4, 3, 2, 3, 2)

a = load('Participant_Data/AYL.mat');
b = load('Participant_Data/SC.mat');
c = load('Participant_Data/YH.mat');
d = load('Participant_Data/ZYC.mat');

e = {a.rp_values, b.rp_values, c.rp_values, d.rp_values};

data = cell(4, 3, 2, 3, 2);

for i = 1:length(e)
    for j = 1:2
        data{i,1, 1, 1, j}=e{1, i}(1, j);
        data{i,1, 1, 2, j}=e{1, i}(2, j);
        data{i,1, 1, 3, j}=e{1, i}(3, j);
        data{i,2, 1, 1, j}=e{1, i}(4, j);
        data{i,2, 1, 2, j}=e{1, i}(5, j);
        data{i,2, 1, 3, j}=e{1, i}(6, j);
        data{i,3, 1, 1, j}=e{1, i}(7, j);
        data{i,3, 1, 2, j}=e{1, i}(8, j);
        data{i,3, 1, 3, j}=e{1, i}(9, j);
    end
    
    for k = 1:2
        data{i,1, 2, 1, k}=e{1, i}(1, k+2);
        data{i,1, 2, 2, k}=e{1, i}(2, k+2);
        data{i,1, 2, 3, k}=e{1, i}(3, k+2);
        data{i,2, 2, 1, k}=e{1, i}(4, k+2);
        data{i,2, 2, 2, k}=e{1, i}(5, k+2);
        data{i,2, 2, 3, k}=e{1, i}(6, k+2);
        data{i,3, 2, 1, k}=e{1, i}(7, k+2);
        data{i,3, 2, 2, k}=e{1, i}(8, k+2);
        data{i,3, 2, 3, k}=e{1, i}(9, k+2);
    end
end

save('Participant_Data/final.mat', 'data');
    