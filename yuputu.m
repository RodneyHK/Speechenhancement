% y=load('blue5.txt');
% y=y(:,2);
% y=y./max(y);
% plot(y);
% figure
% specgram(y)
% wavwrite(y,10000,'C:\Users\kafka\Desktop\blue5.wav')
% %  sound(y,10000)
% sogram1(2048,128,0,1,64);
Winsiz=2048;
Shift=128;
Base=0;
Mode=1;
Gray=64;
[X,Fs]=audioread('clean.wav');
X=X(:,1);
% hd=bandpass;
% X=filter(hd,X);
x=X;
n=fix((length(x)-Winsiz)/Shift)+1;
A=zeros(1+Winsiz/2,n);
s=enframe(x,Winsiz,Shift);
for i=1:n 
z=fft(s(i,:));
z=z(1:(Winsiz/2)+1);
z=z.*conj(z);
z=10*log10(z);
A(:,i)=z; 
end
L0=(A>Base);
L1=(A<Base);
B=A.*L0 +Base*L1;
L=(B- Base)./(max(max(B))- Base);
y=[0:Winsiz/2]*Fs/Winsiz;
x=[0:n-1]*Shift; 
if Mode==1 
colormap('jet' );
else
mymode =gray;
mymode =mymode (Gray: - 1:1,:);
colormap(mymode);
end
figure
imagesc(x,y,L);
axis xy;
t=(0:length(X)-1)./Fs;
figure
plot(t,X);

[X,Fs]=wavread('bag_phone.wav');
X=X(:,1);
% x=X;
% hd=bandpass;
% X=filter(hd,X);
x=X;
n=fix((length(x)-Winsiz)/Shift)+1;
A=zeros(1+Winsiz/2,n);
s=enframe(x,Winsiz,Shift);
for i=1:n 
z=fft(s(i,:));
z=z(1:(Winsiz/2)+1);
z=z.*conj(z);
z=10*log10(z);
A(:,i)=z; 
end
L0=(A>Base);
L1=(A<Base);
B=A.*L0 +Base*L1;
L=(B- Base)./(max(max(B))- Base);
y=[0:Winsiz/2]*Fs/Winsiz;
x=[0:n-1]*Shift; 
if Mode==1 
colormap('jet' );
else
mymode =gray;
mymode =mymode (Gray: - 1:1,:);
colormap(mymode);
end
figure
imagesc(x,y,L);
axis xy;
t=(0:length(X)-1)./Fs;
figure
plot(t,X);

[X,Fs]=wavread('c_omlsa.wav');
X=X(:,1);
hd=bandpass;
X=filter(hd,X);
x=X;
n=fix((length(x)-Winsiz)/Shift)+1;
A=zeros(1+Winsiz/2,n);
s=enframe(x,Winsiz,Shift);
for i=1:n 
z=fft(s(i,:));
z=z(1:(Winsiz/2)+1);
z=z.*conj(z);
z=10*log10(z);
A(:,i)=z; 
end
L0=(A>Base);
L1=(A<Base);
B=A.*L0 +Base*L1;
L=(B- Base)./(max(max(B))- Base);
y=[0:Winsiz/2]*Fs/Winsiz;
x=[0:n-1]*Shift; 
if Mode==1 
colormap('jet' );
else
mymode =gray;
mymode =mymode (Gray: - 1:1,:);
colormap(mymode);
end
figure
imagesc(x,y,L);
axis xy;
t=(0:length(X)-1)./Fs;
figure
plot(t,X);


[X,Fs]=wavread('china1 (2)gai.wav');
X=X(:,1);
hd=bandpass;
X=filter(hd,X);
x=X;
n=fix((length(x)-Winsiz)/Shift)+1;
A=zeros(1+Winsiz/2,n);
s=enframe(x,Winsiz,Shift);
for i=1:n 
z=fft(s(i,:));
z=z(1:(Winsiz/2)+1);
z=z.*conj(z);
z=10*log10(z);
A(:,i)=z; 
end
L0=(A>Base);
L1=(A<Base);
B=A.*L0 +Base*L1;
L=(B- Base)./(max(max(B))- Base);
y=[0:Winsiz/2]*Fs/Winsiz;
x=[0:n-1]*Shift; 
if Mode==1 
colormap('jet' );
else
mymode =gray;
mymode =mymode (Gray: - 1:1,:);
colormap(mymode);
end
figure
imagesc(x,y,L);
axis xy;
t=(0:length(X)-1)./Fs;
figure
plot(t,X);


[X,Fs]=wavread('b.wav');
X=X(:,1);
% x=X;
hd=bandpass;
X=filter(hd,X);
x=X;
n=fix((length(x)-Winsiz)/Shift)+1;
A=zeros(1+Winsiz/2,n);
s=enframe(x,Winsiz,Shift);
for i=1:n 
z=fft(s(i,:));
z=z(1:(Winsiz/2)+1);
z=z.*conj(z);
z=10*log10(z);
A(:,i)=z; 
end
L0=(A>Base);
L1=(A<Base);
B=A.*L0 +Base*L1;
L=(B- Base)./(max(max(B))- Base);
y=[0:Winsiz/2]*Fs/Winsiz;
x=[0:n-1]*Shift; 
if Mode==1 
colormap('jet' );
else
mymode =gray;
mymode =mymode (Gray: - 1:1,:);
colormap(mymode);
end
figure
imagesc(x,y,L);
axis xy;
t=(0:length(X)-1)./Fs;
figure
plot(t,X);

[X,Fs]=wavread('b_omlsa.wav');
X=X(:,1);
hd=bandpass;
X=filter(hd,X);
x=X;
n=fix((length(x)-Winsiz)/Shift)+1;
A=zeros(1+Winsiz/2,n);
s=enframe(x,Winsiz,Shift);
for i=1:n 
z=fft(s(i,:));
z=z(1:(Winsiz/2)+1);
z=z.*conj(z);
z=10*log10(z);
A(:,i)=z; 
end
L0=(A>Base);
L1=(A<Base);
B=A.*L0 +Base*L1;
L=(B- Base)./(max(max(B))- Base);
y=[0:Winsiz/2]*Fs/Winsiz;
x=[0:n-1]*Shift; 
if Mode==1 
colormap('jet' );
else
mymode =gray;
mymode =mymode (Gray: - 1:1,:);
colormap(mymode);
end
figure
imagesc(x,y,L);
axis xy;
t=(0:length(X)-1)./Fs;
figure
plot(t,X);


[X,Fs]=wavread('china1 (1)gai.wav');
X=X(:,1);
hd=bandpass;
X=filter(hd,X);
x=X;
n=fix((length(x)-Winsiz)/Shift)+1;
A=zeros(1+Winsiz/2,n);
s=enframe(x,Winsiz,Shift);
for i=1:n 
z=fft(s(i,:));
z=z(1:(Winsiz/2)+1);
z=z.*conj(z);
z=10*log10(z);
A(:,i)=z; 
end
L0=(A>Base);
L1=(A<Base);
B=A.*L0 +Base*L1;
L=(B- Base)./(max(max(B))- Base);
y=[0:Winsiz/2]*Fs/Winsiz;
x=[0:n-1]*Shift; 
if Mode==1 
colormap('jet' );
else
mymode =gray;
mymode =mymode (Gray: - 1:1,:);
colormap(mymode);
end
figure
imagesc(x,y,L);
axis xy;
t=(0:length(X)-1)./Fs;
figure
plot(t,X);
