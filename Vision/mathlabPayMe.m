function [zc] = mathlabPayMe(img, t)
%Own zero crossing since the MathLab one is very bad
zc = zeros(1024,1280);
for i= 2:1:1499
    for j = 2:1:1116
        if ((abs ((img(i-1,j) - img(i+1,j)))) > t)
            zc(i,j) = 1;
           %zc(i-1,j) = 1;
            %zc(i+1,j) = 1;
        elseif((abs ((img(i,j-1) - img(i,j+1)))) > t)
            zc(i,j) = 1;
           % zc(i,j-1) = 1;
            %zc(i,j+1) = 1;
        elseif((abs ((img(i-1,j-1) - img(i+1,j+1)))) > t)
            zc(i,j) = 1;
          %  zc(i-1,j-1) = 1;
           % zc(i+1,j+1) = 1;
        elseif((abs ((img(i+1,j-1) - img(i-1, j+1)))) > t)
            zc(i,j) = 1;
          %  zc(i+1,j-1) = 1;
           % zc(i-1, j+1) = 1;
        end
    end
end


