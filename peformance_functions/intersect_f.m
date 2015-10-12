function [ values ] = intersect_f( x,y )
%INTERSECT_F Summary fast version of Matlab's intersect (for performance
%purposes)
% 
% input:
%     x: a sorted vector
%     y: a sorted vector
%     
% output:
%     values: common values between x and y


values = x(ismembc(x,y));


end

