clear all;
clc;

cd('IEEE-37 feeder data');

lineData=importdata('line data.xls');
transformerData=importdata('Transformer Data.xls');
regulartorData=importdata('Regulator Data.xls');
spotloadData=importdata('spot loads.xls');
cd('..');




Sbase=2500*1000;
Vbase=4800/sqrt(3);
Zbase=(Vbase^2)./Sbase;
Ybase=1/Zbase;

%% Impedances in Ohm per mile for all the line configurations
Zcfg(:,:,1)=[0.2926+0.1973i, 0.0673-0.0368i, 0.0337-0.0417i; 
                0.0673-0.0368i, 0.2646+0.1900i, 0.0673-0.0368i;
                0.0337-0.0417i,  0.0673-0.0368i, 0.2926+0.1973i]/Zbase/5280;
Ycfg(:,:,1)=1j*(10^(-6))*[159.8   0   0;
    0        159.8   0;
   0        0     159.8]/Ybase/5280;  % for configuration 721



Zcfg(:,:,2)= [0.4751+0.2973i, 0.1629-0.0326i, 0.1234-0.0607i; 
                    0.1629-0.0326i, 0.4488+0.2678i, 0.1629-0.0326i;
                  0.1234-0.0607i, 0.1629-0.0326i, 0.4751+0.2973i ]/Zbase/5280;

Ycfg(:,:,2)=1j*(10^(-6))* [127.8306  0   0;
    0       127.8306   0;
   0 0  127.8306]/Ybase/5280;  % for configuration 722

Zcfg(:,:,3)=[1.2936+0.6713i, 0.4871+0.2111i, 0.4585+0.1521i; 
    0.4871+0.2111i, 1.3022+0.6326i, 0.4871+0.2111i;
    0.4585+0.1521i, 0.4871+0.2111i, 1.2936+0.6713i]/Zbase/5280;
Ycfg(:,:,3)=1j*(10^(-6))*[74.8405   0   0;
    0   74.8405   0;
    0   0    74.8405]/Ybase/5280;


Zcfg(:,:,4)=[2.0952+0.7758i, 0.5204+0.2738i, 0.4926+0.2123i;
    0.5204+0.2738i, 2.1068+0.7398i, 0.5204+0.2738i;
    0.4926+0.2123i,  0.5204+0.2738i ,   2.0952+0.7758i]/Zbase/5280;
Ycfg(:,:,4)=1j*(10^(-6))*[60.2483  0    0;
    0    60.2483   0;
   0  0        60.2483]/Ybase/5280;




%% Transformer setup:
% Delta-to-Delta
transformerNode=775;

%% Setting up the list of nodes, giving them a unique order from 1:N, setting the substation to node N+1
sendingNodes=lineData.data.Sheet1(:,1);
receivingNodes=lineData.data.Sheet1(:,2);
lineLengths=lineData.data.Sheet1(:,3);
lineConfigs=lineData.data.Sheet1(:,4)-720;
lineType=zeros(length(sendingNodes),1);  % type 0 is regular line


lineConfigs(35)=1; % transformer config is irrelevant
lineType(35)=2; % transformer is type 2




allNodesActualLabels=unique([sendingNodes;receivingNodes]);
allNodesActualLabels=[allNodesActualLabels(allNodesActualLabels~=799);799];  % placing the substation at the very end
N=length(allNodesActualLabels)-1;
nodeSet=1:N+1;   % now we just have to replace the previous labels with these new ones

sNodes=sendingNodes;
rNodes=receivingNodes;

for i=1:length(sNodes)
    sNodes(i)=find(allNodesActualLabels==sNodes(i));
    rNodes(i)=find(allNodesActualLabels==rNodes(i));
   
end


   % fixing the regulator lines
lineType(and(sNodes==find(allNodesActualLabels==799), rNodes==find(allNodesActualLabels==701)))=31;  % type 31 for regulator ID 1


% Now we have the network data:
% networkData=[sNodes, rNodes, lineLengthts, lineConfigs, lineType];
networkData=[sNodes, rNodes, lineLengths, lineConfigs, lineType];

