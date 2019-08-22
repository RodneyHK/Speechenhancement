clc
clear all 
close all

waveDir='C:\Users\Riven_tutu\Desktop\speech_enhancement\pre\';
noiseData_loc = dir(waveDir);
noiseData_loc(1:2) = [];
noiseNum=length(noiseData_loc);%speakerNum:����
wavEn = 'C:\Users\Riven_tutu\Desktop\speech_enhancement\noi\'
fprintf('\n��ȡ�����ļ�������������ǿ...\n\n');

for i=1:noiseNum
    fprintf('\n������ӵ�%d����%s����������', i, noiseData_loc(i,1).name(1:end-4));
    [y, fs0]=audioread([waveDir,noiseData_loc(i,1).name]);
    
    %% / * -- ��������ģ�� -- * /
    N = length(y);
    SNR=0;                                          %���ȸ���������ȣ��ɸĴ�С��
    NOISE=randn(1,N);                               %��������
    NOISE=(NOISE-mean(NOISE))/std(NOISE,1);         %������ֵ=0,����=1�ı�׼��������
    MNOISE=mean(NOISE);
    VNOISE=std(NOISE,1);
    signal_power = 1/length(y)*sum(y.*y);     %�źŹ���
    noise_variance = signal_power / ( 10^(SNR/10) );%������ֵ=0����������
    signal_noise=sqrt(noise_variance)*NOISE;        %�任��NOISE�ľ�ֵ=0������=noise_variance�����Ծ�ֵ���Ѹ���a
    signal_noise = signal_noise';                   %ת�� ������
    y_out = y + signal_noise;
    y_out_time = 1.6*(-0.5 +(y_out-min(y_out))./(max(y_out)-min(y_out)));
    if i<10
        string=[wavEn,'noise_','0',num2str(i),'.wav'];
    else
        string=[wavEn,'noise_',num2str(i),'.wav'];
    end
        
    audiowrite(string,y_out_time,fs0);
    fprintf('  ��ɣ���');
    fprintf('\n')
    clear y��y_out
end
