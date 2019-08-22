function output=WienerScalart96m(signal,fs,IS)
if (nargin<3 | isstruct(IS))                % ����������С��3����IS�ǽṹ����
   IS=.25; 
end
W=fix(.025*fs);                             % ֡��Ϊ25ms
SP=.4;                                      % ֡�Ʊ���ȡ40%(10ms) 
wnd=hamming(W);                             % ���ô�����
% �������������ڻ����3����IS�ǽṹ����(Ϊ�˼�����������)
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
signal=filter([1 -pre_emph],1,signal);      % Ԥ����
NIS=fix((IS*fs-W)/(SP*W) +1);               % �����޻���֡��
y=segment(signal,W,SP,wnd);                 % ��֡ 
Y=fft(y);                                   % FFT
YPhase=angle(Y(1:fix(end/2)+1,:));          % ������������λ�� 
Y=abs(Y(1:fix(end/2)+1,:));                 % ȡ��Ƶ����ֵ
numberOfFrames=size(Y,2);                   % ������֡��
FreqResol=size(Y,1);                        % ����Ƶ���е�������
N=mean(Y(:,1:NIS)')';                       % �����޻�������ƽ����ֵ 
LambdaD=mean((Y(:,1:NIS)').^2)';            % ��������ƽ��������(����)
alpha=.99;                                  % ����ƽ��ϵ��
NoiseCounter=0;                             % ��ʼ��NoiseCounter
NoiseLength=9;                              % ��������ƽ�����䳤��
G=ones(size(N));                            % ��ʼ���׹�����
Gamma=G;
X=zeros(size(Y));                           % ��ʼ��X
h=waitbar(0,'Wait...');                     % �������н�����ͼ
for i=1:numberOfFrames
if i<=NIS                                   % ��i<=NIS��ǰ������(����)��
SpeechFlag=0;
NoiseCounter=100;
else                                        % i>NIS�ж��Ƿ�Ϊ�л�֡
[NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(Y(:,i),N,NoiseCounter); 
end
if SpeechFlag==0                            % ���޻�����ƽ������������ֵ
N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); 
LambdaD=(NoiseLength*LambdaD+(Y(:,i).^2))./(1+NoiseLength); % ���º�ƽ����������
end

gammaNew=(Y(:,i).^2)./LambdaD;              % ������������
xi=alpha*(G.^2).*Gamma+(1-alpha).*max(gammaNew-1,0); % �������������
Gamma=gammaNew;
G=(xi./(xi+1));                             % ����ά���˲������׹�����
X(:,i)=G.*Y(:,i);                           % ά���˲���ķ�ֵ
waitbar(i/numberOfFrames,h,num2str(fix(100*i/numberOfFrames)));%��ʾ���н�����ͼ
end
close(h);                                   % �ر����н�����ͼ                                 
output=OverlapAdd2(X,YPhase,W,SP*W);        % �����ϳ�
output=filter(1,[1 -pre_emph],output);      % ����Ԥ����Ӱ��
