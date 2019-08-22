function output=Mtmpsd_ssb(signal,wlen,inc,NIS,alpha,beta,c)
w2=wlen/2+1;
wind=hamming(wlen);                         % ���庺����
y=enframe(signal,wind,inc)';                % ��֡
fn=size(y,2);                               % ��֡��
N=length(signal);                           % �źų���
fft_frame=fft(y);                           % ��ÿ֡�źż���FFT
abs_frame=abs(fft_frame(1:w2,:));           % ȡ��Ƶ�ʲ��ֵķ�ֵ
ang_frame=angle(fft_frame(1:w2,:));         % ȡ��Ƶ�ʲ��ֵ���λ��

% ����3֡ƽ��
abs_frame_f=abs_frame;
for i=2:fn-1;
    abs_frame_f(:,i)=.25*abs_frame(:,i-1)+.5*abs_frame(:,i)+.25*abs_frame(:,i+1);
end;
abs_frame=abs_frame_f;

% �öര�׷���ÿһ֡���ݽ��й����׹���
for i=1:fn;
    per_PSD(:,i)=pmtm(y(:,i),3,wlen);
end;

% �Թ����׵�����3֡����ƽ��
per_PSD_f=per_PSD;
for i=2:fn-1;
    per_PSD_f(:,i)=.25*per_PSD(:,i-1)+.5*per_PSD(:,i)+.25*per_PSD(:,i+1);
end;
per_PSD=per_PSD_f;

% ��ǰ���޻�������ȡ����ƽ��������
noise_PSD=mean(per_PSD(:,1:NIS),2);

% �׼���ȡ��������
for k=1:fn;
    g(:,k)=(per_PSD(:,k)-alpha*noise_PSD)./per_PSD(:,k);
    g_n(:,k)=beta*noise_PSD./per_PSD(:,k);
    gix=find(g(:,k)<0);
    g(gix,k)=g_n(gix,k);
end;

gf=g;
if c==0, g=gf; else g=gf.^0.5; end;         % ������c�������
sub_frame=g.*abs_frame;                     % ���������Ӽ����׼���ķ�ֵ
output=OverlapAdd2(sub_frame,ang_frame,wlen,inc); % �����ϳ�

output=output/max(abs(output));             % ��ֵ��һ��
ol=length(output);                          % ��output������x�ȳ�
if ol<N 
    output=[output; zeros(N-ol,1)];
end