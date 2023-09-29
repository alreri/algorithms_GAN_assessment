%% Data analisys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%b=k;
clear all; close all; clc
addpath('pretreats','distributionPlot');
load('espectros.mat')
load Xs 
load soilTN
load TNs
load WL
X0=smooth(M);% Suavizado MAS
%% PCA analysis
X0n=normalize(X0,'range',[0,1]) ;
Xsn=normalize(Xs, 'range',[0,1]);
[coef,score,~,~,xplain]=pca(X0n);
[coef1,score1,~,~,xplain1]=pca(Xsn);

%% PCA proyection
%original data
ncomp=2;
X0c=X0n-mean(X0n);
X0red=X0c*coef(:,1:ncomp);
%syntetical
Xsc=Xsn-mean(Xsn);
Xsred=Xsc*coef1(:,1:ncomp);
%% muestra los diagramas de violin con los cuantiles 
distributionPlot(Xsred(:,1),'histOri','right','color',[0 0.4470 0.7410],'widthDiv',[6 2],'showMM',6);
distributionPlot(X0red(:,1),'histOri','left','color',[0.3010 0.7450 0.9339],'widthDiv',[6 1],'showMM',6);
distributionPlot(Xsred(:,2),'histOri','right','color',[0 0.4470 0.7410],'widthDiv',[6 6],'showMM',6);
distributionPlot(X0red(:,2),'histOri','left','color',[0.3010 0.7450 0.9339],'widthDiv',[6 5],'showMM',6);
 xlim([0.5 2.3]);
 %% errobar
Xsprom=mean(Xs);
EDXs=std(Xs);
Mprom=mean(M);
EDM=std(M);
figure();
% errorbar(1:size(M,2),Mprom,EDM,'color',[0.3010 0.7450 0.9339],'LineWidth',1.5);
errorbar(WL,Mprom,EDM,'color',[0.3010 0.7450 0.9339],'LineWidth',1.5,'MarkerSize',5);
hold on
errorbar(WL,Xsprom,EDXs,'color',[0 0.4470 0.7410],'LineWidth',1.5,'MarkerSize',5);
plot(WL,Mprom,'-k','LineWidth',1);
plot(WL,Xsprom,'-r','LineWidth',1);
hold off
%  MarkerFaceAlpha
%% estadisticas del elemento TN
minTN=min(TN)
minTNS=min(TNs)
maxTN=max(TN)
maxTNs=max(TNs)
promTN=mean(TN)
promTNs=mean(TNs)
medTN=median(TN)
medTNs=median(TNs)
D_estTN=std(TN)
D_estTNs=std(TNs)
asim_TN=skewness(TN)
asim_TNs=skewness(TNs)
CV_TN=(D_estTN/promTN)*100
CV_TNs=(D_estTNs/promTNs)*100
% histogramas
figure();
tiledlayout('flow');
nexttile
histogram(TN,'FaceColor','b','FaceAlpha',.3)
ylim([0 50]);
title('NT Real');
xlabel('mg kg^-^1');
ylabel('Frecuencia');
nexttile
histogram(TNs,'FaceColor','r','FaceAlpha',.3)
ylim([0 120]);
title('NT Artificial');
xlabel('mg kg^-^1');
ylabel('Frecuencia');
% boxplots
v=randperm(length(TNs),length(TN));
nexttile([2,2]);
boxplot([TN,TNs(v)], 'Notch','on','Labels',{'NT Real','NT artificial'});
ylabel('mg kg^-^1');
%% graficos de tendencias 

%PLS
v0=[95,156,217,278,339,400,461,522];
efit_PLS=[3.476, 2.786,3.192,3.104,3.476,3.402,3.54,3.511];
epred_PLS=[4.224,4.097,3.958,3.864,3.9381,3.883,3.828,3.783];
R2_PLS=[0.5445,0.714,0.6,0.604,0.548,0.562,0.513,0.524];
RPD_PLS=[1.052,1.362,1.401,1.441,1.416,1.434,1.453,1.47];
%SVM
efit_SVM=[1.21972,0.94054,0.8395,0.78616,0.76338,0.7625,0.73978,0.72066];
epred_SVM=[2.59276	2.0818	1.87724	1.8582	1.8381	1.61342	1.60208	1.59732];
R2_SVM=[0.63592	0.76662	0.80688	0.80988	0.81364	0.85684	0.85916	0.8601];
RPD_SVM=[1.7822	2.21354	2.5148	2.54982	2.57504	2.88962	2.90038	2.9062];
% RF
efit_RF=[3.03768 2.80954 2.46168 2.10022 2.14352 2.0718	2.15036	2.10364];
epred_RF=[3.53104 2.71444 2.51836 2.39896 2.2786 2.20992 2.09908 2.10196];
R2_RF=[0.57998 0.7518 0.78634 0.80616 0.82512 0.83546 0.85156 0.85116];
RPD_RF=[1.57066	2.04302	2.20226	2.31168	2.43376	2.5102	2.64192	2.6384];
%ELM
efit_ELM=[3.85072 2.86194 3.62838 4.0967 4.13064 4.31722 4.53314 4.26924];
epred_ELM=[5.20138 5.27322 4.76794 4.64086 4.11388 4.427 4.24468 3.64214];
R2_ELM=[0.3321 0.41362 0.44458 0.44848 0.55006 0.5482 0.54538 0.54656];
RPD_ELM=[1.0835	1.05694	1.18774	1.20494	1.39564	1.2822	1.32154	1.54562];
%Grups
epred=[epred_PLS;epred_ELM;epred_SVM;epred_RF];
efit=[efit_PLS;efit_ELM;efit_SVM;efit_RF]
RPD=[RPD_PLS;RPD_ELM;RPD_SVM;RPD_RF];
R2=[R2_PLS;R2_ELM;R2_SVM;R2_RF];
%Graps
figure();
tiledlayout('flow');
for j=1:4
nexttile
hold on
xlim([80 600])
xlabel('No. de muestras');
yyaxis left
plot(v0,epred(j,:),'-s','MarkerFaceColor','blue');
ylim([min(epred(j,:))-0.5 max(epred(j,:))+0.5]);
if (j==1)||(j==3),ylabel('RMSEp'), end
yyaxis right
plot(v0,R2(j,:),'-diamond','MarkerFaceColor','red');
ylim([min(R2(j,:))-0.5 1.1])% max(R2(j,:))+0.5]);
if (j==2)||(j==4),ylabel('Coeficiente R2'), end
hold off
end
%% Grafico comparativo
% figure();
% hold on
% barh(1:numel(epred),epred,'b','FaceAlpha',0.5,'BarWidth',0.4);
% barh(1:numel(RPD),-RPD,'r','FaceAlpha',0.5,'BarWidth',0.4);
% 
% yticks(1:numel(v0));
% yticklabels(v0);
% hold off
% comparativo todos
figure();

for i=1:length(efit)
    vv=[efit(i),epred(i),R2(i),RPD(i)];
    VV(i,:)=vv;
%     ax=nexttile;
%     barh(v0(i),vv); 
end
 barh(v0,VV); 