%
% pr7_2_1   
clear all; clc; close all;

filedir=[];                             % ָ���ļ�·��
filename='bluesky1.wav';                % ָ���ļ���
fle=[filedir filename]                  % ����·�����ļ������ַ���
[xx,fs]=wavread(fle);                   % ���������ļ�
xx=xx-mean(xx);                         % ����ֱ������
x=xx/max(abs(xx));                      % ��ֵ��һ��

IS=0.25;                                % ����ǰ���޻��γ���
wlen=200;                               % ����֡��Ϊ25ms
inc=80;                                 % ����֡��Ϊ10ms
SNR=5;                                  % ���������SNR
N=length(x);                            % �źų���
time=(0:N-1)/fs;                        % ����ʱ��
signal=Gnoisegen(x,SNR);                % ��������
snr1=SNR_singlech(x,signal);            % �����ʼ�����
overlap=wlen-inc;                       % ���ص�������
NIS=fix((IS*fs-wlen)/inc +1);           % ��ǰ���޻���֡��

a=4; b=0.001;                           % ���ò���a��b
output=simplesubspec(signal,wlen,inc,NIS,a,b);% �׼�
snr2=SNR_singlech(x,output);            % �����׼���������
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);
wavplay(signal,fs);
pause(1)
wavplay(output,fs);
% ��ͼ
subplot 311; plot(time,x,'k'); grid; axis tight;
title('����������'); ylabel('��ֵ')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['�������� �����=' num2str(SNR) 'dB']); ylabel('��ֵ')
subplot 313; plot(time,output,'k');grid;%hold on;
title('�׼�����'); ylabel('��ֵ'); xlabel('ʱ��/s');



        
