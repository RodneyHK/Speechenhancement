function soundSegment=findSegment(express)
if express(1)==0
    voicedIndex=find(express);                     % Ѱ��express��Ϊ1��λ��
else
    voicedIndex=express;
end

soundSegment = [];
k = 1;
soundSegment(k).begin = voicedIndex(1);            % ���õ�һ���л��ε���ʼλ��
for i=1:length(voicedIndex)-1,
	if voicedIndex(i+1)-voicedIndex(i)>1,          % �����л��ν���
		soundSegment(k).end = voicedIndex(i);      % ���ñ����л��εĽ���λ��
		soundSegment(k+1).begin = voicedIndex(i+1);% ������һ���л��ε���ʼλ��  
		k = k+1;
	end
end
soundSegment(k).end = voicedIndex(end);            % ���һ���л��εĽ���λ��
% ����ÿ���л��εĳ���
for i=1 :k
    soundSegment(i).duration=soundSegment(i).end-soundSegment(i).begin+1;
end
