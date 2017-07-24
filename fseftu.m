clear all;
x=[1,1,1,1,1,1];
nx=-2:3;
w=-2*pi:2*pi/100:2*pi;
y=exp(-j*nx'*w);
subplot(3,1,1)
z=x*y;
stem(nx,x);
xlabel('angular frequency');
ylabel('amplitude');
subplot(3,1,2);
plot(w,abs(z));
xlabel('angular frequency')
ylabel('absolute value');
subplot(3,1,3);
plot(w,angle(z));
xlabel('angular frequency')
ylabel('phase angle');