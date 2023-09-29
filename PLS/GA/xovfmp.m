% XOVFMP.m               Fixed multi-point crossover
%
%       Syntax: NewChrom =  xovfmp(OldChrom, Px)
%       Where:
%       >OldChrom = Population to be crossed
%       >Px = Crossing Probability
%       This function takes a matrix OldChrom containing the binary
%       representation of the individuals in the current population,
%       applies crossover to consecutive pairs of individuals with
%       probability Px and returns the resulting population with a 
%       constant number of solutions in every chromosome.
%
%

% Author: Carlos Fonseca, 	Updated: Alejandro E Reyes Rivera
% Date: 28/09/93,		Date: 02-sept-2021

function NewChrom = xovfmp(OldChrom, Px);

% Identify the population size (Nind) and the chromosome length (Lind)
[Nind,N] = size(OldChrom);

if N < 2, NewChrom = OldChrom; return; end
if nargin < 2, Px = 0.7; end
if isnan(Px), Px = 0.7; end
if isempty(Px), Px = 0.7; end

Xops = floor(Nind/2);              %numero de parejas
DoCross = rand(Xops,1) < Px;       %Probabilidad de cruce(?)

c=0;
if rem(Nind,2)==0
    Ni=Nind;
else
    Ni=Nind-1;
    c=1;
end
Xops = floor(Nind/2);
DoCross = rand(Xops,1) < Px;
%% rutina de cruzamiento multipunto %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cont=1;
for k=1:2:Ni
 Cr1=OldChrom(k,:);
 Cr2=OldChrom(k+1,:);
 j=1;
 sc=0;
 % Cálculo de los puntos de cruce 
 for i=1:N
    if Cr1(i)~=Cr2(i)
        suma1=sum(Cr1(1:i));
        suma2=sum(Cr2(1:i));
        if suma1==suma2
            Pcr(j)=i;
            j=j+1;
            sc=1;
        end
    end
 end
%%% Rutina Principal
if sc~=0 %Si Pcr no esta vacio, aplicar "operacion jarocha"
    if length(Pcr)==1
        if Pcr==N
           Dec1=Cr1;
           Dec2=Cr2; 
        else
%% Operacion jarocha mono-punto
           Dec1(1:Pcr)=Cr1(1:Pcr);Dec1(Pcr+1:N)=Cr2(Pcr+1:N);
           Dec2(1:Pcr)=Cr2(1:Pcr);Dec2(Pcr+1:N)=Cr1(Pcr+1:N);
        end
    else
%% Operacion jarocha multi-punto
        
        if max(Pcr)~=N
           Pcr=[1,Pcr,N];
        else
           Pcr=[1,Pcr];
        end
        np=size(Pcr,2);
    %Matriz de pares de puntos vtn
          w=1;
          for i=1:(np-1)
              if i==1
                 vtn(w,:)=[Pcr(i),Pcr(i+1)];
                 w=w+1;
              else
                 vtn(w,:)=[Pcr(i)+1,Pcr(i+1)];
                 w=w+1;
              end
          end
%%%%%%%%%%%%%%%%% Cruzamiento %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           for i=1:size(vtn,1)
               if rem(i,2)==0
               Dec1(vtn(i,1):vtn(i,2))=Cr2(vtn(i,1):vtn(i,2));
               Dec2(vtn(i,1):vtn(i,2))=Cr1(vtn(i,1):vtn(i,2));
               else
               Dec1(vtn(i,1):vtn(i,2))=Cr1(vtn(i,1):vtn(i,2));
               Dec2(vtn(i,1):vtn(i,2))=Cr2(vtn(i,1):vtn(i,2));
               end
           end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5555    
    end
else
    Dec1=Cr1;
    Dec2=Cr2;
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%% fin de la rutina principal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 if DoCross(cont)==1
    NewChrom(k,:)=Dec1;
    NewChrom(k+1,:)=Dec2;
 else
    NewChrom(k,:)=Cr1;
    NewChrom(k+1,:)=Cr2;  
 end
 cont=cont+1;
 clear Pcr vtn Cr1 Cr2
end
if c==1
  NewChrom(Nind,:)=OldChrom(Nind,:);
end

end



% odd = 1:2:Nind-1;                  %individuos en posicion impar
% even = 2:2:Nind;                   %individuos en posicion par
% 
% % Compute the effective length of each chromosome pair
% Mask = ~Rs | (OldChrom(odd, :) ~= OldChrom(even, :)); %matriz logica que distigue las diferencias entre los individuos
% Mask = cumsum(Mask')'; %matriz con la suma acumulativa de la matriz Mask
% 
% % Compute cross sites for each pair of individuals, according to their
% % effective length and Px (two equal cross sites mean no crossover)
% xsites(:, 1) = Mask(:, Lind); %primeros puntos de cruce
% if Npt >= 2,
%         xsites(:, 1) = ceil(xsites(:, 1) .* rand(Xops, 1));
% end
% xsites(:,2) = rem(xsites + ceil((Mask(:, Lind)-1) .* rand(Xops, 1)) ...
%                                 .* DoCross - 1 , Mask(:, Lind) )+1;        %segundos puntos de cruce
% 
% % Express cross sites in terms of a 0-1 mask
% Mask = (xsites(:,ones(1,Lind)) < Mask) == ...
%                         (xsites(:,2*ones(1,Lind)) < Mask);
% 
% if ~Npt,
%         shuff = rand(Lind,Xops);
%         [ans,shuff] = sort(shuff);
%         for i=1:Xops
%           OldChrom(odd(i),:)=OldChrom(odd(i),shuff(:,i));
%           OldChrom(even(i),:)=OldChrom(even(i),shuff(:,i));
%         end
% end
% 
% % Perform crossover
% NewChrom(odd,:) = (OldChrom(odd,:).* Mask) + (OldChrom(even,:).*(~Mask));
% NewChrom(even,:) = (OldChrom(odd,:).*(~Mask)) + (OldChrom(even,:).*Mask);
% 
% % If the number of individuals is odd, the last individual cannot be mated
% % but must be included in the new population
% if rem(Nind,2),
%   NewChrom(Nind,:)=OldChrom(Nind,:);
% end
% 
% if ~Npt,                                    %si Npt es 0 
%         [ans,unshuff] = sort(shuff);
%         for i=1:Xops
%           NewChrom(odd(i),:)=NewChrom(odd(i),unshuff(:,i));
%           NewChrom(even(i),:)=NewChrom(even(i),unshuff(:,i));
%         end