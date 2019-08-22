function output=WienerScalart96m(signal,fs,IS)
if (nargin<3 | isstruct(IS))                % 如果输入参数小于3个或IS是结构数据
   IS=.25; 
end
W=fix(.025*fs);                             % 帧长为25ms
SP=.4;                                      % 帧移比例取40%(10ms) 
wnd=hamming(W);                             % 设置窗函数
% 如果输入参数大于或等于3个并IS是结构数据(为了兼容其他程序)
if (nargin>=3 & isstruct(IS))
SP=IS.shiftsize/W;
%nfft=IS.nfft;
wnd=IS.window;
if isfield(IS,'IS')
IS=IS.IS;
else
IS=.25;
end
end
pre_emph=0;
signal=filter([1 -pre_emph],1,signal);      % 预加重
NIS=fix((IS*fs-W)/(SP*W) +1);               % 计算无话段帧数
y=segment(signal,W,SP,wnd);                 % 分帧 
Y=fft(y);                                   % FFT
YPhase=angle(Y(1:fix(end/2)+1,:));          % 带噪语音的相位角 
Y=abs(Y(1:fix(end/2)+1,:));                 % 取正频率谱值
numberOfFrames=size(Y,2);                   % 计算总帧数
FreqResol=size(Y,1);                        % 计算频谱中的谱线数
N=mean(Y(:,1:NIS)')';                       % 计算无话段噪声平均谱值 
LambdaD=mean((Y(:,1:NIS)').^2)';            % 计算噪声平均功率谱(方差)
alpha=.99;                                  % 设置平滑系数
NoiseCounter=0;                             % 初始化NoiseCounter
NoiseLength=9;                              % 设置噪声平滑区间长度
G=ones(size(N));                            % 初始化谱估计器
Gamma=G;
X=zeros(size(Y));                           % 初始化X
h=waitbar(0,'Wait...');                     % 设置运行进度条图
for i=1:numberOfFrames
if i<=NIS                                   % 若i<=NIS在前导无声(噪声)段
SpeechFlag=0;
NoiseCounter=100;
else                                        % i>NIS判断是否为有话帧
[NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(Y(:,i),N,NoiseCounter); 
end
if SpeechFlag==0                            % 在无话段中平滑更新噪声谱值
N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); 
LambdaD=(NoiseLength*LambdaD+(Y(:,i).^2))./(1+NoiseLength); % 更新和平滑噪声方差
end

gammaNew=(Y(:,i).^2)./LambdaD;              % 计算后验信噪比
xi=alpha*(G.^2).*Gamma+(1-alpha).*max(gammaNew-1,0); % 计算先验信噪比
Gamma=gammaNew;
G=(xi./(xi+1));                             % 计算维纳滤波器的谱估计器
X(:,i)=G.*Y(:,i);                           % 维纳滤波后的幅值
waitbar(i/numberOfFrames,h,num2str(fix(100*i/numberOfFrames)));%显示运行进度条图
end
close(h);                                   % 关闭运行进度条图                                 
output=OverlapAdd2(X,YPhase,W,SP*W);        % 语音合成
output=filter(1,[1 -pre_emph],output);      % 消除预加重影响
