%% Partial least squares regression spectral model for soil nitrogen
% Datos espectrales obtenidos en LANISAF a partir de muestras de campo (La Xerona-DIMA)
% pretratados con MAS y SG derivativo
% WL seleccionadas por algoritmo genetico
% Aumento con datos artificiales generados por GANs
close all;clear all;clc;

%% LOAD Spectra
load WLTN; %Longitudes de onda seleccionadas
load('Xtrain.mat');% X entrenamiento datos reales
load('Ytrain.mat');% Y entrenasmiento datos reales
load('Xtest.mat');% X prueba datos reales
load('Ytest.mat');% Y prueba datos reales
%Artificial data
load('XGAN.mat');%X1=XX(randvector(101:527),:);
load('YGAN.mat');%Y1=YY(randvector(101:527));

%% training and predic real data 
[RMSEP,RMSEF,R2,PREDICT]=predictt(Xtrn,Ytrn,Xtst,Ytst,WLs,10,5,'center');% predicciones con WL seleccionadas
 errortrn0=RMSEF;
 errortsn0=RMSEP;
 pred=PREDICT;
 RPD0=std(Ytst)/RMSEP;
 R20=R2;
% Grafico
 figure();
% plot(Ytst0,pred,'ko',Ytst0,Ytst0,'k-');
plot(Ytst,Ytst,'k-')
hold on
plot(Ytst,pred,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicted AN (mg kg^-^1)');
xlabel('Measured AN (mg kg^-^1)');
xlim([15 40]);
ylim([15 40]);
hold off
%% Data augmentation
ex=61;% numero de espectros artificiales para aumento 
for i=1:7
Xtrn1 =[Xtrn;X1(1:ex,:)];
Ytrn1 = [Ytrn;Y1(1:ex)];
% [WLs, RMSE]=fvGA(Xtrn1,Ytrn1,n,Ni,GGAP,Tmax); %GA fijo
%prediccion
[RMSEP,RMSEF,R2,PREDICT]=predict(Xtrn1,Ytrn1,Xtst,Ytst,WLs,10,5,'center');
 errortrn(i)=RMSEF;
 errortsn(i)=RMSEP;
 pred=PREDICT;
 RPD(i)=std(Ytst)/RMSEP;
 R2n(i)=R2;
% Grafico
 figure();
% plot(Ytst,pred,'ko',Ytst,Ytst,'k-');
plot(Ytst,Ytst,'k-')
hold on
plot(Ytst,pred,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicted AN (mg kg^-^1)');
xlabel('Measured AN (mg kg^-^1)');
xlim([15 40]);
ylim([15 40]);
hold off
ex=ex+61;
clear Xtrn1 Ytrn1
end
%% metrics
WLs
efit=[errortrn0, errortrn]
epred=[errortsn0, errortsn]
R_2=[R20, R2n]
RPD=[RPD0,RPD]
