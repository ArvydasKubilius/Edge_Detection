clear
AM = read_image('','9343 AM.bmp');
AME = read_image('','9343 AM Edges.bmp');
AM4 = read_image('','43590 AM.bmp');
AME4 = read_image('','43590 AM Edges.bmp');
JL = read_image('','10905 JL.bmp');
JLE = read_image('','10905 JL Edges.bmp');
load filters

%extract green colour from the image, no need to make it grey
AMgrey = AM(:, :, 2);
AM4grey = AM4(:, :, 2);
JLgrey = JL(:, :, 2);

%3x3
y = mask(-3:1:3,-3:1:3,0.8);

AM_sobelX = conv2(y,sobelX,'same');
AM_sobelY = conv2(y,sobelY,'same');

AM_sobelX1 = conv2(AMgrey,sobelX,'same');
AM_sobelY1 = conv2(AMgrey,sobelY,'same');

AM4_sobelX1 = conv2(AM4grey,sobelX,'same');
AM4_sobelY1 = conv2(AM4grey,sobelY,'same');

JL_sobelX1 = conv2(JLgrey,sobelX,'same');
JL_sobelY1 = conv2(JLgrey,sobelY,'same');

%absolute value
m = mag(AM_sobelX1,AM_sobelY1);
m4 = mag(AM4_sobelX1,AM4_sobelY1);
mJL = mag(JL_sobelX1,JL_sobelY1);

%divide it by 255 so it can have values of 0 and 1 - binary image
AME=AME/255;
AME4=AME4/255;
JL=JLE/255;
%figure, show_image(AME)

%if I would change the array, there will be less matches between the images
thresholds = [0:150];
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
title('Sobel');
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


%num=num0inAME
% num=nnz(AME);
% num0inAME = TP1+FN1;



