function [discrete_output] = make_discrete(x)
%MAKE_DISCRETE discretize a numerical attribute

% input:
%     x: a numerical, normalized attribute
%     
% output:
%     discrete_output:  a discretized output
% 
%
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



% initialize output
discrete_output = NaN(size(x));


% discretize based on 4 intervals  (to be modified)
% idx = find(x>=0 & x<0.25);
% discrete_output(idx) = 1;
% 
% idx = find(x>=0.25 & x<0.5);
% discrete_output(idx) = 2;
% 
% idx = find(x>=0.5 & x<0.75);
% discrete_output(idx) = 3;
% 
% idx = find(x>=0.75 & x<=1);
% discrete_output(idx) = 4;


discrete_output = kmeans(x,4);


end

