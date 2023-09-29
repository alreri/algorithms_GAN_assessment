%% Extreme Learning Machine regression spectral model for soil nitrogen
% Datos espectrales obtenidos en LANISAF a partir de muestras de campo (La Xerona-DIMA)
% pretratados con MAS y SG derivativo
% WL seleccionadas
% Aumento con datos artificiales generados por GAN

close all;clear all;clc;
addpath('codes');
%% Load real data
load WLTN;
load Xtrain;
load Xtest;
load Ytrain;
load Ytest;
%% load artificial data
load XGAN;
load YGAN;


%% Training and Predict real data
 WL=WLs;
 % Training
 % define Options
 Opts.ELM_Type='Regrs';    % 'Class' for classification and 'Regrs' for regression
 Opts.number_neurons=25;  % Maximam number of neurons 
 Opts.Tr_ratio=0.70;       % training ratio
 Opts.Bn=0;   
 [net1]= elm_LBedit(Xtrn(:,WL),Ytrn,Opts);
  RMSEtr=net1.tr_acc;
 % prediction
 [output]=elmPredict(net1,Xtst(:,WL));
 RMSEts=sqrt(mse(Ytst-output));
 R2=net1.R2;
 RPD=std(Ytst)/RMSEts;
 figure();
%  plot(Ytst0,output,'ko',Ytst0,Ytst0,'k-');
plot(Ytst,Ytst,'k-')
hold on
plot(Ytst,output,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicted AN (mg kg^-^1)');
xlabel('Measured AN (mg kg^-^1)');
xlim([15 40]);
ylim([15 40]);
hold off
%% syntetic data augmentation
ex=61;% Numero de espectros sinteticos 366
for i=1:7
Xtrn1 =[Xtrn;X1(1:ex,:)];
Ytrn1 = [Ytrn;Y1(1:ex)];
[net1]= elm_LBedit(Xtrn1(:,WL),Ytrn1,Opts);
RMSEtr1(i)=net1.tr_acc;
%prediccion
 [output]=elmPredict(net1,Xtst(:,WL));
 RMSEts1(i)=sqrt(mse(Ytst-output));
 R2n(i)=net1.R2;
 RPD1(i)=std(Ytst)/RMSEts1(i);
 figure();
%  plot(Ytst,output,'ko',Ytst,Ytst,'k-');
plot(Ytst,Ytst,'k-')
hold on
plot(Ytst,output,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicted AN (mg kg^-^1)');
xlabel('Measured AN (mg kg^-^1)');
xlim([15 40]);
ylim([15 40]);
hold off
ex=ex+61;
clear Xtrn1 Ytrn1
end

%% Metrics
efit=[RMSEtr, RMSEtr1]
epred=[RMSEts, RMSEts1]
R_21=[R2,R2n]
RPD=[RPD,RPD1]