%% Setting up the Y
phaseNodes=repmat([1,2,3],N+1,1);  % creates a hypothetical three phase for all nodes (N+1)*3 matrix (a is 1, b is 2, c is 3)
phaseNodesLin=reshape(phaseNodes.',3*(N+1),1);   % stacks them all up
Ytilde=zeros(N+1);


for i=1:length(sNodes)
    nIdx=sNodes(i);
    mIdx=rNodes(i);
    
    switch lineType(i)
        
       
     
         
 case 31
         % open-delta connected regulator
         
            tapAB=7;
            tapBC=4;
            
            arAB= 1 - 0.00625*tapAB;
            arBC=1-0.00625*tapBC;
            
             Av=[arAB, 1-arAB,0; 
                    0, 1, 0 ; 
                    0, 1-arBC,arBC];
             Ai=[1/arBC, 0,0; 
                 1-1/arBC,1,1-1/arBC;
                 0, 0, 1/arBC];
             
         
             Av1001=Av;

            
            lineLength=lineLengths(i);
            configNumber=lineConfigs(i);
            Zconfig=Zcfg(:,:,configNumber);
            YsConfig=Ycfg(:,:,configNumber);

            availablePhases=find(any(Zconfig));
            
            YtildeNMn=zeros(3,3);
            YtildeNMn(availablePhases, availablePhases)=Ai*(0.5*YsConfig(availablePhases,availablePhases)...
                .*lineLength+inv(Zconfig(availablePhases,availablePhases).*lineLength))*inv(Av);
            
            YtildeNMm=zeros(3,3);
            YtildeNMm(availablePhases, availablePhases)=Ai *inv(Zconfig(availablePhases,availablePhases).*lineLength);
            
            YtildeMNm=zeros(3,3);
            YtildeMNm(availablePhases,availablePhases)=0.5*YsConfig(availablePhases,availablePhases)...
                .*lineLength+inv(Zconfig(availablePhases,availablePhases).*lineLength);
            
            YtildeMNn=zeros(3,3);
            YtildeMNn(availablePhases,availablePhases)=inv(Zconfig(availablePhases,availablePhases).*lineLength)*inv(Av);
            
          Ytilde(nIdx, nIdx)= Ytilde(nIdx,nIdx)+convertToSinglePhase(YtildeNMn);
            Ytilde(nIdx,mIdx)=-convertToSinglePhase(YtildeNMm);
            Ytilde(mIdx,mIdx)=Ytilde(mIdx,mIdx)+convertToSinglePhase(YtildeMNm);
            Ytilde(mIdx,nIdx)=-convertToSinglePhase(YtildeMNn);
%             
          
          

            
        case 2
            

            zt=(0.09+1.81i)* (Sbase/(500000));
            yt=1./zt;
            Y2= (1/3) *[ 2*yt, -yt, -yt; -yt,2*yt,-yt; -yt,-yt,2*yt];
            Y2(1,1)=Y2(1,1)+0.00001;
   

            
            
        
            
                 Ytilde(nIdx, nIdx)= Ytilde(nIdx,nIdx)+convertToSinglePhase(Y2);
            Ytilde(nIdx,mIdx)=-convertToSinglePhase(Y2);
            Ytilde(mIdx,mIdx)=Ytilde(mIdx,mIdx)+convertToSinglePhase(Y2);
            Ytilde(mIdx,nIdx)=-convertToSinglePhase(Y2);
      
   
          
        otherwise
            lineLength=lineLengths(i);  
            configNumber=lineConfigs(i);
            Zconfig=Zcfg(:,:,configNumber);
            YsConfig=Ycfg(:,:,configNumber);
            YsConfig=zeros(3,3);
            availablePhases=find(any(Zconfig));
            
            % constructing the four matrices of lines:
            YtildeNMn=zeros(3,3);
            YtildeNMn(availablePhases, availablePhases)=0.5*YsConfig(availablePhases,availablePhases)...
                .*lineLength+inv(Zconfig(availablePhases,availablePhases).*lineLength);
            
            YtildeNMm=zeros(3,3);
            YtildeNMm(availablePhases,availablePhases)=inv(Zconfig(availablePhases,availablePhases).*lineLength);
            
            YtildeMNm=YtildeNMn;
            YtildeMNn=YtildeNMm;
            
            % placing the four matrices:
     Ytilde(nIdx, nIdx)= Ytilde(nIdx,nIdx)+convertToSinglePhase(YtildeNMn);
            Ytilde(nIdx,mIdx)=-convertToSinglePhase(YtildeNMm);
            Ytilde(mIdx,mIdx)=Ytilde(mIdx,mIdx)+convertToSinglePhase(YtildeMNm);
            Ytilde(mIdx,nIdx)=-convertToSinglePhase(YtildeMNn);
            
            
            
            
            
    end
end

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


yImpedance=getYLoadImpedanceSinglePhase( yL_load);
Ycheck=Y+yImpedance;  % (Y+YL) in the text
Z=inv(Ycheck); 
w= -Z*Y_NS*v0; 

if exist('SinglePhaseMatFiles')~=7
    mkdir 'SinglePhaseMatFiles'
end
cd('SinglePhaseMatFiles'); 
save('IEEE37SinglePhase');
cd('..');
