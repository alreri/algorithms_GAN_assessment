%%                          Spectral pretreatment
%                    Moving average smoothing & SG derivative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;
load espectrosTN % espectros originales Mtn
load espMAST %espectros suavizados con moving average smooth MAS Mt
 
load soilTN % target
load WL
% Mmas=smooth(Mtn);
%espectros derivados
MASSG1=derspec(Mtn,WL,1,3,7);


%%%%%%%
figure()
t=tiledlayout(1,2);
ax1=nexttile;
for i=1:size(Mtn,1)
   plot(ax1,WL,Mtn(i,:))
   hold on
end
% ax2=nexttile;
% for i=1:size(Mmas,1)
% plot(ax2,WL,Mt(i,:))
% hold on
% end
ax2=nexttile;
for i=1:size(MASSG1,1)
plot(ax2,WL,MASSG1(i,:))
hold on
end

%  linkaxes([ax1,ax2],'x');

xlabel(t,'Wavelength (nm)','Fontsize',10,'Fontname','Palatino Linotype');
ylabel (t,'Reflectance','Fontsize',10,'Fontname','Palatino Linotype');

% xticklabels(ax1,{})
t.TileSpacing = 'compact';
