function [ center ] = cluster_center( cluster, input_type )
%CLUSTER_CENTER find cluster centers for mixed attributes

% inputs:
%     cluster:    the members of the cluster
%     input_type: binary index indicating the type of attributes (1 for categorical)
% 
% output:
%     center:     the center of the cluster
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






% intialize a structure variable to save the centers

center = struct;

% cluster dimensions, and numerical and categorical feature indices
[n,m] = size(cluster);
center.cluster_size = n;
cat_idx = find(input_type);
num_idx = find(~input_type);


% find center for each numerical attribute
for i=1:numel(num_idx)
    curr_att = cluster(:,num_idx(i));
    name = strcat('att_',sprintf('%03d',num_idx(i)));
    center.numerical.(name) = mean(curr_att);
end

% find center for each categorical attribute
for i=1:numel(cat_idx)
    curr_att = cluster(:,cat_idx(i));
    name = strcat('att_',sprintf('%03d',cat_idx(i)));
    uniq_curr_att = unique_f(curr_att);
    
    for j=1:numel(uniq_curr_att)
    name_value = strcat('value_',sprintf('%03d',j));    
    curr_value = uniq_curr_att(j);
    count_value = numel(find(curr_att==curr_value));
    center.categorical.(name).(name_value).value = curr_value;
    center.categorical.(name).(name_value).count = count_value;
    end
end
    

end