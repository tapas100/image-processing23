C = zeros(1200,1200,3)

numPoints=2304*6;
centerX=600;
centerY=600;
step=(3.1432*2)/numPoints;
current=0;
i=0;
for radius=350:1:385;
for i=1:1:numPoints
    x=int64(centerX+sin(current)*(radius));
    y=int64(centerY+cos(current)*(radius));
    C(x,y,1)=0.9;
    current=current+step;
end
end
imtool(C);