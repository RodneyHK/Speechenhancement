%
% pr7_1_1 
close all;clear all; clc; 

filedir=[];                             % 设置路径
filename='bluesky1.wav';                % 设置文件名
fle=[filedir filename];                 % 构成完整的路径和文件名
[s, fs, bits] = wavread(fle);           % 读入数据文件
s=s-mean(s);                            % 消除直流分量
s=s/max(abs(s));                        % 幅值归一
N=length(s);                            % 语音长度
time=(0:N-1)/fs;                        % 设置时间刻度
SNR=5;                                  % 设置信噪比
r2=randn(size(s));                      % 产生随机噪声
b=fir1(31,0.5);                         % 设计FIR滤波器,代替H
r21=filter(b,1,r2);                     % FIR滤波
[r1,r22]=add_noisedata(s,r21,fs,fs,SNR);% 产生带噪语音，信噪比为SNR　

M=32;                                   % 设置Ｍ和mu
mu=0.001;  
snr1=SNR_singlech(s,r1);                % 计算初始信噪比
h = adaptfilt.lms(M,mu);                % LMS滤波
[y,e] = filter(h,r2,r1);
output=e;                               % LMS滤波输出
snr2=SNR_singlech(s,output);            % 计算滤波后的信噪比
snr=snr2-snr1;
SN1=snr1; SN2=snr2; SN3=snr;
fprintf('snr1=%5.4f   snr2=%5.4f    snr=%5.4f\n',snr1,snr2,snr);
wavplay(r1,fs);                         % 从声卡发声比较
pause(1)
wavplay(output,fs);
% 作图
subplot 311; plot(time,s,'k'); ylabel('幅值') 
ylim([-1 1 ]); title('原始语音信号');
subplot 312; plot(time,r1,'k'); ylabel('幅值') 
ylim([-1 1 ]); title('带噪语音信号');
subplot 313; plot(time,output,'k'); 
ylim([-1 1 ]); title('LMS滤波输出语音信号');
xlabel('时间/s'); ylabel('幅值')

