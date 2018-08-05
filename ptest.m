input = load('final.mat');



for n = 1:100
    s = size(input);
    data_indices = randsample(s(1), s(1), true);
    bootstrap_samples{i, c, n} = input(data_indices, 1:6);

    sigma{i, c, n} = std(bootstrap_samples{i, c, n});
    mu{i, c, n} = mean(abs(bootstrap_samples{i, c, n}));
    MSE{i, c, n} = mean(bootstrap_samples{i, c, n}.^2);
end