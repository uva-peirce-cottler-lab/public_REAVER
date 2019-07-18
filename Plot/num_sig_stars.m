function [num_stars] = num_sig_stars(p)
%NUM_SIG_STARS Summary of this function goes here
%   Detailed explanation goes here
num_stars = zeros(size(p));
for n=1:numel(p)
% num_stars(n)=0;
if p(n)<.05;  num_stars(n)=1;end
if p(n)<.01;  num_stars(n)=2; end
if p(n)<.001; num_stars(n)=3;end
end

end

