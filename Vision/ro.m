function [ sens, spec ] = ro( our , trgt )
%MAGNITUDE Summary of this function goes here
%   Detailed explanation goes here
tp = 0;
fp = 0;
tn = 0; 
fn = 0;

for i=1:1:1024
    for j=1:1:1280
        if (our(i,j) == 1) && (trgt(i,j) == 1)
            tp = tp +1;
        elseif (our(i,j) == 1) && (trgt(i,j) == 0)
            fp = fp + 1;
        elseif (our(i,j) == 0) && (trgt(i,j) == 0)
            tn = tn +1 ;
        elseif (our(i,j) == 0) && (trgt(i,j) == 1)
            fn = fn +1;
            

        end
    end
end
sens = tp/(tp + fn);
spec = (1 - tn/(tn + fp));


