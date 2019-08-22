%
% pr7_3_1 
clear all; clc; close all;

filedir=[];                             % ָ���ļ�·��
filename='bluesky1.wav';                % ָ���ļ���
fle=[filedir filename]                  % ����·�����ļ������ַ���
[xx,fs]=audioread(fle);                 % ���������ļ�
xx=xx-mean(xx);                         % ����ֱ������
x=xx/max(abs(xx));                      % ��ֵ��һ��
SNR=5;                                  % ����SNR
signal=Gnoisegen(x,SNR);                % ��������
snr1=SNR_singlech(x,signal);            % �������������������
N=length(x);                            % �źų���
time=(0:N-1)/fs;                        % ����ʱ��
IS=.15;                                 % ����IS

% ����WienerScalart96m_2������ά���˲�
output=WienerScalart96m_2(signal,fs,IS,0.12);
ol=length(output);                      % ��output������x�ȳ�
if ol<N
    output=[output; zeros(N-ol,1)];
end
snr2=SNR_singlech(x,output);            % ����ά���˲���������
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);
sound(signal,fs);                     % �����������Ƚ�
pause(1)
sound(output,fs);
% ��ͼ
subplot 311; plot(time,x,'k'); grid; axis tight;
title('����������'); ylabel('��ֵ')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['�������� �����=' num2str(SNR) 'dB']); ylabel('��ֵ')
subplot 313; plot(time,output,'k');grid; ylim([-1 1]);
title('ά���˲�����'); ylabel('��ֵ'); xlabel('ʱ��/s');

