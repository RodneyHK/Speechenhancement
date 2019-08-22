clc
clear all 
close all

waveDir='C:\Users\Riven_tutu\Desktop\speech_enhancement\pre\';
noiseData_loc = dir(waveDir);
noiseData_loc(1:2) = [];
noiseNum=length(noiseData_loc);%speakerNum:人数
wavEn = 'C:\Users\Riven_tutu\Desktop\speech_enhancement\noi\'
fprintf('\n读取语音文件并进行语音增强...\n\n');

for i=1:noiseNum
    fprintf('\n正在添加第%d个人%s的语音噪声', i, noiseData_loc(i,1).name(1:end-4));
    [y, fs0]=audioread([waveDir,noiseData_loc(i,1).name]);
    
    %% / * -- 噪声生成模块 -- * /
    N = length(y);
    SNR=0;                                          %事先给定的信噪比，可改大小！
    NOISE=randn(1,N);                               %产生噪声
    NOISE=(NOISE-mean(NOISE))/std(NOISE,1);         %产生均值=0,方差=1的标准化的噪声
    MNOISE=mean(NOISE);
    VNOISE=std(NOISE,1);
    signal_power = 1/length(y)*sum(y.*y);     %信号功率
    noise_variance = signal_power / ( 10^(SNR/10) );%看做均值=0的噪声方差
    signal_noise=sqrt(noise_variance)*NOISE;        %变换后NOISE的均值=0，方差=noise_variance。可以均值是已给数a
    signal_noise = signal_noise';                   %转成 列向量
    y_out = y + signal_noise;
    y_out_time = 1.6*(-0.5 +(y_out-min(y_out))./(max(y_out)-min(y_out)));
    if i<10
        string=[wavEn,'noise_','0',num2str(i),'.wav'];
    else
        string=[wavEn,'noise_',num2str(i),'.wav'];
    end
        
    audiowrite(string,y_out_time,fs0);
    fprintf('  完成！！');
    fprintf('\n')
    clear y，y_out
end
