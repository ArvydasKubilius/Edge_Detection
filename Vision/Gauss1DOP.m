clear
AM = read_image('','9343 AM.bmp');
AME = read_image('','9343 AM Edges.bmp');
AM4 = read_image('','43590 AM.bmp');
AME4 = read_image('','43590 AM Edges.bmp');
JL = read_image('','10905 JL.bmp');
JLE = read_image('','10905 JL Edges.bmp');
load filters

AMgrey = AM(:, :, 2);
AM4grey = AM4(:, :, 2);
JLgrey = JL(:, :, 2);

%5x5
x = mask(-2:2,-2:2,1.4);

AM_Gauss1 = conv2(x,first_order_gaussian_filter_1d_length5,'same');
AM_Gauss2 = conv2(x,first_order_gaussian_filter_1d_length5','same');

AM_Gauss11 = conv2(AMgrey,AM_Gauss1,'same');
AM_Gauss22 = conv2(AMgrey,AM_Gauss2,'same');

AM_Gauss4 = conv2(AM4grey,AM_Gauss1,'same');
AM_Gauss44 = conv2(AM4grey,AM_Gauss2,'same');

AM_GaussJ1 = conv2(JLgrey,AM_Gauss1,'same');
AM_GaussJ2 = conv2(JLgrey,AM_Gauss2,'same');
m=mag(AM_Gauss11,AM_Gauss22);
m4=mag(AM_Gauss4,AM_Gauss44);
mJL=mag(AM_GaussJ1,AM_GaussJ2);

AME=AME/255;
AME4=AME4/255;
JL=JLE/255;

%show_image(n>1)



thresholds = [0:0.2:50];
for i = 1:numel(thresholds)
    t = thresholds(i);
   
    mtmp=m>t;
    mtmp4=m4>t;
    mtmpJ=mJL>t;
    
    tp(i) = nnz(mtmp&AME);
    fp(i) = nnz(mtmp&~AME);
    fn(i) = nnz(~mtmp&AME);
    tn(i) = nnz(~mtmp&~AME);
    
    tp4(i) = nnz(mtmp4&AME4);
    fp4(i) = nnz(mtmp4&~AME4);
    fn4(i) = nnz(~mtmp4&AME4);
    tn4(i) = nnz(~mtmp4&~AME4);
    
    tpJ(i) = nnz(mtmpJ&JL);
    fpJ(i) = nnz(mtmpJ&~JL);
    fnJ(i) = nnz(~mtmpJ&JL);
    tnJ(i) = nnz(~mtmpJ&~JL);
end

%sensitivity and specificity
sen=tp./(tp+fn);
spec=1-tn./(tn+fp);
dist=sqrt(spec.^2+(sen-1).^2);

sen4=tp4./(tp4+fn4);
spec4=1-tn4./(tn4+fp4);
%dist=sqrt(spec.^2+(sen-1).^2);

senJ=tpJ./(tpJ+fnJ);
specJ=1-tnJ./(tnJ+fpJ);
dist=sqrt(spec.^2+(sen-1).^2);
%ROC space
figure, plot(spec,sen);
title('Gaussian');
xlabel('1 - Specificity');
ylabel('Sensitivity');

hold on
plot(spec4, sen4);

plot(specJ, senJ);
legend('9343 AM','43590 AM', '10905 JL','southeast');
grid on
hold off
xlim([0 1])
ylim([0 1])


%hold on
%plot(spec(b),sen(b),'*r')
%[a,b]=min(dist)


