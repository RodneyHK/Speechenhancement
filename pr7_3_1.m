%
% pr7_3_1 
clear all; clc; close all;

filedir=[];                             % 指定文件路径
filename='bluesky1.wav';                % 指定文件名
fle=[filedir filename]                  % 构成路径和文件名的字符串
[xx,fs]=audioread(fle);                 % 读入数据文件
xx=xx-mean(xx);                         % 消除直流分量
x=xx/max(abs(xx));                      % 幅值归一化
SNR=5;                                  % 设置SNR
signal=Gnoisegen(x,SNR);                % 叠加噪声
snr1=SNR_singlech(x,signal);            % 计算叠加噪声后的信噪比
N=length(x);                            % 信号长度
time=(0:N-1)/fs;                        % 设置时间
IS=.15;                                 % 设置IS

% 调用WienerScalart96m_2函数做维纳滤波
output=WienerScalart96m_2(signal,fs,IS,0.12);
ol=length(output);                      % 把output补到与x等长
if ol<N
    output=[output; zeros(N-ol,1)];
end
snr2=SNR_singlech(x,output);            % 计算维纳滤波后的信噪比
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);
sound(signal,fs);                     % 从声卡发声比较
pause(1)
sound(output,fs);
% 作图
subplot 311; plot(time,x,'k'); grid; axis tight;
title('纯语音波形'); ylabel('幅值')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
subplot 313; plot(time,output,'k');grid; ylim([-1 1]);
title('维纳滤波后波形'); ylabel('幅值'); xlabel('时间/s');

