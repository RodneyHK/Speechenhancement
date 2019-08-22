function output=Mtmpsd_ssb(signal,wlen,inc,NIS,alpha,beta,c)
w2=wlen/2+1;
wind=hamming(wlen);                         % 定义汉明窗
y=enframe(signal,wind,inc)';                % 分帧
fn=size(y,2);                               % 求帧数
N=length(signal);                           % 信号长度
fft_frame=fft(y);                           % 对每帧信号计算FFT
abs_frame=abs(fft_frame(1:w2,:));           % 取正频率部分的幅值
ang_frame=angle(fft_frame(1:w2,:));         % 取正频率部分的相位角

% 相邻3帧平滑
abs_frame_f=abs_frame;
for i=2:fn-1;
    abs_frame_f(:,i)=.25*abs_frame(:,i-1)+.5*abs_frame(:,i)+.25*abs_frame(:,i+1);
end;
abs_frame=abs_frame_f;

% 用多窗谱法对每一帧数据进行功率谱估计
for i=1:fn;
    per_PSD(:,i)=pmtm(y(:,i),3,wlen);
end;

% 对功率谱的相邻3帧进行平滑
per_PSD_f=per_PSD;
for i=2:fn-1;
    per_PSD_f(:,i)=.25*per_PSD(:,i-1)+.5*per_PSD(:,i)+.25*per_PSD(:,i+1);
end;
per_PSD=per_PSD_f;

% 在前导无话段中求取噪声平均功率谱
noise_PSD=mean(per_PSD(:,1:NIS),2);

% 谱减求取增益因子
for k=1:fn;
    g(:,k)=(per_PSD(:,k)-alpha*noise_PSD)./per_PSD(:,k);
    g_n(:,k)=beta*noise_PSD./per_PSD(:,k);
    gix=find(g(:,k)<0);
    g(gix,k)=g_n(gix,k);
end;

gf=g;
if c==0, g=gf; else g=gf.^0.5; end;         % 按参数c开方与否
sub_frame=g.*abs_frame;                     % 用增益因子计算谱减后的幅值
output=OverlapAdd2(sub_frame,ang_frame,wlen,inc); % 语音合成

output=output/max(abs(output));             % 幅值归一化
ol=length(output);                          % 把output补到与x等长
if ol<N 
    output=[output; zeros(N-ol,1)];
end