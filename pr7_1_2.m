%
% pr7_1_2 
clear all; clc; close all;

filedir=[];                             % ָ���ļ�·��
filename='bluesky1.wav';                % ָ���ļ���
fle=[filedir filename]                  % ����·�����ļ������ַ���
[s,fs]=wavread(fle);                    % ���������ļ�
s=s/max(abs(s));                        % ��ֵ��һ��
N=length(s);                            % ����źų���
time=(0:N-1)/fs;                        % ����ʱ��
ns=0.5*cos(2*pi*50*time);               % �����50Hz��Ƶ�ź�
x=s+ns';                                % �����źź�50Hz��Ƶ�źŵ���
snr1=SNR_singlech(s,x);                 % �������50Hz��Ƶ�źź�������

x1=cos(2*pi*50*time);                   % ����x1��x2
x2=sin(2*pi*50*time);
w1=0.1;                                 % ��ʼ��w1��w2
w2=0.1;
e=zeros(1, N);                          % ��ʼ��e��y
y=zeros(1, N);
mu=0.05;                                % ����mu
for i=1: N                              % LMS����Ӧ�ݲ����˲�
  y(i)=w1 * x1(i)+ w2 * x2(i);          % ��ʽ(7-1-29)����y
  e(i) =x(i)-y(i);                      % ��ʽ(7-1-30)����e
  w1=w1+mu * e(i) * x1(i);              % ��ʽ(7-1-31)����w
  w2=w2+mu * e(i) * x2(i);
end
output=e';                              % �ݲ������
snr2=SNR_singlech(s,output);            % �����˲��������� 
snr=snr2-snr1;
fprintf('snr1=%5.4f   snr2=%5.4f    snr=%5.4f\n',snr1,snr2,snr);
wavplay(x,fs);                          % �����������Ƚ�
pause(1)
wavplay(output,fs);
% ��ͼ
subplot 311; plot(time,s,'k'); 
ylim([-1 1 ]); title('ԭʼ�����ź�');
subplot 312; plot(time,x,'k'); 
ylim([-1 1 ]); title('���������ź�');
subplot 313; plot(time,output,'k'); 
ylim([-1 1 ]); title('LMS�˲���������ź�');
xlabel('ʱ��/s')

