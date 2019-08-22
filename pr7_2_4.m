%
% pr7_2_4 
clear all; clc; close all;

filedir=[];                             % ָ���ļ�·��
filename='bluesky1.wav';                % ָ���ļ���
fle=[filedir filename]                  % ����·�����ļ������ַ���
[xx,fs]=wavread(fle);                   % ���������ļ�
xx=xx-mean(xx);                         % ����ֱ������
x=xx/max(abs(xx));                      % ��ֵ��һ��
SNR=0;                                  % ���ó�ʼ�����
[signal,n0]=Gnoisegen(x,SNR);           % ��������
snr1=SNR_singlech(x,signal);            % ����������������
IS=0.15;                                % ǰ���޻��γ���(s)

alpha=2.8;                              % ��������
beta=0.001;                             % ���油������
%c=0ʱ,�ù����׼���������󲻽��п�������,c=1ʱ,���п�������
c=1;        
N=length(signal);                       % �źų���
time=(0:N-1)/fs;                        % ����ʱ��
wlen=200;                               % ����֡��
inc=80;                                 % ����֡��
NIS=fix((IS*fs-wlen)/inc +1);           % ǰ���޻���֡��

output=Mtmpsd_ssb(signal,wlen,inc,NIS,alpha,beta,c);% �ര�׸Ľ��׼������봦��
snr2=SNR_singlech(x,output);            % �����׼���������
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f   snr=%5.4f\n',snr1,snr2,snr);
wavplay(signal,fs);                     % �����������Ƚ�
pause(1)
wavplay(output,fs);

%��ͼ
subplot 311; plot(time,x,'k'); grid; axis tight;
title('����������'); ylabel('��ֵ')
subplot 312; plot(time,signal,'k'); grid; axis tight;
title(['�������� �����=' num2str(SNR) 'dB']); ylabel('��ֵ')
subplot 313; plot(time,output,'k');grid;%hold on;
title('�׼�����'); ylabel('��ֵ'); xlabel('ʱ��/s');

