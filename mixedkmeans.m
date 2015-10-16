function [ idx, idx_all, significances ] = mixedkmeans( data, k, feat_type, max_iter )

% kmeans for mixed features (See README.txt)
% inputs:
%     data:       the inputs (features); possibly mixed (categorical and nominal)
%     k:          predetermined number of clusters
%     feat_type:  binary vector indicating type of feature (1 for categorical, 0 for numerical)
% 
% outputs:
%     idx:            outcome of the clustering (cluster membership index) 
%     idx_all:        outcome after each iteration
%     significances:  significances of the features to the clustering (can be used to rank the features



% set-up
[n,m] = size(data);
idx_all = NaN(n,max_iter);      %initializing the clustering index
idx_cat = find(feat_type);
idx_num = find(~feat_type);


% normalize numerical features
for i=1:numel(idx_num)
    data(:,idx_num(i)) = make_normal(data(:,idx_num(i)));
end


% find a discrete version of numerical attributes
data_discrete = data;
for i=1:numel(idx_num)
    data_discrete(:,idx_num(i)) = make_discrete(data(:,idx_num(i)));
end


% find all significances
significances = zeros(m,1);
for i=1:m
    significances(i) = significance(data_discrete,i);
end


% assign each data point to one of k clusters randomly
curr_idx = randi([1 k],n,1);


% For every categorical attribute, compute distance delta(r,s) between
% two categorical values r and s   % here: Perf
all_dist = algo_distance(data_discrete);  


% initialize the updated clustering membership index
new_idx = zeros(n,1);


% update the index until it converges or until maximum number of iterations
% is reached

count = 0;
while(isequal(new_idx,curr_idx)==0 && count<max_iter)
    
    % after the first iteration, the current idx is the new index from
    % the previous iteration
    if count>0
    curr_idx = new_idx;
    end
    
    % compute cluster centers
    all_centers = struct;
    for i=1:k
        curr_cluster = data(find(curr_idx==i),:);
        curr_center = cluster_center(curr_cluster,feat_type);
        name = ['center_',sprintf('%03d',i)];
        all_centers.(name) = curr_center;
    end
    
    
    % for each data point, find the closet center and reassign it to it
    for i=1:n
        k_distances = zeros(k,1);
        for j=1:k
            name_now = ['center_',sprintf('%03d',j)];
            center_now = all_centers.(name_now);
            k_distances(j) = dist_to_center(data(i,:),center_now,feat_type,significances,all_dist);
        end
        % assign the point to its closest center
        [~,new_idx(i)] = min(k_distances);
    end
% update the interation counter
count = count+1;
idx_all(:,count) = new_idx;
end

% output equals final
idx = idx_all(:,count);
end

