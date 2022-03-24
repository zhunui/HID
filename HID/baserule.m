function img_base = baserule(I1,I2,T_q)
%BASERULE 此处显示有关此函数的摘要
%   此处显示详细说明
m = size(I1,1); 
n = size(I1,2);
img_base = zeros(m,n);
% alpha = entropy(uint8(I1))/entropy(uint8(I2));
for i = 1:m
    for j = 1:n
%         if I1(i,j)>=T_q+I2(i,j)
        if abs(I1(i,j))>=T_q+abs(I2(i,j))
            img_base(i,j) = I1(i,j);
        else
            img_base(i,j) = I2(i,j);
        end
    end
    
end
end

