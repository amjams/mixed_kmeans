function [theta] = dist_to_center(x,c,input_type,sig,dist_all)

% dist_to_center: computes the the distance between a data point and a
% cluster center

% inputs:
%     x:              a data point
%     c:              a cluster center (structure)
%     input_type:     binary index indicating which attributes are categorical
%     sig:            significance of all attributes in the dataset
%     dist_all:       list of all distances of categorical values
%
% output:
%     theta:  the distance between x and c
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

    

% find indices
cat_idx = find(input_type); 
num_idx = find(~input_type);

% load cluster size
cluster_size = c.cluster_size;

% distance for numerical attributes

% initialize numerical distance to zero
sum_distance_numerical = 0;

% find distance for each numerical attribute and add to sum
for i=1:numel(num_idx)
    d = x(num_idx(i));
    name = strcat('att_',sprintf('%03d',num_idx(i)));
    num_center = c.numerical.(name);
    curr_significance = sig(num_idx(i));
    curr_dist = (curr_significance*(d-num_center))^2;
    sum_distance_numerical = sum_distance_numerical+curr_dist;
end

% display(c)
% initialize categorical distance to zero
sum_distance_categorical = 0;

% find distance for each categorical attribute and add to sum
for i=1:numel(cat_idx)
    % access the current categorical attribute from structure
    name = strcat('att_',sprintf('%03d',cat_idx(i)));
    curr_att = c.categorical.(name);
    
    
    % initialize sum for this categorical attribute
    sum_categorical_current = 0;
    
    % now access values within that attribute in the cluster
    value_names = fieldnames(curr_att);
    
    for j=1:numel(value_names)
        value_in_point = x(cat_idx(i));
        value_in_cluster = curr_att.(value_names{j}).value;
        count_in_cluster = curr_att.(value_names{j}).count;
        
        % find the distance from the list
        sorted_values = sort([value_in_point,value_in_cluster],'ascend');      
        idx_dist = find(dist_all(:,1)==cat_idx(i)&dist_all(:,2)==sorted_values(1)...
            &dist_all(:,3)==sorted_values(2));
        
        % set distance to zero if value is equal to center, compute dist
        % othewise (i.e. only update when different values
        
        if (sorted_values(1) ~= sorted_values(2))
            sum_categorical_current = sum_categorical_current ...
            + (1/cluster_size)*count_in_cluster*dist_all(idx_dist,4);
        end
    end
    sum_distance_categorical = sum_distance_categorical ...
        +(sum_categorical_current)^2;
end

% overall distance    
theta = sum_distance_numerical + sum_distance_categorical;
end

