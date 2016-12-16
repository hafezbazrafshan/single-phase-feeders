clear all;
clc;
cd('Case Studies/'); 
load('IEEE13SinglePhaseData'); 
cd('..'); 



 vPr=repmat(v0,N,1);   



 


 maxIt=5;
  nVars=length(vPr);
gamma=1.5;
 for it=1:maxIt
 
 fv= calculateIPQIISinglePhase(vPr, gMat, sL_load,iL_load,yL_load );
 err=sum(abs(Ycheck*vPr+fv+Y_NS*v0));
str=['Iteration No. ', num2str(it),' Error is ', num2str(err), '\n'];
fprintf(str);

vNew= Ycheck\ (-fv)+ w;

 vPr=vNew;

 end



 
 vsol=vNew;
 
vsol=[vsol;v0];
v=zeros(3*(N+1),1);

resultsVmag=abs(v);
resultsVPhase=180*(angle(v)-2*pi*floor(angle(v)/(2*pi)))/pi;


