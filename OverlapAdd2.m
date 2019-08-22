function ReconstructedSignal=OverlapAdd2(XNEW,yphase,windowLen,ShiftLen);

%Y=OverlapAdd(X,A,W,S);
%Y is the signal reconstructed signal from its spectrogram. X is a matrix
%with each column being the fft of a segment of signal. A is the phase
%angle of the spectrum which should have the same dimension as X. if it is
%not given the phase angle of X is used which in the case of real values is
%zero (assuming that its the magnitude). W is the window length of time
%domain segments if not given the length is assumed to be twice as long as
%fft window length. S is the shift length of the segmentation process ( for
%example in the case of non overlapping signals it is equal to W and in the
%case of %50 overlap is equal to W/2. if not givven W/2 is used. Y is the
%reconstructed time domain signal.
%Sep-04
%Esfandiar Zavarehei

if nargin<2                                   % 如果没有带入yphase参数
    yphase=angle(XNEW);                       % 赋值
end
if nargin<3                                   % 如果没有带入windowLen参数
    windowLen=size(XNEW,1)*2;                 % 赋值
end
if nargin<4                                   % 如果没有带入ShiftLen参数
    ShiftLen=windowLen/2;                     % 赋值
end
if fix(ShiftLen)~=ShiftLen                    % 如果帧移带有小数
    ShiftLen=fix(ShiftLen);                   % 取整,并显示错误信息
    disp('The shift length have to be an integer as it is the number of samples.')
    disp(['shift length is fixed to ' num2str(ShiftLen)])
end

[FreqRes FrameNum]=size(XNEW);                % 取输入谱值的帧数和频谱谱线数

Spec=XNEW.*exp(j*yphase);                     % 求取复数谱值

if mod(windowLen,2)                           % 若windowLen是奇数
    Spec=[Spec;flipud(conj(Spec(2:end,:)))];  % 补上负频率部分  
else                                          % 若windowLen是偶数
    Spec=[Spec;flipud(conj(Spec(2:end-1,:)))];% 补上负频率部分
end
sig=zeros((FrameNum-1)*ShiftLen+windowLen,1); % 初始化sig
weight=sig;
for i=1:FrameNum                              % 按式(10-2-1)重叠相加法把数据叠接合成
    start=(i-1)*ShiftLen+1;                   % 计算i帧在sig中的起始位置  
    spec=Spec(:,i);                           % 取第i帧的频谱
    sig(start:start+windowLen-1)=sig(start:start+windowLen-1)...% 重叠相加
    +real(ifft(spec,windowLen));    
end
ReconstructedSignal=sig;                      % 把合成语音赋值于输出

