%% Random Forest regression spectral model for soil nitrogen
% Datos espectrales obtenidos en LANISAF a partir de muestras de campo (La Xerona-DIMA)
% pretratados con MAS y SG derivativo
% WL seleccionadas
% Aumento con datos artificiales generados por GAN
close all;clear all;clc;

%% LOAD Data
% real data
load Xtrain;
load Ytrain;
load Xtest;
load Ytest;
%artificial data
load XGAN;
load YGAN;

 %% Opciones de inicio RF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear extra_options
extra_options.importance = 1; %(0 = (Default) Don't, 1=calculate)
extra_options.nodesize = 7; %numero de nodos por arbol
Ntrees=700;                  %Numero de arboles
NWL=5;                      %numero de variables espectrales por arbol
%% training
model = regRF_train(Xtrn,Ytrn,Ntrees,NWL,extra_options);
RMSE0=mean(sqrt(model.mse));
%% predict
Y_hat = regRF_predict(Xtst,model);
RMSEts0=sqrt(mse(Ytst-Y_hat));
SST=sum((Ytst-mean(Ytst)).^2);SSE=sum((Ytst-Y_hat).^2);
R20=1-(SSE/SST);
RPD0=std(Ytst)/RMSEts0;
figure();
 plot(Ytst,Ytst,'k-')
hold on
plot(Ytst,Y_hat,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicciones (mg kg^-^1)');
xlabel('Mediciones (mg kg^-^1)');
hold off


%% syntetic data augmentation
ex=61;% Numero de espectros sinteticos 366
for i=1:7
Xtrn1 =[Xtrn;X1(1:ex,:)];
Ytrn1 = [Ytrn;Y1(1:ex)];
model1 = regRF_train(Xtrn1,Ytrn1,Ntrees,NWL,extra_options);
RMSE1(i)=mean(sqrt(model1.mse));
%prediccion
Y_hat = regRF_predict(Xtst,model1);
RMSEts1(i)=sqrt(mse(Ytst-Y_hat));
SST=sum((Ytst-mean(Ytst)).^2);SSE=sum((Ytst-Y_hat).^2);
R21(i)=1-(SSE/SST);
RPD1(i)=std(Ytst)/RMSEts1(i);
figure();
%plot(Ytst,Y_hat,'s',Ytst,Ytst,'k-');
plot(Ytst,Ytst,'k-')
hold on
% plot(Ytst,Y_hat,'s','MarkerFaceColor',[0 0 0])
plot(Ytst,Y_hat,'o','MarkerSize',6,'MarkerEdgeColor','#4DBEEE','MarkerFaceColor','#0072BD')
ylabel('Predicted AN (mg kg^-^1)');
xlabel('Measured AN (mg kg^-^1)');
hold off
ex=ex+61;
clear Xtrn1 Ytrn1
end
%% metrics
RMSE=[RMSE0,RMSE1]
RMSEts=[RMSEts0, RMSEts1]
R2=[R20,R21]
RPD=[RPD0,RPD1]


