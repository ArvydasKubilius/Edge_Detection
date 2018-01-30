clear
AM = read_image('','9343 AM.bmp');
AME = read_image('','9343 AM Edges.bmp');
AM4 = read_image('','43590 AM.bmp');
AME4 = read_image('','43590 AM Edges.bmp');
JL = read_image('','10905 JL.bmp');
JLE = read_image('','10905 JL Edges.bmp');

load filters
load roberts

AMgrey = AM(:, :, 2);
AM4grey = AM4(:, :, 2);
JLgrey = JL(:, :, 2);

%9x9
a = mask(-4:4,-4:4,0.7);
AM_robertsB = conv2(a,robertsB,'same');
AM_robertsA = conv2(a,robertsA,'same');
AM4_robertsA1 = conv2(AM4grey,robertsA,'same');
AM4_robertsB1 = conv2(AM4grey,robertsB,'same');
m4 = mag(AM4_robertsA1,AM4_robertsB1);


AM_robertsA1 = conv2(AMgrey,robertsA,'same');
AM_robertsB1 = conv2(AMgrey,robertsB,'same');
m = mag(AM_robertsA1,AM_robertsB1);

AMj_robertsA1 = conv2(JLgrey,robertsA,'same');
AMj_robertsB1 = conv2(JLgrey,robertsB,'same');
mJL = mag(AMj_robertsA1,AMj_robertsB1);

AME=AME/255;
AME4=AME4/255;
JL=JLE/255;


thresholds = [0:0.5:50];
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
title('Roberts');
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

