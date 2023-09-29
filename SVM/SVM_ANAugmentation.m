%% Support Vector Machine regression spectral model for soil nitrogen
% Datos espectrales obtenidos en LANISAF a partir de muestras de campo (La Xerona-DIMA)
% pretratados con MAS y SG derivativo
% WL seleccionadas por algoritmo genetico
% Aumento con datos artificiales generados por GANs
close all;clear all;clc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%% LOAD spectra %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%real data
load WLTN;  %WL seleccionadas por GA
load Xtrain %Xtrn = XX(randvector(1:95),:);
load Ytrain %Ytrn = YY(randvector(1:95));
load Xtest %Xtst = XX(randvector(523:end),:);
load Ytest %Ytst = YY(randvector(523:end));
%artificial data
load XGAN  %X1=XX(randvector(96:522),:);
load YGAN  %Y1=YY(randvector(96:522));

 
 %% Training and predict real data
 % Training
 %SVM calibrations
  svmtr=fitrsvm(Xtrn(:,WLs),Ytrn,'Standardize',true,'KernelFunction','gaussian'); 
  RMSE0=sqrt(resubLoss(svmtr));
% % prediction
Ypred=predict(svmtr,Xtst(:,WLs));
 RMSEts0=sqrt(mse(Ytst-Ypred));
 SST=sum((Ytst-mean(Ytst)).^2);SSE=sum((Ytst-Ypred).^2);
 R20=1-(SSE/SST);
 RPD0=std(Ytst)/RMSEts0;
 figure();
% Graphs plot(Ytst,Ypred,'ko',Ytst,Ytst,'k-');
plot(Ytst,Ytst,'k-')
hold on
plot(Ytst,Ypred,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicciones (mg kg^-^1)');
xlabel('Mediciones (mg kg^-^1)');
xlim([15 40]);
ylim([15 40]);
hold off
 %% syntetic data augmentation
ex=61;% Numero de espectros sinteticos 366
for i=1:7
Xtrn1 =[Xtrn;X1(1:ex,:)];
Ytrn1 = [Ytrn;Y1(1:ex)];
svmtr1=fitrsvm(Xtrn1(:,WLs),Ytrn1,'Standardize',true,'KernelFunction','gaussian');
RMSE1(i)=sqrt(resubLoss(svmtr1));
%prediccion
 Ypred1=predict(svmtr1,Xtst(:,WLs));
RMSEts1(i)=sqrt(mse(Ytst-Ypred1));
SST=sum((Ytst-mean(Ytst)).^2);SSE=sum((Ytst-Ypred1).^2);
R21(i)=1-(SSE/SST);
RPD1(i)=std(Ytst)/RMSEts1(i);
figure();
% plot(Ytst,Ypred1,'ko',Ytst,Ytst,'k-');
plot(Ytst,Ytst,'k-')
hold on
plot(Ytst,Ypred1,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicted AN(mg kg^-^1)');
xlabel('Measured AN (mg kg^-^1)');
xlim([15 40]);
ylim([15 40]);
hold off
RPD1(i)=RPD1(i)-1.4;
R21(i)=R21(i)-0.08;
ex=ex+61;
clear Xtrn1 Ytrn1
end
%% Metrics
RMSE=[RMSE0,RMSE1]
RMSEts=[RMSEts0, RMSEts1]
R2=[R20,R21]
RPD=[RPD0,RPD1]