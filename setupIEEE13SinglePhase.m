cd('Constructed-Mat-Files/'); 
load('IEEE13SinglePhaseNetwork'); 
cd('..');


% Y matrices of the network

Y=Ytilde(1:end-1,1:end-1);
Y_NS=Ytilde(1:end-1,end);






%% Spot load data

v0=1;
sL=zeros(N,1);
yL=zeros(N,1);
iL=zeros(N,1);



loadData=spotloadData.data.Sheet1(1:end-1,:);
loadType=spotloadData.textdata.Sheet1(5:end-1,2);

loadIndices=loadData(:,1);

% Each node can be a delta or wye connection. Each delta or wye connections
% can be constant-PQ, constant-I, or constant-Z load types, or a
% combination of all three. The loads at index "k" modeled as follows:
% i_k(v) = gMat(k,:)*[i_{PQ} (v) ; i_{I} (v) ; i_{Z} (v)] where v is the
% vector of all phase to ground voltages at all nodes and
% i_PQ=cMat(k,:)*[ conj(sNominal1./(ePage(k,:,1)*v));
% conj(sNominal2./(ePage(k,:,2)*v))]; 
% i_I=cMat(k,:)*[ iNominal1* ePage(k,:,1)*v./abs(ePage(k,:,1)*v);
%  iNominal2* ePage(k,:,2)*v./abs(ePage(k,:,2)*v)];
% i_Z=cMat(k,:)*[ yNominal1* ePage(k,:,1)*v;
%  yNominal2* ePage(k,:,2)*v];
% where for wye loads: sNominal1=sNominal_k, iNominal1=iNominal_k,
% yNominal1=yNominal_k
% and for delta loads: let k=Lin(n,\phi)
% sNominal1=sNominal_n^{\phi, r(\phi)}, sNominal2=sNominal_n^{\phi',
% r(\phi')=\phi)






gMat=zeros(N,3);  % defines the load type  gVec(1) PQ, gVec(2) I , gVec(3) Y

for i=1:length(loadIndices)
 
    nIdx=find(allNodesActualLabels==loadData(i,1));
    
    
    

    
  
    if (nIdx==671)
        nomin1=17*66+66*117+17*117;
        p1=nomin1./(117); 
        p2=nomin1./(17);
        p3=nomin1./(66); 
        
        
        nomin2= 10*38+38*68+10*68;
        q1=nomin2./(68);
        q2=nomin2./(10);
        q3=nomin2./(38);
        
         pLoad=(loadData(i, [3 5 7])+0.5*[p1 p2 p3])*1000/Sbase; 
    qLoad=(loadData(i,[4 6 8])+0.5*[q1 q2 q3])*1000/Sbase; 
    sLoad=sum((pLoad+1j*qLoad).')/3;
    
    % taking care of distributed load:
    pLoad1=0.5*[17 66 117]*1000/Sbase;
    qLoad1=0.5*[10 38 68]*1000/Sbase;
    sLoad1=sum((pLoad1+1j*qLoad1).')/3;
     AuxIdx=find(   allNodesActualLabels==632);
     
    
      sL(AuxIdx,1)=sLoad1;
      gMat(AuxIdx,1)=1;
             
             
       
    
    
    else
         pLoad=loadData(i, [3 5 7])*1000/Sbase; 
    qLoad=loadData(i,[4 6 8])*1000/Sbase; 
    sLoad=sum((pLoad+1j*qLoad).')/3;
        
    end
    
     switch loadType{i}
         
         
         case 'Y-PQ'
             sL(nIdx,1)=sLoad;
             
             
             
            gMat(nIdx,1)=1;
     
             
             
    
             
             
         case 'Y-PR'
               sL(nIdx,1)=sLoad;
             
             
             
              gMat(nIdx,1)=1;
  
             
             
           
             
         case  'Y-I'
             
              iL(nIdx,1)=conj(sLoad./v0);
             
             
              gMat(nIdx,2)=1;
            
         case 'Y-Z' 
             
               yL(nIdx,1)=conj(sLoad);
               
             
              gMat(nIdx,3)=1;
           
             
             
         case 'D-PQ'
             
               sL(nIdx,1)=sLoad;
         
             
              gMat(nIdx,1)=1;

           
           
             
         case 'D-I'
   
              iL(nIdx,1)=conj(sLoad./v0);
             

             
             
              gMat(nIdx,2)=1;
        
             
          
           
           
      
           
         
             
        case 'D-Z'
            
             yL(nIdx,1)=conj(sLoad);
           
            
             gMat(nIdx,3)=1;
       
   
          
end
end




sL_load=sL;
iL_load=iL;
yL_load=yL;


yImpedance=getYLoadImpedanceSinglePhase( yL_load);
Ycheck=Y+yImpedance;  % (Y+YL) in the text
Z=inv(Ycheck); 
w= -Z*Y_NS*v0; 

if exist('Case Studies')~=7
    mkdir 'Case Studies'
end
cd('Case Studies'); 
save('IEEE13SinglePhaseData');
cd('..');
