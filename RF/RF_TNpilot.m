clear all, close all, clc
load espectros
load soilTN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sin tratar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SG=M;
%Y=TN;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% filtro de SG %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wlout=1:size(M,2);
SG=derspec(M,wlout,2,2,7);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Normalize data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y=normalize(TN,'range');
%normalizando el espectro
for i=1:size(M1,2)
   for j=1:size(M1,1)
   SG(j,i)=(M1(j,i)-min(min(M1)))/(max(max(M1))-min(min(M1)));
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% sampleo random %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N ,~] =size(SG);
randvector = randperm(N);
Xtrn = SG(randvector(1:90),:);
Ytrn = Y(randvector(1:90));
Xtst = SG(randvector(91:end),:);
Ytst = Y(randvector(91:end));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% sampleo por intervalo %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Xtrn=SG(1:90,:);
% Ytrn=Y(1:90);
% Xtst=SG(91:end,:);
% Ytst=Y(91:end);
%training RF model
RFM1=regRF_train(Xtrn,Ytrn);
Yhat=RFM1.Y_hat;
%grafico
figure();
plot(Ytrn,Yhat,'ko',Ytrn,Ytrn,'k-');
rmset=sqrt(mse(Ytrn,Yhat));
r2t=1-(sum((Ytrn-Yhat).^2)/sum((Ytrn-mean(Ytrn)).^2));
%predict TN
Y1=regRF_predict(Xtst,RFM1);
rmsep=sqrt(mse(Ytst,Y1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r2p=1-(sum((Ytst-Y1).^2)/sum((Ytst-mean(Ytst)).^2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grafico
figure();
plot(Ytst,Y1,'ko',Ytst,Ytst,'k-');
