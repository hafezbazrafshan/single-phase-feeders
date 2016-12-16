%% 1. Importing the mat file for IEEE123 network
cd('Constructed-Mat-Files/'); 
load('IEEE123SinglePhaseNetwork'); 
cd('..');



Y=Ytilde(1:end-1,1:end-1);
Y_NS=Ytilde(1:end-1,end);



v0=1;
sL=zeros(N,1);
yL=zeros(N,1);
iL=zeros(N,1);






loadData=spotloadData.data.Sheet1(1:end-1,:);
loadType=spotloadData.textdata.Sheet1(5:end-1,2);

loadIndices=loadData(:,1);

gMat=zeros(N,3);  % defines the load type  gVec(1) PQ, gVec(2) I , gVec(3) Y


for i=1:length(loadIndices)
 
    nIdx=find(allNodesActualLabels==loadData(i,1));
    

    
     pLoad=loadData(i, [3 5 7])*1000/Sbase; 
    qLoad=loadData(i,[4 6 8])*1000/Sbase; 
     sLoad=sum((pLoad+1j*qLoad).')/3;
        
    

    
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




%% 5. Creating Y_L, Y+Y_L, Z, and w
yImpedance=getYLoadImpedanceSinglePhase( yL_load);
Ycheck=Y+yImpedance;  % (Y+YL) in the text
Z=inv(Ycheck); 
w= -Z*Y_NS*v0; 


if exist('Case Studies')~=7
    mkdir 'Case Studies'
end
cd('Case Studies'); 
save('IEEE123SinglePhaseData');
cd('..');
