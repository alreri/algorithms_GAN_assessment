Px=0.7;
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
 Cr1=P0(k,:);
 Cr2=P0(k+1,:);
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
    NewP(k,:)=Dec1;
    NewP(k+1,:)=Dec2;
 else
    NewP(k,:)=Cr1;
    NewP(k+1,:)=Cr2;  
 end
 cont=cont+1;
 clear Pcr vtn Cr1 Cr2
end
if c==1
  NewP(Nind,:)=P0(Nind,:);
end