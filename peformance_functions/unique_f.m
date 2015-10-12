function [ unique_values ] = unique_f(x)
%UNIQUE_F find unique values in an array (faster than matlab's unique)

% input: 
%     x:  an array  (must be a column vector)
%     
% output:    
%     unique_values:  unique values in x


unique_values = find(accumarray(x+1,1))-1;

end

