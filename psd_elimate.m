Fs=1000;
t=0:1/Fs:1;
a=cos(30*2*pi*t);
window=boxcar(length(t));
nfft=1024;
[pxx,f] = periodogram(a,window,nfft,Fs);
figure
plot(f,pxx)
% spectrum(a,Fs)