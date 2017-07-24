C=zeros(200,200,1)
numPoints=36
step=(3.1432*2)/numPoints;
current=0;
for i=1:1:numPoints 
x=int64(4*sin(current));
y=int64(4*cos(current));
C(x,y,1)=0.5;
current=current+step;
end