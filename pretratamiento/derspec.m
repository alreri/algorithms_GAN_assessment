function SG=derspec(X,wlout,ddx,N,F)
% The function calculates derivative of spectral dataset (multiple spectrum input) in Savitzky-Golay
% smoothing and derivative implementation 

% X - spectral data matrix, where each row is an independent spectrum of a sample. 
% The number of rows represenst number of samples
% wlout - is a rowvector of wavelength where spectum is recorded
% ddx - the order of spectral derivative desired. ddx=0 : smoothing, ddx=1,
% first derivative, ddx=2 second derivative
% N - Order of polynomial fit
% F - Window length


[m,p] = size(X); %% m number of sample, p is spectrum wavelength span  
dt=(wlout(1)-wlout(2));
HalfWin  = ((F+1)/2) -1;

[~,g] = sgolay(N,F);   % Calculate S-G coefficients

SG = zeros(m,p);
v1=g(:,ddx+1)';
v2=repmat(v1,m,1);

for n = (F+1)/2:p-(F+1)/2,
  
   v3=X(:,n - HalfWin: n + HalfWin);

switch ddx
    case 0
        SG(:,n)=dot(v2,v3,2);
    case 1
        SG(:,n)=dot(v2,v3,2);
    case 2
        SG(:,n)=2*dot(v2,v3,2)';
end
    
   
end

switch ddx
    case 0 
    case 1
       SG = SG/dt;   
    case 2
       SG = SG/(dt*dt);
end
  
cut=(F+1)/2:p-(F+1)/2;
figure()
plot (wlout(cut),SG(:,cut))
whos wlout SG
end

