function output=SSBoll79m(signal,fs,IS)

% OUTPUT=SSBOLL79(S,FS,IS)
% Spectral Subtraction based on Boll 79. Amplitude spectral subtraction 
% Includes Magnitude Averaging and Residual noise Reduction
% S is the noisy signal, FS is the sampling frequency and IS is the initial
% silence (noise only) length in seconds (default value is .25 sec)
%
% April-05
% Esfandiar Zavarehei

if (nargin<3 | isstruct(IS))                % ����������С��3����IS�ǽṹ����
    IS=.25; %seconds
end
W=fix(.025*fs);                             % ֡��Ϊ25ms
nfft=W;                                     % ����FFT����
SP=.4;                                      % ֡�Ʊ���ȡ40%(10ms)
wnd=hamming(W);                             % ���ô�����

% �������������ڻ����3����IS�ǽṹ����(Ϊ�˼�����������)
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

NIS=fix((IS*fs-W)/(SP*W) +1);               % �����޻���֡��
% Gamma=1ʱΪ��ֵ�׼���,Gamma=2Ϊ�����׼���
Gamma=1;                                    % ����Gamma

y=segment(signal,W,SP,wnd);
Y=fft(y,nfft);
YPhase=angle(Y(1:fix(end/2)+1,:));          % ������������λ��
Y=abs(Y(1:fix(end/2)+1,:)).^Gamma;          % ȡ��Ƶ����ֵ
numberOfFrames=size(Y,2);                   % ������֡��
FreqResol=size(Y,1);                        % ����Ƶ���е�������

N=mean(Y(:,1:NIS)')';                       % �����޻�������ƽ����ֵ
NRM=zeros(size(N));                         % ��ʼ��
NoiseCounter=0;
NoiseLength=9;                              % ��������ƽ�����䳤��

Beta=.03;                                   % ������ƽ������

YS=Y;                                       % ��������֮֡��ƽ��
for i=2:(numberOfFrames-1)
    YS(:,i)=(Y(:,i-1)+Y(:,i)+Y(:,i+1))/3;
end

for i=1:numberOfFrames
% ȡ��һ֡�����ж��Ƿ�Ϊ�л�֡    
    [NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(Y(:,i).^(1/Gamma),...
    N.^(1/Gamma),NoiseCounter); 
    if SpeechFlag==0                        % ���޻�֡��ƽ������������ֵ
        N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); 
        NRM=max(NRM,YS(:,i)-N);             % ��ȡ����������ֵ
        X(:,i)=Beta*Y(:,i);
    else
        D=YS(:,i)-N;                        % �׼�������
        if i>1 && i<numberOfFrames          % ���������Ĳ���ֵ            
            for j=1:length(D)
                if D(j)<NRM(j)
                    D(j)=min([D(j) YS(j,i-1)-N(j) YS(j,i+1)-N(j)]);
                end
            end
        end
        X(:,i)=max(D,0);                    % ÿ�����߷�ֵ������0
    end
end

output=OverlapAdd2(X.^(1/Gamma),YPhase,W,SP*W);% ������Ƶ�׷�ֵ����λ�Ǻϳ�����
