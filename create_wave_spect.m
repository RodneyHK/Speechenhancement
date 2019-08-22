[y, fs0]=audioread('file_box01_frag.wav');
[y_out_time,fs] = omlsa_fu(y,fs0);
t=0:1/fs0:(length(y)-1)/fs0;
figure
plot(t,y)
[Y] = Spectrogram(y,fs0);
figure
plot(t,y_out_time)
[Y] = Spectrogram(y_out_time,fs0);




[y, fs0]=audioread('paper_bag01_frag.wav');
[y_out_time,fs] = omlsa_fu(y,fs0);
t=0:1/fs0:(length(y)-1)/fs0;
figure
plot(t,y)
[Y] = Spectrogram(y,fs0);
figure
plot(t,y_out_time)
[Y] = Spectrogram(y_out_time,fs0);


[y, fs0]=audioread('screen01_frag.wav');
[y_out_time,fs] = omlsa_fu(y,fs0);
t=0:1/fs0:(length(y)-1)/fs0;
figure
plot(t,y)
[Y] = Spectrogram(y,fs0);
figure
plot(t,y_out_time)
[Y] = Spectrogram(y_out_time,fs0);





[y, fs0]=audioread('01.wav');
% [y_out_time,fs] = omlsa_fu(y,fs0);
t=0:1/fs0:(length(y)-1)/fs0;
figure
plot(t,y)
[Y] = Spectrogram(y,fs0);
% figure
% plot(t,y_out_time)
% [Y] = Spectrogram(y_out_time,fs0);

