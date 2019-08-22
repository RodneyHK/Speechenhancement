function [y_out_time,fs] = wiener_fu(y_in_orig,fs0)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

signal = y_in_orig;
fs = fs0;

% SNR=5;                                  % ����SNR
% signal=Gnoisegen(x,SNR);                % ��������
% snr1=SNR_singlech(x,signal);            % �������������������
N=length(signal);                            % �źų���
time=(0:N-1)/fs;                        % ����ʱ��
IS=.15;                                 % ����IS

% ����WienerScalart96m_2������ά���˲�
output=WienerScalart96m_2(signal,fs,IS,0.12);
ol=length(output);                      % ��output������x�ȳ�
if ol<N
    output=[output; zeros(N-ol,1)];
end
% snr2=SNR_singlech(x,output);            % ����ά���˲���������
% snr=snr2-0;
% fprintf('   snr2=%5.4f   snr=%5.4f\n',snr2,snr);

sound(output,fs);
y_out_time = output;
% % ��ͼ
% subplot 311; plot(time,x,'k'); grid; axis tight;
% title('����������'); ylabel('��ֵ')
% subplot 312; plot(time,signal,'k'); grid; axis tight;
% title(['�������� �����=' num2str(SNR) 'dB']); ylabel('��ֵ')
% subplot 313; plot(time,output,'k');grid; ylim([-1 1]);
% title('ά���˲�����'); ylabel('��ֵ'); xlabel('ʱ��/s');
end

