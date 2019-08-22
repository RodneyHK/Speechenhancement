%
% pr7_1_3 
clear all; clc; close all;

load ecg_m.mat                          % ��������
s=x;
N=length(x);                            % �źų���
fs=1000;                                % ����Ƶ��
n=1:N;
n2=1:N/2;
tt=(n-1)/fs;                            % ʱ��̶�
ff=(n2-1)*fs/N;                         % Ƶ�ʿ̶�
X=fft(x);                               % �׷���

for k=1 : 5                             % ����Ӧ�ݲ���
    j=(k-1)*2+1;                        % ����50Hz���������г��Ƶ��
    f0=50*j;
    x1=cos(2*pi*tt*f0);                 % ����x1��x2
    x2=sin(2*pi*tt*f0);
    w1=0;                               % %��ʼ��w1��w2
    w2=1;
    e=zeros(1,N);                       % %��ʼ��e��y
    y=zeros(1,N);
    mu=0.1;                             % ���õ�������
    for i=1:N                           % ����Ӧ�ݲ���
        y(i)=w1*x1(i)+w2*x2(i);         % ����y
        e(i)=x(i)-y(i);                 % ����e
        w1=w1+mu*e(i)*x1(i);            % ����w
        w2=w2+mu*e(i)*x2(i);
    end
    x=e;
end
output=e;                               % �ݲ������
% ��ͼ
figure(1)
subplot 211; plot(tt,s,'k');
title('�ĵ�ͼԭʼ����'); xlabel('ʱ��/s'); ylabel('��ֵ');
axis([0 10 -3000 6500]);
X=X/max(abs(X));
subplot 212; plot(ff,abs(X(n2)),'k');
axis tight; title('�ĵ�ͼ���ݵ��׷���'); 
xlabel('Ƶ��/Hz'); ylabel('��ֵ');
figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)])
plot(tt,output,'k')
axis([0 10 -2000 6500]);
title('����Ӧ�ݲ����˲�����ĵ�ͼ����'); 
xlabel('ʱ��/s'); ylabel('��ֵ');



