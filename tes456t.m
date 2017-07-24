C = zeros(200,200,3)

numPoints=36;
centerX=50;
centerY=50;
step=(3.1432*2)/numPoints;
current=0;
i=0;
for radius=30:1:32;
for i=1:1:numPoints
    x=int64(centerX+sin(current)*(radius));
    %y=int64(centerY+cos(current)*(radius));
    C(x,50:60,1)=0.5;
    current=current+step;
end
end
imtool(C);