function [y_out_time,fs] = ss_fu(y_in_orig,fs0)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
signal = y_in_orig;
fs = fs0;

IS=0.15;                                % 前导无话段长度(s)

alpha=2.8;                              % 过减因子
beta=0.001;                             % 增益补偿因子
%c=0时,用功率谱计算增益矩阵不进行开方运算,c=1时,进行开方运算
c=1;        
N=length(signal);                       % 信号长度
time=(0:N-1)/fs;                        % 设置时间
wlen=200;                               % 设置帧长
inc=80;                                 % 设置帧移
NIS=fix((IS*fs-wlen)/inc +1);           % 前导无话段帧数

output=Mtmpsd_ssb(signal,wlen,inc,NIS,alpha,beta,c);% 多窗谱改进谱减法减噪处理
sound(output,fs);
y_out_time = output;
end

