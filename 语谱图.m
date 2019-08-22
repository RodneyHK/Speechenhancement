clc
close all
clear all

[x,fs]=audioread('original_data.wav');
% x=load('ÄãºÃ.txt');
% x=x(:,2);
% Fs=2500;
% x=x(350:16000);
% x=x(0.7*fs:3.7*fs);
x=x/max(x);
% plot(x)
wlen=1600;inc=100;win=hanning(wlen);
N=length(x);time=(0:N-1)/fs;
y=enframe(x,win,inc)';
fn=size(y,2);
frameTime=(((1:fn)-1)*inc+wlen/2)/fs;
W2=wlen/2+1;n2=1:W2;
freq=(n2-1)*fs/wlen;
Y=fft(y);
% clf
% set(gcf,'Position',[20 100 600 500]);
% axes('Position',[0.1 0.1 0.85 0.5]);
% figure
% subplot(2,1,1)
figure
imagesc(frameTime,freq,abs(Y(n2,:)));
axis xy;

% m=64;
% LightYellow=[0.8 0.8 0.8];
% MidRed=[0.4 0.2 0.5];
% Black=[0.5 0.7 1];
% Colors=[LightYellow;MidRed;Black];
% colormap(SpecColorMap(m,Colors));
% figure
% plot(time,x,'k');
% xlim([0 max(time)]);
% xlabel('s');ylabel('range');
% title('ÓïÒôÐÅºÅ²¨ÐÎ');
t=(1:length(x))./fs;
figure
plot(t,x)
% [x1,fs1,Nbits]=wavread('ÄÐÉùÓ¢ÎÄ_omlsa.wav');
% % x=load('ÄãºÃ.txt');
% % x=x(:,2);
% % Fs=2500;
% % x=x(350:16000);
% % hd=bandpass;
% x1=x1(1:3*fs1);
% % x1=filter(hd,x1);
% x1=x1/max(x1);
% % plot(x)
% wlen=800;inc=100;win=hanning(wlen);
% N=length(x1);time=(0:N-1)/fs1;
% y1=enframe(x1,win,inc)';
% fn1=size(y1,2);
% frameTime2=(((1:fn1)-1)*inc+wlen/2)/fs1;
% W2=wlen/2+1;n2=1:W2;
% freq2=(n2-1)*fs/wlen;
% Y1=fft(y1);
% % clf
% % set(gcf,'Position',[20 100 600 500]);
% % axes('Position',[0.1 0.1 0.85 0.5]);
% %  figure
% % subplot(2,1,2)
% figure
% imagesc(frameTime2,freq2,abs(Y1(n2,:)));
% axis xy;ylabel('hz');xlabel('s');
% title('ÓïÆ×Í¼');
% % figure
% % plot(time,x,'k');
% % xlim([0 max(time)]);
% % xlabel('s');ylabel('range');
% % title('ÓïÒôÐÅºÅ²¨ÐÎ');
% t1=(1:length(x1))./fs1;
% figure
% plot(t1,x1)


[x1,fs1,Nbits]=wavread('bag02.wav');
% x=load('ÄãºÃ.txt');
% x=x(:,2);
% Fs=2500;
% x=x(350:16000);
% x1=x1(1:3*fs1);
x1=x1/max(x1);
% plot(x)
x1=x1+ 0.2*rand(length(x1),1);
wlen=800;inc=100;win=hanning(wlen);
N=length(x1);time=(0:N-1)/fs1;
y1=enframe(x1,win,inc)';
fn1=size(y1,2);
frameTime2=(((1:fn1)-1)*inc+wlen/2)/fs1;
W2=wlen/2+1;n2=1:W2;
freq2=(n2-1)*fs1/wlen;
Y1=fft(y1);
% clf
% set(gcf,'Position',[20 100 600 500]);
% axes('Position',[0.1 0.1 0.85 0.5]);
%  figure
% subplot(2,1,2)
figure
imagesc(frameTime2,freq2,abs(Y1(n2,:)));
axis xy;ylabel('hz');xlabel('s');
title('ÓïÆ×Í¼');
t1=(1:length(x1))./fs1;
figure
plot(t1,x1)


[x1,fs1,Nbits]=wavread('bag_phone.wav');
% x=load('ÄãºÃ.txt');
% x=x(:,2);
% Fs=2500;
% x=x(350:16000);
% x1=x1(1:3*fs1);
x1=x1/max(x1);
% plot(x)
wlen=800;inc=100;win=hanning(wlen);
N=length(x1);time=(0:N-1)/fs1;
y1=enframe(x1,win,inc)';
fn1=size(y1,2);
frameTime2=(((1:fn1)-1)*inc+wlen/2)/fs1;
W2=wlen/2+1;n2=1:W2;
freq2=(n2-1)*fs/wlen;
Y1=fft(y1);
% clf
% set(gcf,'Position',[20 100 600 500]);
% axes('Position',[0.1 0.1 0.85 0.5]);
%  figure
% subplot(2,1,2)
figure
imagesc(frameTime2,freq2,abs(Y1(n2,:)));
axis xy;ylabel('hz');xlabel('s');
title('ÓïÆ×Í¼');
t1=(1:length(x1))./fs1;
figure
plot(t1,x1)


























% [x1,fs1,Nbits]=wavread('bag_o.wav');
% % x=load('ÄãºÃ.txt');
% % x=x(:,2);
% % Fs=2500;
% % x=x(350:16000);
% % x1=x1(1:3*fs1);
% x1=x1/max(x1);
% % plot(x)
% wlen=800;inc=100;win=hanning(wlen);
% N=length(x1);time=(0:N-1)/fs1;
% y1=enframe(x1,win,inc)';
% fn1=size(y1,2);
% frameTime2=(((1:fn1)-1)*inc+wlen/2)/fs1;
% W2=wlen/2+1;n2=1:W2;
% freq2=(n2-1)*fs/wlen;
% Y1=fft(y1);
% % clf
% % set(gcf,'Position',[20 100 600 500]);
% % axes('Position',[0.1 0.1 0.85 0.5]);
% %  figure
% % subplot(2,1,2)
% figure
% imagesc(frameTime2,freq2,abs(Y1(n2,:)));
% axis xy;ylabel('hz');xlabel('s');
% title('ÓïÆ×Í¼');
% t1=(1:length(x1))./fs1;
% figure
% plot(t1,-x1)





% [x1,fs1,Nbits]=wavread('hello.ldv.wav');
% % x=load('ÄãºÃ.txt');
% % x=x(:,2);
% % Fs=2500;
% % x=x(350:16000);
% x1=x1/max(x1);
% % plot(x)
% wlen=800;inc=100;win=hanning(wlen);
% N=length(x1);time=(0:N-1)/fs1;
% y1=enframe(x1,win,inc)';
% fn1=size(y1,2);
% frameTime2=(((1:fn1)-1)*inc+wlen/2)/fs1;
% W2=wlen/2+1;n2=1:W2;
% freq2=(n2-1)*fs1/wlen;
% Y1=fft(y1);
% % clf
% % set(gcf,'Position',[20 100 600 500]);
% % axes('Position',[0.1 0.1 0.85 0.5]);
% %  figure
% % subplot(2,1,2)
% imagesc(frameTime2,freq2,abs(Y1(n2,:)));
% axis xy;ylabel('hz');xlabel('s');
% title('ÓïÆ×Í¼');
% 
