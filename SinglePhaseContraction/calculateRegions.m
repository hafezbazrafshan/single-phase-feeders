function [ validRange, alphaVec, A,B,C,D] = calculateRegions( network ,lambdaMat,...
    plotOptions, figurename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if nargin < 2
    plotOptions='no-plots';
    figurename='';
lambdaMat=eye(size(diag(network.w)));
end

% this code uses v2struct

v2struct(network); 

w_min=min(abs(w)); 

Lambda_max=abs(max(max(lambdaMat)));


A=max(sum(abs( inv(lambdaMat)*Z*diag(sL_load)*diag(1./w)),2));
B=max(sum(abs(inv(lambdaMat)*Z*diag(iL_load)),2));

C=max(sum(abs( inv(lambdaMat)*Z*lambdaMat*diag(sL_load)*diag(1./w)*diag(1./w)),2));
D=max(sum(abs(inv(lambdaMat)*Z*lambdaMat*diag(iL_load)*diag(1./w)),2));

% delta=(B*Lambda_max./w_min-1).^2-4*(Lambda_max./w_min).*A;





Rdist=0.01;
Rset=0:Rdist:w_min./Lambda_max-Rdist;


f1Cnt=1;
f2Cnt=1;
f3Cnt=1;
f4Cnt=1;
Rpr1=Rset(1); 
Rpr2=Rset(1); 
Rpr3=Rset(1);
Rpr4=Rset(1); 



f1Set=[];
f2Set=[];
f3Set=[];
f4Set=[];


for rCnt=1:length(Rset)

    
    
    R=Rset(rCnt);
  

denom= 1-  R*Lambda_max./w_min; 

f1= 1- R *Lambda_max/w_min;
f2=  A./denom + B - R;
f3= C./(denom.^2)+ 2*D./denom - 1; 

if f1>0 
%     if (abs(Rpr1-R) > 1.1 * Rdist)
%         f1Cnt=f1Cnt+1;
%         f1Set(f1Cnt)=[];
%         
%     end
    f1Set=[f1Set, R];
%     Rpr1=R;
end

if f2<0 
%     if (abs(Rpr2-R) > 1.1 * Rdist)
%         f2Cnt=f2Cnt+1;
%         f2Set{1,f2Cnt}=[];
%         
%     end
    f2Set=[f2Set,R];
%     Rpr2=R;
end
% 
% 
if f3<=0 
%     if (abs(Rpr3-R) > 1.1* Rdist)
%         f3Cnt=f3Cnt+1;
%         f3Set{1,f3Cnt}=[];
%         
%     end
    f3Set=[f3Set,R];
%     Rpr3=R;
end
% 
% 

end

%% Plotting the conditions
f4Set=intersect(intersect(f1Set,...
    f2Set),f3Set);




if strcmp(plotOptions,'yes-plot')


x0=2;
y0=2;
width=7;
height=1.7;
figure('Units','inches',...
'Position',[x0 y0 width height],...
'PaperPositionMode','auto');
hold on;



h1=plot(f1Set(1:2:end), ones(size(f1Set(1:2:end)))...
    -0.04,'b+','lineWidth',3);
hold on
h2=plot(f2Set(1:2:end), ones(size(f2Set(1:2:end)))...
    -0.03,'r^','lineWidth',3);
hold on;
h3=plot(f3Set(1:2:end), ones(size(f3Set(1:2:end)))...
    -0.02,'gs','lineWidth',3);
hold on;
h4=plot(f4Set(1:2:end), ones(size(f4Set(1:2:end)))...
    -0.01,'ko','lineWidth',2);





set(0,'defaulttextinterpreter','latex')
set(gca,'XTick',Rset(1):10*Rdist:R(end));
% set(gca,'YTick',0.97:0.01:1.03);
xlim([-0.1*R(end) R(end)+0.1*R(end)]);
ylim([0.95 1.05]);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
set(gca,'fontSize',14); 
grid on; 
xlabel('$R$','FontName','Times New Roman'); 
set(gca,'FontName','Times New Roman');

% ylabel('Acceptable region of $R$'); 
legendTEXT=legend([h1, h2, h3, h4], '$\mathcal{C}_1$', '$\mathcal{C}_2$', ...
    '$\mathcal{C}_3$', '$\mathcal{C}$');
set(legendTEXT,'interpreter','Latex'); 
set(legendTEXT,'fontSize',14); 
set(legendTEXT,'fontname','Times New Roman');
set(legendTEXT,'fontWeight','Bold');
set(legend,'orientation','Horizontal'); 
set(legend,'location','North');
set(gca,'box','on');

if exist('Figures')~=7
    mkdir('Figures'); 
end
cd('Figures');
 print('-dpdf', figurename);
 print('-depsc2', figurename);
 cd('..');
end


%% Intersecting the regions to find a validRange for R
validRange=intersect(intersect(intersect(f1Set,...
    f2Set),f3Set),f4Set);


%% Calculating alpha for the valid range of R
alphaVec=zeros(size(validRange));






for rCnt=1:length(validRange)

    
    
R=validRange(rCnt);
  
denom= 1-  R*Lambda_max./w_min; 
alphaVec(rCnt)= C./(denom.^2)+ 2*D./denom ;



end










end

