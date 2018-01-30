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

%AM_lap = conv2(AMgrey,conv2(gaussian_filter_3x3,laplacian,'same'),'same');

%AM_laplacian = edge(conv2(AMgrey,laplacian,'same'),'zerocross');

%show_image(AM_lap>0)
%show_image(AM_laplacian>0)

AME=AME/255;
AME4=AME4/255;
JL=JLE/255;

%9x9
a = mask(-4:4,-4:4,1.4);
%7x7
z = mask(-3:3,-3:3,1.1);
%5x5
x = mask(-2:2,-2:2,3);
%3x3
y = mask(-1:1,-1:1,2);
laplacian8 = [-1 -1 -1; -1 8 -1; -1 -1 -1];
AMG = conv2(AMgrey, a,'same');
AMlog = conv2(AMG,laplacian8,'same');

logg = conv2(a, laplacian8,'same');
AMlogg = conv2(AMgrey,logg,'same');

AM4logg = conv2(AM4grey,logg,'same');

AMjlogg = conv2(JLgrey,logg,'same');

thresholds = [0:0.2:50];
for i = 1:length(thresholds)
    t = thresholds(i);
    
    mtmp = mathlabPayMe(AMlogg,t);
    mtmp4 = mathlabPayMe(AM4logg,t);
    mtmpJ = mathlabPayMe(AMjlogg,t);
    
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
title('Laplacian of Gaussian');
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



