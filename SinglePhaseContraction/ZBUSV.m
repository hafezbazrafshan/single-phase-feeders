function [ alphaMax, alphaNumeric, success, vSol, vIterations, err ] = ZBUSV( network , vPr, maxIt)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    maxIt=5;
end
success=0;
v2struct(network); 
err=inf+zeros(maxIt+1,1);
Lambda=eye(size(diag(w))); 
Lambda_max=max(abs(w)); 
Lambda_min=min(abs(w)); 

vIterations=zeros(size(vPr,1),maxIt+1);
vIterations(:,1)=vPr;
fv= calculateIPQIISinglePhase(vPr, gMat, sL_load,iL_load,yL_load );
 err(1)=sum(abs(-vPr-Z*fv+w));
str=['Iteration No. ', num2str(0),' Error is ', num2str(err(1)), '\n'];
fprintf(str);
 for it=1:maxIt
vNew= Ycheck\ (-fv-Y_NS*v0);
vIterations(:,it+1)=vNew;

 
  fv= calculateIPQIISinglePhase(vNew, gMat, sL_load,iL_load,yL_load );
 err(it+1)=sum(abs(Ycheck*vNew+fv+Y_NS*v0));
 str=['Iteration No. ', num2str(it),' Error is ', num2str(err(it+1)), '\n'];
 fprintf(str);
 end
 
 itSuccess=maxIt;
 
 vSol=vNew;
 
alphaNumeric=zeros(itSuccess-1,1); 

 for it=2:itSuccess
%      alphaNumeric(it-1)=(1./(it-1))*...
%          log10((Lambda_min./Lambda_max)*...
%          max(abs( vIterations(:,it)-vSol))./(max(abs(vIterations(:,1)-vSol))));

% alphaNumeric(it-1) = (1./(it-1))*...
%           log10(...
%           max(abs( vIterations(:,it)-vSol))./(max(abs(vIterations(:,1)-vSol))));

% alphaNumeric(it-1)= log10((Lambda_min./Lambda_max)*...
%        max(abs( vIterations(:,it+1)-vIterations(:,it)))./(max(abs(vIterations(:,it)-vIterations(:,it-1)))));

alphaNumeric(it-1)= ...
       max(abs( inv(Lambda)*( vIterations(:,it+1)-vIterations(:,it))))./(max(abs( inv(Lambda)*(vIterations(:,it)-vIterations(:,it-1)))));
 end
 
alphaMax=max(alphaNumeric); 





end

