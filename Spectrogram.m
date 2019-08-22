function [Y] = Spectrogram(x,fs)

wlen=1000;inc=100;win=hanning(wlen);
N=length(x);time=(0:N-1)/fs;
y=enframe(x,win,inc)';
fn=size(y,2);
frameTime=(((1:fn)-1)*inc+wlen/2)/fs;
W2=wlen/2+1;n2=1:W2;
freq=(n2-1)*fs/wlen;
Y=fft(y);
figure
imagesc(frameTime,freq,abs(Y(n2,:)));
axis xy;

end