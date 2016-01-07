function [average_s, all_s , a_and_b] = mixed_silhouette(data, idx, feat_type, dist_all, plot_silhouette)

%MIXED_SILHOUETTE: finds the average silhouette value for a clustering
%problem with mixed features (categorical and continous)
% Input: 
%   data: the inputs to the clustering problem
%   idx:  the output of the clustering problem
%   dist_all: output of function "algo_distance.m"
% 
% Output:
%   average_s: avegare silhouette value for all datpoints
%   all_s:     average of all silhouette values
%
%
% Copyright 2015 Ahmad Alsahaf
% Reseach fellow, Politecnico di Milano
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


% by default, plot the silhouette
if nargin<5
    plot_silhouette = 1;
end

% number of data points
n = size(data,1);

% number of clusters
cluster_names = unique_f(idx);
k = numel(cluster_names);


% numerical and categorical features
feat_cat = find(feat_type == 1);
feat_num = find(feat_type == 0);


% intialize variables
%average_silhouette_by_cluster = zeros(k,1);
a_and_b = zeros(n,k+1);            % for each point, store ai and all bi
all_s = zeros(n,1);                % for each point, store all s 

% for each cluster, find ai, the within cluster dissimilarity
for i=1:k %here
    curr_cluster_idx = find(idx == i);               
    %curr_cluster = data(curr_cluster_idx,:);
    curr_cluster_size = numel(curr_cluster_idx);
    
    % for each datapoint in the current cluster
    for j=1:curr_cluster_size
        curr_point = data(curr_cluster_idx(j),:);     % the current point
        % find average distance to each point within the cluster
        % for each point in the cluster (again)
        for z=1:curr_cluster_size
             second_point = data(curr_cluster_idx(z),:);
             % for each numerial value
             num_feat_sum = 0;
             for jj=1:numel(feat_num)
                num_feat_sum = num_feat_sum + (curr_point(feat_num(jj))-second_point(feat_num(jj)))^2;
             end
             
             % for each categorical value
             cat_feat_sum = 0;
             for jj=1:numel(feat_cat)
                sorted_values = sort([curr_point(feat_cat(jj)),second_point(feat_cat(jj))],'ascend');
                if (sorted_values(1) ~= sorted_values(2))
                    idx_dist = find(dist_all(:,1)==feat_cat(jj)&dist_all(:,2)==sorted_values(1)...
                    &dist_all(:,3)==sorted_values(2));
                    cat_feat_sum = cat_feat_sum + dist_all(idx_dist,4);
                end
             end
             a_and_b(curr_cluster_idx(j),1) = a_and_b(curr_cluster_idx(j),1)+...
                 (num_feat_sum + cat_feat_sum)/curr_cluster_size;
        end
        
        % now find b_i, distances from other clusters
        other_clusters = 1:k;  other_clusters(other_clusters==i) = [];     
        for ii=1:k-1
            second_cluster_idx = find(idx == other_clusters(ii));              
            %second_cluster = data(second_cluster_idx,:);
            second_cluster_size = numel(second_cluster_idx);
            
           % for each datapoint in the second cluster
           for jjj=1:second_cluster_size
               second_point_second_cluster = data(second_cluster_idx(jjj),:);
               
             % for each numerial value
             num_feat_sum = 0;
             for jj=1:numel(feat_num)
                num_feat_sum = num_feat_sum + (curr_point(feat_num(jj))-second_point_second_cluster(feat_num(jj)))^2;
             end
             
             % for each categorical value
             cat_feat_sum = 0;
             for jj=1:numel(feat_cat)
                sorted_values = sort([curr_point(feat_cat(jj)),second_point_second_cluster(feat_cat(jj))],'ascend');   
                if (sorted_values(1) ~= sorted_values(2))
                    idx_dist = find(dist_all(:,1)==feat_cat(jj)&dist_all(:,2)==sorted_values(1)...
                    &dist_all(:,3)==sorted_values(2));
                    cat_feat_sum = cat_feat_sum + dist_all(idx_dist,4);
                end
             end
             a_and_b(curr_cluster_idx(j),other_clusters(ii)+1) = a_and_b(curr_cluster_idx(j),other_clusters(ii)+1)+...
                 (num_feat_sum + cat_feat_sum)/second_cluster_size; 
           end
        end
    end
end


% calculate silhouette
nearest_neighbor = zeros(n,1);     % save index of nearest neighboring cluster
for i=1:n
    [temp, temp_idx] = sort(a_and_b(i,2:end),'ascend');
    b_i = temp(2);                                  % average dist to neighbor
    nearest_neighbor(i) = temp_idx(2);              % nearest neighbor idx
    all_s(i) = (b_i-a_and_b(i,1))/max(b_i,a_and_b(i,1));
end

% average silhouette
average_s = mean(all_s);
             
          
% plot silhouette

if (nargout == 0) || (plot_silhouette ~= 0)
    % color management: plot each cluster in different colors and 
    % plot negative bars with the color of the closest neighbor cluster
    color_idx = zeros(n,1);
    for i=1:n
        if all_s(i)<0
            color_idx(i) = nearest_neighbor(i);
        else
            color_idx(i) = idx(i);
        end
    end
    colors = 'rgbmcyk';
    

    % Create the bars:  group silhouette values into clusters, sort values
    % within each cluster.  Concatenate all the bars together, separated by
    % empty bars.  Locate each tick midway through each group of bars
    space = max(floor(.02*n), 2);
    bars = NaN(space,1);
    bar_colors = NaN(space,1);
    for i = 1:k
        [temp,temp_idx] = sort(all_s(idx == i),'descend');
        bars = [bars; temp; NaN(space,1)];
        curr_color_idx = color_idx(idx==i);
        bar_colors = [bar_colors; curr_color_idx(temp_idx); NaN(space,1)];
        tcks(i) = length(bars);
    end
    tcks = tcks - 0.5*(diff([space tcks]) + space - 1);

    %Plot the bars, don't clutter the plot if there are lots of
    %clusters or bars
    [~,cnames] = grp2idx(idx);
    if k > 20
        cnames = '';
    end
    
    for i=1:n
        if isnan(bar_colors(i)) == 0
             barsh = barh(i,bars(i),1.0,'FaceColor',colors(bar_colors(i)));
             hold on;
        else
            barsh = barh(i,bars(i),1.0);
            hold on;
        end
    end
 
    axesh = get(barsh(1), 'Parent');
    set(axesh, 'Xlim',[-Inf 1.1], 'Ylim',[1 length(bars)], 'YDir','reverse', 'YTick',tcks, 'YTickLabel',cnames)
    if n > 50
        shading flat
    end
    xlabel(getString(message('stats:silhouette:xlabel')));
    ylabel(getString(message('stats:silhouette:ylabel')));
end


end

