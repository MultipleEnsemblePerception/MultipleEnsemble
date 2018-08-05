
clear all;
close all;
clc;
rng('shuffle');
 
cd('./Participant_Data');
files = dir();
folders = files(4:length(files));
 
all_matrices = cell(length(folders), 1);
 
for i = 1:length(folders)
    name = folders(i).name;
    all_matrices{i} = struct2cell(load(strcat(strcat(name, '/'), 'Results.mat')));
    all_matrices{i} = all_matrices{i}{1, 1};
    
    % Sort all_matrices{i} into categories
    categories = cell(7, 1);
    for r = 2:2:length(all_matrices{i})
        row = cell2mat(all_matrices{i}(r, 1:16));
        aspects = zeros(3, 1);
        for c = 1:3
            if (row(c) ~= 0)
                aspects(c) = 1;
            end
        end
        num_of_questions = sum(aspects);
        if (num_of_questions <= 2)
            for c = 1:3
                if (aspects(c) == 1)
                    categories{c+(num_of_questions-1)*3, 1} = vertcat(categories{c+(num_of_questions-1)*3, 1}, row);
                end
            end
        else
            categories{7, 1} = vertcat(categories{7, 1}, row);
        end
    end
    
    for c = 1:7
        input = categories{c, 1};
        
        for n = 1:10000
            s = size(input);
            data_indices = randsample(s(1), s(1), true);
            bootstrap_samples{i, c, n} = input(data_indices, 1:6);
            
            sigma{i, c, n} = std(bootstrap_samples{i, c, n});
            mu{i, c, n} = mean(abs(bootstrap_samples{i, c, n}));
            MSE{i, c, n} = mean(bootstrap_samples{i, c, n}.^2);
        end
    end
end
 
cd('../');
 
% save('BootSamples.mat', 'bootstrap_samples');
% save('MeanSamples.mat', 'MSE');

% load('BootSamples');
% load('MeanSamples');
 
close all;
 
num_subjects = 4;
 
 
%stores the Actual-Mean Values
featureDiff = cell(num_subjects, 9);
%stores the final normal difference distribution
nDiffDist = cell(4, 3, 3);
%p-values
pvals = cell(4, 3, 3);
 
%func{num_subject, num_category (1:7), num_bootstrap}
%func can be bootstrap_samples/sigma/mu/MSE
func = mu;
 
%use histogram(featureDiff{num_subject, num_category}); to create plots
 
for i = 1:num_subjects
    for j = 1:10000
        %Race with one question
        diff = func{i, 1, j}(:, 4)-func{i, 1, j}(:, 1);
        featureDiff{i, 1} = vertcat(featureDiff{i, 1}, diff);
        %Race with two questions
        diff = func{i, 4, j}(:, 4)-func{i, 4, j}(:, 1);
        featureDiff{i, 4} = vertcat(featureDiff{i, 4}, diff);
        %Race with three questions
        diff = func{i, 7, j}(:, 4)-func{i, 7, j}(:, 1);
        featureDiff{i, 7} = vertcat(featureDiff{i, 7}, diff);
        
        %Gender with one question
        diff = func{i, 2, j}(:, 5)-func{i, 2, j}(:, 2);
        featureDiff{i, 2} = vertcat(featureDiff{i, 2}, diff);
        %Gender with two questions
        diff = func{i, 5, j}(:, 5)-func{i, 5, j}(:, 2);
        featureDiff{i, 5} = vertcat(featureDiff{i, 5}, diff);
        %Gender with three questions
        diff = func{i, 7, j}(:, 5)-func{i, 7, j}(:, 2);
        featureDiff{i, 8} = vertcat(featureDiff{i, 8}, diff);
        
        %Emotion with one question
        diff = func{i, 3, j}(:, 6)-func{i, 3, j}(:, 3);
        featureDiff{i, 3} = vertcat(featureDiff{i, 3}, diff);
        %Emotion with two questions
        diff = func{i, 6, j}(:, 6)-func{i, 6, j}(:, 3);
        featureDiff{i, 6} = vertcat(featureDiff{i, 6}, diff);
        %Emotion with three questions
        diff = func{i, 7, j}(:, 6)-func{i, 7, j}(:, 3);
        featureDiff{i, 9} = vertcat(featureDiff{i, 9}, diff);
    end
    for k = 1:3
        %nDiffDist{num_sub, num_feature, num_dist_comparison}
        nDiffDist{i, k, 1} = sort(featureDiff{i, k+3})-sort(featureDiff{i, k});
        nDiffDist{i, k, 2} = sort(featureDiff{i, k+6})-sort(featureDiff{i, k});
        nDiffDist{i, k, 3} = sort(featureDiff{i, k+6})-sort(featureDiff{i, k+3});
        
        %find and store pvalues
        pvals{i, k, 1} = sum(nDiffDist{i, k, 1}>0)/length(nDiffDist{i, k, 1});
        pvals{i, k, 2} = sum(nDiffDist{i, k, 2}>0)/length(nDiffDist{i, k, 2});
        pvals{i, k, 3} = sum(nDiffDist{i, k, 3}>0)/length(nDiffDist{i, k, 3});
        
        for l = 1:3
            if pvals{i, k, l} > .5
                pvals{i, k, l} = 1 - pvals{i, k, l};
            end
            pvals{i, k, l} = 2*pvals{i, k, l};
        end
    end
end


figure
subplot(3,3,1)
histogram(featureDiff{1, 1});
title('Race1');

subplot(3,3,2)
histogram(featureDiff{1, 2});
title('Gender1');

subplot(3,3,3)
histogram(featureDiff{1, 3});
title('Emotion1');

subplot(3,3,4)
histogram(featureDiff{1, 4});
title('Race2');

subplot(3,3,5)
histogram(featureDiff{1, 5});
title('Gender2');

subplot(3,3,6)
histogram(featureDiff{1, 6});
title('Emotion2');

subplot(3,3,7)
histogram(featureDiff{1, 7});
title('Race3');

subplot(3,3,8)
histogram(featureDiff{1, 8});
title('Gender3');

subplot(3,3,9)
histogram(featureDiff{1, 9});
title('Emotion3');




