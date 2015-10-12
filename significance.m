function [ sig ] = significance(D,idx)
%SIGNIFICANCE: finds the significance of a categorical attribute or a
%discretized version of a numerical attribute

% input:
%   D:   the dataset of all attributes
%   idx: index of the attribute whose significance is to be found
% 
% ouput:
%   sig: the significance of the attribute
%
% 
% Copyright 2015 Ahmad Alsahaf
% Research fellow, Politecnico di Milano
% ahmadalsahaf@gmail.com
%
%
% Please refer to README.txt for bibliographical references on the algorithm.
%
% This file is part of the “mixed_kmeans” package
%
%     MATLAB_ExtraTrees is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     Foobar is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with MATLAB_ExtraTrees_classification.  If not, see <http://www.gnu.org/licenses/>


% number of attributes
m = size(D,2);

% define the attribute, its unique values, and all unique pairs
a = D(:,idx);
unique_a = unique_f(a);
all_pairs = nchoosek(unique_a,2);
num_pairs = size(all_pairs,1);

% the number of all delta distances
num_delta = (m-1)*num_pairs;

% find all deltas and average them
feature_c = 1:m;  feature_c(idx)=[];   %complementary feature set
delta_sum = 0;                         %initialize
for i=1:num_pairs
    curr_pair = all_pairs(i,:); 
    for j=1:(m-1)
        delta = find_max(a,D(:,feature_c(j)),curr_pair(1),curr_pair(2));
        delta_sum = delta_sum + delta;
    end
end
% find average distance, which is the significance
sig = delta_sum/num_delta;

end

