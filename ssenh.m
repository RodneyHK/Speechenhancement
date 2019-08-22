clc
clear all 
close all

waveDir='C:\Users\Riven_tutu\Desktop\speech_enhancement\noi\';
noiseData_loc = dir(waveDir);
noiseData_loc(1:2) = [];
noiseNum=length(noiseData_loc);%speakerNum:����
wavEn = 'C:\Users\Riven_tutu\Desktop\speech_enhancement\aftss\'

fprintf('\n��ȡ�����ļ�������������ǿ...\n\n');

for i=1:noiseNum
    fprintf('\n������ǿ��%d����%s������', i, noiseData_loc(i,1).name(1:end-4));
    [y, fs0]=audioread([waveDir,noiseData_loc(i,1).name]);
    [y_out_time,fs] = ss_fu(y,fs0);
    if i<10
        string=[wavEn, 'paper_bag_','0',num2str(i),'.wav'];
    else
        string=[wavEn, 'paper_bag_',num2str(i),'.wav'];
    end
        
    audiowrite(string,y_out_time,fs);
    fprintf('  ��ɣ���');
    fprintf('\n')
    clear y��y_out
end