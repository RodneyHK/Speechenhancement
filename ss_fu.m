function [y_out_time,fs] = ss_fu(y_in_orig,fs0)
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
signal = y_in_orig;
fs = fs0;

IS=0.15;                                % ǰ���޻��γ���(s)

alpha=2.8;                              % ��������
beta=0.001;                             % ���油������
%c=0ʱ,�ù����׼���������󲻽��п�������,c=1ʱ,���п�������
c=1;        
N=length(signal);                       % �źų���
time=(0:N-1)/fs;                        % ����ʱ��
wlen=200;                               % ����֡��
inc=80;                                 % ����֡��
NIS=fix((IS*fs-wlen)/inc +1);           % ǰ���޻���֡��

output=Mtmpsd_ssb(signal,wlen,inc,NIS,alpha,beta,c);% �ര�׸Ľ��׼������봦��
sound(output,fs);
y_out_time = output;
end

