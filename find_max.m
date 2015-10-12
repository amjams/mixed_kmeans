function [ d, w, w_c ] = find_max(ai,aj,x,y)

% distance between two categorical values in a clustering problem
% inputs:
%   ai:  a categorical attribute
%   aj:  another categorical attribute  
%   x:   one of the categorical attributes in ai
%   y:   another categorical attribute in ai
% 
% output:
%   d: the maximum distance between x and y with respect to aj; delta_xy
%   w:   support set
%   w_c: complementary support set
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

% intialize distance
d = 0;

% initalize support set
w = [];
w_c = [];

% the number of categorical values in aj
unique_j = unique_f(aj);
vj = numel(unique_j);



% begin algorithm
for t = 1:vj
    ut = unique_j(t);
    
    % locations
    ut_in_aj = find(aj==ut);
    x_in_ai = find(ai==x);
    y_in_ai = find(ai==y);
    
    % probabilities
    p_ux = numel(intersect_f(x_in_ai,ut_in_aj))/numel(x_in_ai);
    p_uy = numel(intersect_f(y_in_ai,ut_in_aj))/numel(y_in_ai);
    
    % conditions
    if p_ux>= p_uy
        w = [w;ut];          %update support set
        d = d+p_ux;          %update distance
    else
        w_c = [w_c;p_uy];    %update complement support set
        d = d+p_uy;          %update distance
    end
    
    
end
d = d-1;                      %restrict distance to [0,1]
end

