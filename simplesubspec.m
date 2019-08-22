function output=simplesubspec(signal,wlen,inc,NIS,a,b)
wnd=hamming(wlen);                      % ���ô�����
N=length(signal);                       % �����źų���

y=enframe(signal,wnd,inc)';             % ��֡
fn=size(y,2);                           % ��֡��

y_fft = fft(y);                         % FFT
y_a = abs(y_fft);                       % ��ȡ��ֵ
y_phase=angle(y_fft);                   % ��ȡ��λ��
y_a2=y_a.^2;                            % ������
Nt=mean(y_a2(:,1:NIS),2);               % ����������ƽ������
nl2=wlen/2+1;                           % �����Ƶ�ʵ�����

for i = 1:fn;                           % �����׼�
    for k= 1:nl2
        if y_a2(k,i)>a*Nt(k)
            temp(k) = y_a2(k,i) - a*Nt(k);
        else
            temp(k)=b*y_a2(k,i);
        end
        U(k)=sqrt(temp(k));             % �����������÷�ֵ
    end
    X(:,i)=U;
end;
output=OverlapAdd2(X,y_phase(1:nl2,:),wlen,inc);   % �ϳ��׼��������
Nout=length(output);                    % ���׼�������ݳ��Ȳ���������ȳ�
if Nout>N
    output=output(1:N);
elseif Nout<N
    output=[output; zeros(N-Nout,1)];
end
output=output/max(abs(output));         % ��ֵ��һ