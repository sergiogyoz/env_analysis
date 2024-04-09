basedir = cd;
subdir1 = "\Spectral\wavelet-coherence-master";


seriesname={'AO' 'BMI'};
d1=load(basedir + subdir1 + '\faq\jao.txt');
d2=load(basedir + subdir1 + '\faq\jbaltic.txt');

d2(:,2)=boxpdf(d2(:,2));

%plot(d2(:,1),d2(:,2));

figure('color',[1 1 1])
tlim=[min(d1(1,1),d2(1,1)) max(d1(end,1),d2(end,1))];
subplot(2,1,1);
wt(d1);
title(seriesname{1});
set(gca,'xlim',tlim);
subplot(2,1,2)
wt(d2)
title(seriesname{2})
set(gca,'xlim',tlim)

% xwt
figure('color',[1 1 1])
xwt(d1,d2)
title(['XWT: ' seriesname{1} '-' seriesname{2} ] )
% wtc
figure('color',[1 1 1])
wtc(d1,d2)
title(['WTC: ' seriesname{1} '-' seriesname{2} ] )


