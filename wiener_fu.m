function [y_out_time,fs] = wiener_fu(y_in_orig,fs0)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

signal = y_in_orig;
fs = fs0;

% SNR=5;                                  % 设置SNR
% signal=Gnoisegen(x,SNR);                % 叠加噪声
% snr1=SNR_singlech(x,signal);            % 计算叠加噪声后的信噪比
N=length(signal);                            % 信号长度
time=(0:N-1)/fs;                        % 设置时间
IS=.15;                                 % 设置IS

% 调用WienerScalart96m_2函数做维纳滤波
output=WienerScalart96m_2(signal,fs,IS,0.12);
ol=length(output);                      % 把output补到与x等长
if ol<N
    output=[output; zeros(N-ol,1)];
end
% snr2=SNR_singlech(x,output);            % 计算维纳滤波后的信噪比
% snr=snr2-0;
% fprintf('   snr2=%5.4f   snr=%5.4f\n',snr2,snr);

sound(output,fs);
y_out_time = output;
% % 作图
% subplot 311; plot(time,x,'k'); grid; axis tight;
% title('纯语音波形'); ylabel('幅值')
% subplot 312; plot(time,signal,'k'); grid; axis tight;
% title(['带噪语音 信噪比=' num2str(SNR) 'dB']); ylabel('幅值')
% subplot 313; plot(time,output,'k');grid; ylim([-1 1]);
% title('维纳滤波后波形'); ylabel('幅值'); xlabel('时间/s');
end

