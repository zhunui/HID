clear all;
close all;
clc;
%% NSST tool box
addpath(genpath('shearlet'));

%input
tic

a = double(imread('c01_1.jpg'));   %the source image CT
b = double(imread('c01_2.jpg'));  %the source image MRI

%precessing
a= a(:,:,1);               %if the input image is in type of gif 
b= b(:,:,1);  
figure,imshow(a,[]),title('CT');
figure,imshow(b,[]),title('MRI');
%% NSST decomposition
pfilt = 'maxflat';
shear_parameters.dcomp =[3 3];
shear_parameters.dsize =[8 8];
[y1,shear_f1]=nsst_dec2(a,shear_parameters,pfilt);
[y2,shear_f2]=nsst_dec2(b,shear_parameters,pfilt);

a = y1{1};
b = y2{1};

%% calculate the feature based on tensor
Q_a = ComputeSaliency(a,0.5,0.5);
Q_b = ComputeSaliency(b,0.5,0.5);

%calculate the circle MIN and MAX
min_a = min(min(Q_a));
max_a = max(max(Q_a));

min_b = min(min(Q_b));
max_b = max(max(Q_b));

if min_a<min_b
    MIN = min_b;
else
    MIN = min_a;
end
if max_a>max_b
    MAX = max_b;
else
    MAX = max_a;
end

%contruct the optimal model
[T_q,w_a,w_b] = optimization(a,b,Q_a,Q_b,MIN,MAX);
%image decompostion
texture_a = w_a.*a;
base_a = (1-w_a).*a;
texture_b = w_b.*b;
base_b = (1-w_b).*b;
%% fusion
base = baserule(base_a,base_b,T_q);  %change
texture =fusesaliency(texture_a,texture_b); %change
y=y1;
y{1} = base+texture;   %low pass fusion
for m=2:length(shear_parameters.dcomp)+1  %high pass fusion
    temp=size((y1{m}));
    temp=temp(3);   %取第三维
    for n=1:temp
        Ahigh=y1{m}(:,:,n);  %第m层分解 第n个方向
        Bhigh=y2{m}(:,:,n);
        y{m}(:,:,n)=fusesaliency(Ahigh,Bhigh);    
    end
end
%%  NSST reconstruction
F=nsst_rec2(y,shear_f1,pfilt);
F = uint8(F);
figure,imshow(F),title('fusion result');
toc