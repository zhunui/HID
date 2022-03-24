function img_saliency = fusesaliency( I1,I2 )
%FUSE SALIENCY 此处显示有关此函数的摘要
%   此处显示详细说明
m = size(I1,1); 
n = size(I1,2);
img_saliency = zeros(m,n);
% Q1 = SpatialFrequency(I1);
% Q2 = SpatialFrequency(I2);
Q1 = WSEML(I1);
Q2 = WSEML(I2);
m = size(I1,1); 
n = size(I1,2);
for i = 1:m
    for j = 1:n
        if Q1(i,j)>=Q2(i,j)
            img_saliency(i,j) = I1(i,j);
        else
            img_saliency(i,j) = I2(i,j);
        end
    end
    
end
end

