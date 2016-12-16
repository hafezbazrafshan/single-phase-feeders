function Zout=convertToSinglePhase(Zin)

as=exp(j*2*pi/3); 

As=[1 1 1; 1 as.^2 as; 1 as as.^2]; 

DiagZin=diag(Zin); 
OffDiagZin=Zin-diag(diag(Zin)); 

MeanDiagZin=mean(DiagZin(DiagZin~=0)); 
MeanOffDiagZin=mean(OffDiagZin(OffDiagZin~=0));
if isnan(MeanOffDiagZin)
    MeanOffDiagZin=0;
end

ZNEW=[MeanDiagZin, MeanOffDiagZin, MeanOffDiagZin; 
               MeanOffDiagZin, MeanDiagZin, MeanOffDiagZin;
               MeanOffDiagZin, MeanOffDiagZin, MeanDiagZin]; 
           
Zs=inv(As)*ZNEW*As; 

ZsDiag=diag(Zs); 

Zout=ZsDiag(2); 


           
           
           

