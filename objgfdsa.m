clc;
clear all;
vid=webcam;
while 1
    im=snapshot(vid);
    [im_yellow num]=green(im);
    [B,L]=bwboundries(im_yellow,'noholes');
    imshow(label2rgb(L,@jet,[.5,.5,.5]));
    hold on
    for k=1:length(b)
        boundary=B{k};
        plot(boundary(:,2),boundary(:,1),'w','Line Width',2)
   end
    x=boundary(:,1);
    y=boundary(:,2);
    abc=[x y ones(length(x),1)]\-(x.^2+y.^2);
    a=abc(1);b=abc(2);c=abc(3);
    xc=-a/2;
    yc=-b/2;
    radius=sqrt((xc^2+yc^2)-c);
   imshow(im);
   hold on
   plot(yc,xc,'yx','Line Width',2);
   theta=0:0.01:2*pi;
   xfit=radius*cos(theta)+xc;
   yfit=radius*sin(theta)+yc;
   plot(yfit,xfit);
   message=sprintf('the estimaed radius is %2.3f pixel',radius);
   text(15,15,message,'color','y','Font Weight','BOLD');
end
   
   