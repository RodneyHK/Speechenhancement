function output=WienerScalart96m_2(signal,fs,IS,T1)
% output=WIENERSCALART96(signal,fs,IS)
% Wiener filter based on tracking a priori SNR usingDecision-Directed 
% method, proposed by Scalart et al 96. In this method it is assumed that
% SNRpost=SNRprior +1. based on this the Wiener Filter can be adapted to a
% model like Ephraims model in which we have a gain function which is a
% function of a priori SNR and a priori SNR is being tracked using Decision
% Directed method. 
% Author: Esfandiar Zavarehei
% Created: MAR-05


if (nargin<3 | isstruct(IS))                % ����������С��3����IS�ǽṹ����
   IS=.25; 
end
W=fix(.025*fs);                             % ֡��Ϊ25ms
SP=.4;                                      % ֡�Ʊ���ȡ40%(10ms) 
wnd=hamming(W);                             % ���ô�����
% �������������ڻ����3����IS�ǽṹ����(Ϊ�˼�����������)
if (nargin>=3 & isstruct(IS))
    SP=IS.shiftsize/W;
    nfft=IS.nfft;
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
y=Msegment(signal,W,SP,wnd);                 % ��֡ 
Y=fft(y);                                   % FFT
YPhase=angle(Y(1:fix(end/2)+1,:));          % ������������λ�� 
Y=abs(Y(1:fix(end/2)+1,:));                 % ȡ��Ƶ����ֵ
numberOfFrames=size(Y,2);                   % ������֡��
FreqResol=size(Y,1);                        % ����Ƶ���е�������
N=mean(Y(:,1:NIS)')';                       % �����޻�������ƽ����ֵ 
LambdaD=mean((Y(:,1:NIS)').^2)';            % ��ʼ���������׷���
alpha=.99;                                  % ����ƽ��ϵ��
fn=numberOfFrames;
miniL=5;                                    % ����miniL
[voiceseg,vosl,SF,Ef]=pitch_vad1(y,fn,T1,miniL); %�˵���

NoiseCounter=0;                             % ��ʼ��NoiseCounter
NoiseLength=9;                              % ��������ƽ�����䳤��
G=ones(size(N));                            % ��ʼ���׹�����
Gamma=G;
X=zeros(size(Y));                           % ��ʼ��X
h=waitbar(0,'Wait...');                     % �������н�����ͼ 
for i=1:numberOfFrames
    SpeechFlag=SF(i);
    if i<=NIS                               % ��i<=NIS��ǰ������(����)��
        SpeechFlag=0;
        NoiseCounter=100;
    %else                                   % i>NIS�ж��Ƿ�Ϊ�л�֡
        %[NoiseFlag, SpeechFlag, NoiseCounter, Dist]=vad(Y(:,i),N,NoiseCounter); 
    end
    if SpeechFlag==0                         % ���޻�����ƽ������������ֵ
        N=(NoiseLength*N+Y(:,i))/(NoiseLength+1); 
        LambdaD=(NoiseLength*LambdaD+(Y(:,i).^2))./(1+NoiseLength);%���º�ƽ����������
    end

    gammaNew=(Y(:,i).^2)./LambdaD;          % ������������
    xi=alpha*(G.^2).*Gamma+(1-alpha).*max(gammaNew-1,0); % �������������
    Gamma=gammaNew;
    G=(xi./(xi+1));                         % ����ά���˲������׹�����
    X(:,i)=G.*Y(:,i);                       % ά���˲���ķ�ֵ
%��ʾ���н�����ͼ
    waitbar(i/numberOfFrames,h,num2str(fix(100*i/numberOfFrames)));
end
close(h);                                   % �ر����н�����ͼ
output=OverlapAdd2(X,YPhase,W,SP*W);        % �����ϳ�
output=filter(1,[1 -pre_emph],output);      % ����Ԥ����Ӱ��
output=output/max(abs(output));
