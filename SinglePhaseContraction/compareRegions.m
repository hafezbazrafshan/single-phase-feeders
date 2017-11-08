close all;
clear all;
load('IEEE123SinglePhaseEquivalent'); 


x0=2;
y0=2;
width=7;
height=5;
figure('Units','inches',...
'Position',[x0 y0 width height],...
'PaperPositionMode','auto');
hold on;



Z=inv(Ycheck); 
w= -Z*Y_NS*v0; 
w_min=min(abs(w)); 

lambdaMat=diag(w);
Lambda_max=abs(max(max(lambdaMat)));

A=max(sum(abs( inv(lambdaMat)*Z*diag(sL_load)*diag(1./w)),2));
B=max(sum(abs(inv(lambdaMat)*Z*diag(iL_load)),2));

C=max(sum(abs( inv(lambdaMat)*Z*lambdaMat*diag(sL_load)*diag(1./w)*diag(1./w)),2));
D=max(sum(abs(inv(lambdaMat)*Z*lambdaMat*diag(iL_load)*diag(1./w)),2));

delta=(B*Lambda_max./w_min-1).^2-4*(Lambda_max./w_min).*A;

R_1W= 0.5*(B+( w_min./Lambda_max )*(1 - sqrt(delta)));
R_2W= 0.5*(B+( w_min./Lambda_max )*(1 + sqrt(delta)));
R_3W= (w_min/Lambda_max)*(1-D-sqrt(D^2+C));
R_4W= (w_min/Lambda_max)*(1-D+sqrt(D^2+C));




lambdaMat=eye(size(diag(w)));
Lambda_max=abs(max(max(lambdaMat)));
A=max(sum(abs( inv(lambdaMat)*Z*diag(sL_load)*diag(1./w)),2));
B=max(sum(abs(inv(lambdaMat)*Z*diag(iL_load)),2));
C=max(sum(abs( inv(lambdaMat)*Z*lambdaMat*diag(sL_load)*diag(1./w)*diag(1./w)),2));
D=max(sum(abs(inv(lambdaMat)*Z*lambdaMat*diag(iL_load)*diag(1./w)),2));
delta=(B*Lambda_max./w_min-1).^2-4*(Lambda_max./w_min).*A;

R_1I= 0.5*(B+( w_min./Lambda_max )*(1 - sqrt(delta)));
R_2I= 0.5*(B+( w_min./Lambda_max )*(1 + sqrt(delta)));
R_3I= (w_min/Lambda_max)*(1-D-sqrt(D^2+C));
R_4I= (w_min/Lambda_max)*(1-D+sqrt(D^2+C));



h1=plot(1:N, (R_3I-0.0001)*diag(lambdaMat),'b-','lineWidth',2);
hold on
h2=plot(1:N, (R_3W-0.0001)*abs(w),'r--','lineWidth',2);
hold on;


set(0,'defaulttextinterpreter','latex')
set(gca,'XTick',10:10:123);
set(gca,'YTick',0.7:0.02:0.85);
xlim([1 123]);
ylim([0.76 0.83]);
% set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
set(gca,'fontSize',14); 
grid on; 
xlabel('Nodes $n$','FontName','Times New Roman'); 
set(gca,'FontName','Times New Roman');

ylabel('$R_{\max}|\lambda_n|$'); 
legendTEXT=legend([h1, h2], '$\mathbf{\Lambda}= \mathbf{I}_N$', '$\mathbf{\Lambda}= \mathrm{diag}(\mathbf{w})$');
set(legendTEXT,'interpreter','Latex'); 
set(legendTEXT,'fontSize',14); 
set(legendTEXT,'fontname','Times New Roman');
set(legendTEXT,'fontWeight','Bold');
set(legend,'orientation','Horizontal'); 
set(legend,'location','North');
set(gca,'box','on');


 print -dpdf IEEE123compareRegions
 print -depsc2 IEEE123compareRegions