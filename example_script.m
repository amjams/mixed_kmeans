% This is an example on how to use the "mixed_kmeans" Matlab toolbox with a sample dataset.
% The used dataset is the Heart disease dataset which can be found at:
% https://archive.ics.uci.edu/ml/datasets/Heart+Disease
%
%
% the dataset contains a mix of numerical and categorical variables
% 
% Copyright 2015 Ahmad Alsahaf
% Research fellow, Politecnico di Milano
% ahmadalsahaf@gmail.com
%
%
% Please refer to README.txt for bibliographical references on the algorithm.
%
% This file is part of the ???mixed_kmeans??? package


clear all
close all
clc

% import and define dataset 
x = csvread('Heart.csv',1,0);
data = x(2:end,1:end-1);      %(last column, the output, is left out of the clustering)
output = x(2:end,end);        % the output (2 classes)

% the first row of the csv file contains the input type
% (1: categorical, 0:numerical)
inputType = x(1,1:end-1);

% # of samples and variables
[n m] = size(data);


% clustering parameters
k = 2;
max_iter = 100;

% clustering and evaluating performance

% the performance is evaluated by setting the number of clusters (k) equal to the number of classes 
% in the dependant variable (output) and then checking the overlap between the clustering outcome to the groundtruth
% the performance, p, is computed as the sum of data objects (patients) correctly assigned to one of the classes 
% the average of 10 runs is recorded.

performance_mixed = zeros(1,10);
tic
for i=1:10
    idx = mixedkmeans( data, k, inputType, max_iter );
    idx_inverted = zeros(size(idx));
    idx_inverted(idx == 1) = 2;
    idx_inverted(idx == 2) = 1;
    performance_mixed(i) = (n - min(numel(find(output-idx)),numel(find(output-idx_inverted))))/n;
    display(i)
end
toc
% averaged performance for kmeans_mixed
performance_mixed_mean = mean(performance_mixed);


% To see the effect of adding the categorical features to the clustering,
% we repeat the same experiments with regular kmeans using only the 5
% numerical features in the dataset

data_numerical = x(2:end,~inputType); 


performance_normal = zeros(1,10);
for j=1:10
    idx = kmeans(data, k);
    idx_inverted = zeros(size(idx));
    idx_inverted(idx == 1) = 2;
    idx_inverted(idx == 2) = 1;
    performance_normal(j) = (n-min(numel(find(output-idx)),numel(find(output-idx_inverted))))/n;
    display(j)
end

performance_normal_mean = mean(performance_normal);


display(['Performance of kmeans = ' num2str(performance_normal_mean)])
display(['Performance of mixed_kmeans = ' num2str(performance_mixed_mean)])








