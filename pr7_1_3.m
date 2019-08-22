%
% pr7_1_3 
clear all; clc; close all;

load ecg_m.mat                          % 读入数据
s=x;
N=length(x);                            % 信号长度
fs=1000;                                % 采样频率
n=1:N;
n2=1:N/2;
tt=(n-1)/fs;                            % 时间刻度
ff=(n2-1)*fs/N;                         % 频率刻度
X=fft(x);                               % 谱分析

for k=1 : 5                             % 自适应陷波器
    j=(k-1)*2+1;                        % 设置50Hz和它的奇次谐波频率
    f0=50*j;
    x1=cos(2*pi*tt*f0);                 % 设置x1和x2
    x2=sin(2*pi*tt*f0);
    w1=0;                               % %初始化w1和w2
    w2=1;
    e=zeros(1,N);                       % %初始化e和y
    y=zeros(1,N);
    mu=0.1;                             % 设置迭代步长
    for i=1:N                           % 自适应陷波器
        y(i)=w1*x1(i)+w2*x2(i);         % 计算y
        e(i)=x(i)-y(i);                 % 计算e
        w1=w1+mu*e(i)*x1(i);            % 调整w
        w2=w2+mu*e(i)*x2(i);
    end
    x=e;
end
output=e;                               % 陷波器输出
% 作图
figure(1)
subplot 211; plot(tt,s,'k');
title('心电图原始数据'); xlabel('时间/s'); ylabel('幅值');
axis([0 10 -3000 6500]);
X=X/max(abs(X));
subplot 212; plot(ff,abs(X(n2)),'k');
axis tight; title('心电图数据的谱分析'); 
xlabel('频率/Hz'); ylabel('幅值');
figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2)-100,pos(3),(pos(4)-200)])
plot(tt,output,'k')
axis([0 10 -2000 6500]);
title('自适应陷波器滤波后的心电图数据'); 
xlabel('时间/s'); ylabel('幅值');



