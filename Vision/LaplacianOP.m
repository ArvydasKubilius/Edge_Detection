clear
AM = read_image('','9343 AM.bmp');
AME = read_image('','9343 AM Edges.bmp');
AM4 = read_image('','43590 AM.bmp');
AME4 = read_image('','43590 AM Edges.bmp');
JL = read_image('','10905 JL.bmp');
JLE = read_image('','10905 JL Edges.bmp');
load filters


laplacian4 = [0 -1 0; -1 4 -1; 0 -1 0];
laplacian8 = [-1 -1 -1; -1 8 -1; -1 -1 -1];
AMgrey = AM(:, :, 2);
AM4grey = AM4(:, :, 2);
JLgrey = JL(:, :, 2);



AMgrey = conv2(AMgrey,laplacian4,'same');
AM4grey = conv2(AM4grey,laplacian4,'same');
JLgrey = conv2(JLgrey,laplacian4,'same');

AME=AME/255;
AME4=AME4/255;
JL=JLE/255;

thresholds = [0:0.5:230];
for i = 1:length(thresholds)
    t = thresholds(i);
    mtmp = mathlabPayMe(AMgrey,t);
    mtmp4 = mathlabPayMe(AM4grey,t);
    mtmpJ = mathlabPayMe(JLgrey,t);
    
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
title('Laplacian');
xlabel('1 - Specificity');
ylabel('Sensitivity');
grid on
hold on
plot(spec4, sen4);

plot(specJ, senJ);
legend('9343 AM','43590 AM', '10905 JL','southeast');

hold off
xlim([0 1])
ylim([0 1])



