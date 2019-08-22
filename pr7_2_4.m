%
% pr7_2_4 
clear all; clc; close all;

filedir=[];                             % 指定文件路径
filename='bluesky1.wav';                % 指定文件名
fle=[filedir filename]                  % 构成路径和文件名的字符串
[xx,fs]=wavread(fle);                   % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
SNR=0;                                  % 设置初始信噪比
[signal,n0]=Gnoisegen(x,SNR);           % 叠加噪声
snr1=SNR_singlech(x,signal);            % 计算叠加噪后的信噪比
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
snr2=SNR_singlech(x,output);            % 计算谱减后的信噪比
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);
wavplay(signal,fs);                     % 从声卡发声比较
pause(1)
wavplay(output,fs);

%作图
subplot 311; plot(time,x,'k'); grid; axis tight;
title('纯语音波形'); ylabel('幅值')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
subplot 313; plot(time,output,'k');grid;%hold on;
title('谱减后波形'); ylabel('幅值'); xlabel('时间/s');

