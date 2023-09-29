function [WLs,RMSE] = funGA(W,Y,Ni,GGAP,Tmax)
%% fGA 
%--------------Universidad Autonoma Chapingo-----------------------------%%
%                  Ingeniería Agrícola
%Function such employs genetic algoritmhs coupled wiyh PLS for variable selection in NIR spectral problems
%inputs:
%W = spectral data
%Y = independent variable (measured parameter)
%n = Constant number of potential solutions 
%Ni = Chromosomes per generation
%GGAP = Generational gap 
%Tmax = Generations
%outputs:
%WLs = id of selected wavelengths 
%RMSE = Fit value 
%...
%% Initial random population with Ni individuals of n spectral variables
N=size(W,2); %Number of spectrum variables
% for k=1:Ni
% Crom=zeros(1,N);
%   h1=sum(Crom);
%    while h1<n
%     h=randi(N);
%     Crom(h)=1;
%     h1=sum(Crom);
%    end
%   P0(k,:)=Crom;
% end

P0=zeros(Ni,N);
for i=1:Ni
vec=randperm(N,30);
P0(i,vec)=1;
end

%% Solutions extraction on each chromosome and population fitness assessment 

for j=1:size(P0,1)
    cont=1;
    for i=1:size(P0,2)
        if P0(j,i)==1
        IntPLS(:,cont)=W(:,i);
        cont=cont+1;
        end
    end
        CV=plscvfold(IntPLS,Y,3); %PLS calibrations
        RMSE(j)=CV.RMSECV;
        clear intPLS
end
ObjV=RMSE';
Chrom=P0;
best=min(ObjV);
gen=1;
cont0=0;

while gen <= Tmax
%Parents selection
FitnV = ranking(ObjV);
SelCh = select('RWS', Chrom, FitnV, GGAP);  %%funciones de bajo nivel de seleccion, probar: rws & sus
%Parents crossover 
SelCh = recombin('xovmp',SelCh,0.9);
%mutation
SelCh = MUTATE('mut',SelCh);
%% offspring evaluation
for j=1:size(SelCh,1)
    cont=1;
    for i=1:size(SelCh,2)
        if SelCh(j,i)==1
        IntPLS(:,cont)=W(:,i);
        cont=cont+1;
        end
    end
        CV=plscvfold(IntPLS,Y,3);
        RMSEs(j)=CV.RMSECV;
        clear intPLS
    
end
ObjVSel=RMSEs';
%% reinsertion to population
[Chrom, ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel); 
best(gen)= min(ObjV);
generacion(gen)=gen;
plot(generacion,best,'ro')
xlabel('Generation') 
ylabel('Fit Value')
drawnow
gen = gen+1
fVal=min(ObjV)

end
%% search for the best individual
pos=1;
while ObjV(pos,1)~=best
pos=pos+1;
end
varselect=Chrom(pos,:);
%% selected WLs(ID)
r=1;
for i=1:size(varselect,2)
if varselect(1,i)==1
wl(r,1)=i;
r=r+1;
end
end
%% Outputs
WLs=wl;
RMSE=fVal;
end