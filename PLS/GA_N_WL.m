%% algoritmo genético para conocer las variables espectrales clave para N
close all;clear all;clc;
addpath('pretreats','GA');
load('espectros.mat');
load('soilTN.mat');
load WL;
%% correccion de datos
X0=smooth(M);% Suavizado MAS
X=derspec(X0,WL,1,3,7);% 1ra derivada de la reflectancia
Y=TN;
%% division de datos
[N ,~] =size(X);
 randvector = randperm(N);
% randvector=csvread('randTN.csv');
Xtrn = X(randvector(1:100),:);
Ytrn = Y(randvector(1:100));
Xtst = X(randvector(101:end),:);
Ytst = Y(randvector(101:end));

%% GA tunning
n=15;    
Ni=50;  
GGAP = 0.7;
Tmax = 1000;
 rng('shuffle','twister');
%% GA selection
 [WLs, RMSE]=fvGA(Xtrn,Ytrn,n,Ni,GGAP,Tmax); %GA fijo
% [WLs, RMSE]=funGA(Xtrn,Ytrn,Ni,GGAP,Tmax); %GA estandar