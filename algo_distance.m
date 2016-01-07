function [ d_all ] = algo_distance(D)
%ALGO_DISTANCE 

% Input: 
%   D: dataset with categorical or nominal attributes that have been discretised
% 
% Output:
%   d_all: distance between every pair of attribute values for all attributes
% 
% Copyright 2015 Ahmad Alsahaf
% Research fellow, Politecnico di Milano
% ahmadalsahaf@gmail.com
%
%
% Please refer to README.txt for bibliographical references on the algorithm.
%
% This file is part of the ???mixed_kmeans??? package
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



% data dimenionsality
[~,m] = size(D);

%intialize distance vector; which contains all distances between all pairs
d_all = [];


%if only one feature is clustered (distances are binary)
if m==1
    all_pairs = nchoosek(unique_f(D),2);
    d_all(:,[1 4]) = ones(size(all_pairs,1),2);
    d_all(:,2:3) = all_pairs;
    return
end
    

for i = 1:m
    % define ai, the current attribute
    ai = D(:,i);
    
    % find all pairs of unique values in current feature
    unique_ai = unique_f(ai);
    all_pairs = nchoosek(unique_ai,2);
    
    % find complement feature set
    feat_c = 1:m;  feat_c(i) = [];
    
    for j= 1:size(all_pairs,1)
        % initialize sum and define current pair
        sum_delta = 0;
        curr_pair = all_pairs(j,:);
        
        % find distance between the pair for all Aj
        for k = 1:m-1
            % define aj
            aj = D(:,feat_c(k));
            
            % update the sum
            sum_delta = sum_delta + find_max(ai,aj,curr_pair(1),curr_pair(2));
        end
        % update the distance vector
        sum_delta = sum_delta/(m-1);
        
        % arranged as [attribute_idx,first_value(lower),second_value(higher),distance];
        pair_sorted = sort(curr_pair,'ascend');
        d_all = [d_all; ...
            i,pair_sorted(1),pair_sorted(2),sum_delta];
    end
end



end

