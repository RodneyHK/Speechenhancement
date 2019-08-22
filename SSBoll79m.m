function output=SSBoll79m(signal,fs,IS)

% OUTPUT=SSBOLL79(S,FS,IS)
% Spectral Subtraction based on Boll 79. Amplitude spectral subtraction 
% Includes Magnitude Averaging and Residual noise Reduction
% S is the noisy signal, FS is the sampling frequency and IS is the initial
% silence (noise only) length in seconds (default value is .25 sec)
%
% April-05
% Esfandiar Zavarehei

if (nargin<3 | isstruct(IS))                % 如果输入参数小于3个或IS是结构数据
    IS=.25; %seconds
end
W=fix(.025*fs);                             % 帧长为25ms
nfft=W;                                     % 设置FFT长度
SP=.4;                                      % 帧移比例取40%(10ms)
wnd=hamming(W);                             % 设置窗函数

% 如果输入参数大于或等于3个并IS是结构数据(为了兼容其他程序)
if (nargin>=3 & isstruct(IS))
    W=IS.windowsize
    SP=IS.shiftsize/W;
    nfft=IS.nfft;
    wnd=IS.window;
    if isfield(IS,'IS')
        IS=IS.IS;
    else
        IS=.25;
    end
end
% .......IGNORE THIS SECTION FOR CAMPATIBALITY WITH ANOTHER PROGRAM T0 HERE

NIS=fix((IS*fs-W)/(SP*W) +1);               % 计算无话段帧数
% Gamma=1时为幅值谱减法,Gamma=2为功率谱减法
Gamma=1;                                    % 设置Gamma

y=segment(signal,W,SP,wnd);
Y=fft(y,nfft);
YPhase=angle(Y(1:fix(end/2)+1,:));          % 带噪语音的相位角
Y=abs(Y(1:fix(end/2)+1,:)).^Gamma;          % 取正频率谱值
numberOfFrames=size(Y,2);                   % 计算总帧数
FreqResol=size(Y,1);                        % 计算频谱中的谱线数

N=mean(Y(:,1:NIS)')';                       % 计算无话段噪声平均谱值
NRM=zeros(size(N));                         % 初始化
NoiseCounter=0;
NoiseLength=9;                              % 设置噪声平滑区间长度

Beta=.03;                                   % 设置谱平滑因子

YS=Y;                                       % 谱在相邻帧之间平均
for i=2:(numberOfFrames-1)
    YS(:,i)=(Y(:,i-1)+Y(:,i)+Y(:,i+1))/3;
end

for i=1:numberOfFrames
% 取来一帧数据判断是否为有话帧    
    [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(Y(:,i).^(1/Gamma),...
    N.^(1/Gamma),NoiseCounter); 
    if SpeechFlag==0                        % 在无话帧中平滑更新噪声谱值
        N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); 
        NRM=max(NRM,YS(:,i)-N);             % 求取噪声最大残留值
        X(:,i)=Beta*Y(:,i);
    else
        D=YS(:,i)-N;                        % 谱减法消噪
        if i>1 && i<numberOfFrames          % 减少噪声的残留值            
            for j=1:length(D)
                if D(j)<NRM(j)
                    D(j)=min([D(j) YS(j,i-1)-N(j) YS(j,i+1)-N(j)]);
                end
            end
        end
        X(:,i)=max(D,0);                    % 每条谱线幅值都大于0
    end
end

output=OverlapAdd2(X.^(1/Gamma),YPhase,W,SP*W);% 消噪后的频谱幅值和相位角合成语音
