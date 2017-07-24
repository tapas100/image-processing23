clear all;
x=[1,1,1,1,1];
nx=-2:2;
w=-2*pi:2*pi/100:2*pi;
y=zeros(size(w));
p=1;
k=1;
for w1=-2*pi:2*pi/100:2*pi
for n1=-2:2
    temp=x(k)*exp(-j*w1*n1);
    y(p)=y(p)+temp;
    k=k+1;
end
p=p+1;
t=0;
k=1;
end
subplot(3,1,1)
stem(nx,x);
xlabel('angular frequency');
ylabel('amplitude');
subplot(3,1,2);
plot(w,abs(y));
xlabel('angular frequency')
ylabel('absolute value');
subplot(3,1,3);
plot(w,angle(y));

xlabel('angular frequency')
ylabel('phase angle');