function [train, test] = splitdata(T, proportion)
    n = height(T);
    rand_indexes = randperm(n) <= n*proportion;
    train = T;%(rand_indexes,:);
    test = T;%(~rand_indexes,:);