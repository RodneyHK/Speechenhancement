function [voiceseg,vosl,SF,Ef]=pitch_vad1(y,fn,T1,miniL)
if nargin<4, miniL=10; end
if size(y,2)~=fn, y=y'; end                   % ��yת��Ϊÿ�����ݱ�ʾһ֡�����ź�
wlen=size(y,1);                               % ȡ��֡��
for i=1:fn
    Sp = abs(fft(y(:,i)));                    % FFTȡ��ֵ
    Sp = Sp(1:wlen/2+1);	                  % ֻȡ��Ƶ�ʲ���
    Esum(i) = sum(Sp.*Sp);                    % ��������ֵ
    prob = Sp/(sum(Sp));	                  % �������
    H(i) = -sum(prob.*log(prob+eps));         % ������ֵ
end
hindex=find(H<0.1);
H(hindex)=max(H);
Ef=sqrt(1 + abs(Esum./H));                    % �������ر�
Ef=Ef/max(Ef);                                % ��һ��

zindex=find(Ef>=T1);                          % Ѱ��Ef�д���T1�Ĳ���
zseg=findSegment(zindex);                     % �����˵�����ε���Ϣ
zsl=length(zseg);                             % ��������
j=0;
SF=zeros(1,fn);
for k=1 : zsl                                 % �ڴ���T1���޳�С��miniL�Ĳ���
    if zseg(k).duration>=miniL
        j=j+1;
        in1=zseg(k).begin;
        in2=zseg(k).end;
        voiceseg(j).begin=in1;
        voiceseg(j).end=in2;
        voiceseg(j).duration=zseg(k).duration;
        SF(in1:in2)=1;                        % ����SF
    end
end
vosl=length(voiceseg);                        % �л��εĶ��� 





