function [ sen spec ] = calc( x, y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
thresholds = [0.1 0.2 0.5 1 2 3 4 5];
sen = zeros(1,20);

spec = zeros(1,20)
for i = 1:length(thresholds)
    t = thresholds(i);
    [sen(i), spec(i)] = ro( (edge(x, 'log', t)), y);
    
    
    

end
figure, plot(spec, sen);
axis([0 1 0 1]);

