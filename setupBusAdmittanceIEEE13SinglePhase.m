% This script creates a MatFile named ``IEEE13SinglePhase.mat" in the
% folder Constructed-Mat-Files.   The MatFile contains the following
% fields:
% 1) Sbase
% 2) Vbase
% 3) N (Number of buses without the Slack bus)
% 4) allNodesActualLabels (Bus labels as given by the IEEE feeders)
% 5) Av1001 (The voltage gain of the step-voltage regulator)
% 6) Ytilde (the bus admittance matrix)
% 7) sL_load  (Vector of `nominal power' of constant-power loads)
% 8) iL_load (Vector of `nominal current' of constant-current loads)
% 9) yL_load (Vector of `nominal admittance' of constant-impedance loads)
% 10) gMat (An N*3 binary matrix determining load-type per node.  
% For example, gMat(i,:)=[1 0 0] determines constant-power load only, 
% gMat(i,:)=[1,0,1] determines constant-power and constant-impedance loads)
% 11) Y (the bus admittance matrix removing the slack bus)
% 12) Y_NS (the portion of Ytilde corresponding to the interface of network
% and slack bus)
% The MatFile created here is input to the solveIEEE13SinglePhase
% 13) yImpedance (the matrix YL corresponding to constant-impedance loads)
% 14) Ycheck ( Y+YImpedance)
% 15) w (the no-load voltage profile)
% 16) Z (inverse of Ycheck)



% Some comments: 
% a) The conversion from  multi-phase lines to single-phase is as follows:
         % i) Three-by-three Nodal admittances YNMn, YMNn, YNMm, YMNm 
         % are created first by assuming zero's in their rows and columns corresponding to 
         % columns.  
         % ii) The average of non-zero diagonal entires and the non-zero
         % off diagonal entries is computed, denoted respectively by yd and
         % yo. 
         % iii) A symmetrical 3*3 matrix is then constructed
         % YSymmetric=[yd, yo, yo; yo, yd, yo; yo, yo, yd];
         % iv)  A symmetrical component transformation is then applied
         % yielding  a diagonal matrix Ydiagonal=diag([y0; y1; y2]).
          % v) The representative admittance of the corresponding line is
          % then chosen as y1. 
 % b) The conversion in (a) is purely heuristical. 
 % c) The conversion from multi-phase loads to single-phase: the sum of
 % loads per bus is divided by (3).  Of course, this is also heuristical
 % since single-phase representation is for balanced networks only.
         







clear all;
clc;

cd('IEEE-13 feeder data');

lineData=importdata('Line Data.xls');
transformerData=importdata('Transformer Data.xls');
regulartorData=importdata('Regulator Data.xls');
spotloadData=importdata('Spot Load Data.xls');
distributedloadData=importdata('Distributed Load Data.xls'); 
capData=importdata('cap data.xls');

cd('..');

Sbase=5000*1000; % from the substation transformer
Vbase=4160/sqrt(3); % line to neutral conversion (secondary of the substation transformer)
Zbase=Vbase^2/Sbase;
Ybase=1/Zbase;




Zcfg(:,:,1) = [	0.3465+1.0179i	0.1560+0.5017i	0.1580+0.4236i	; ...
    0.1560+0.5017i	0.3375+1.0478i	0.1535+0.3849i	; ...
    0.1580+0.4236i	0.1535+0.3849i	0.3414+1.0348i	; ...
    ]/Zbase/5280;
Ycfg(:,:,1)=1j*(10^(-6)) * [  6.2998   -1.9958   -1.2595
    -1.9958   5.9597   -0.7417
    -1.2595 -0.7417    5.6386] / Ybase/5280;


Zcfg(:,:,2) = [	0.7526+1.1814i	0.1580+0.4236i	0.1560+0.5017i	; ...
    0.1580+0.4236i	0.7475+1.1983i	0.1535+0.3849i	; ...
    0.1560+0.5017i	0.1535+0.3849i	0.7436+1.2112i	; ...
    ] /Zbase/5280;

Ycfg(:,:,2)=1j*(10^(-6))  * [ 5.6990   -1.0817   -1.6905
    -1.0817    5.1795   -0.6588
    -1.6905 -0.6588      5.4246]/Ybase/5280;





% Configuration 603 only includes phases b, c
Zcfg(:,:,3)= [0 0 0;
    0	1.3294+1.3471i	0.2066+0.4591i	; ...
    0  0.2066+0.4591i	1.3238+1.3569i]/Zbase/5280 ;
Ycfg(:,:,3)=1j*(10^(-6)) *[0 0 0; 0 4.7097 -0.8999; 0 -0.8999 4.6658]/Ybase/5280;




%Configuration 604 only includes phase a, c
Zcfg(:,:,4)=[1.3238+1.3569i 0 0.2066+0.4591i;
    0  0 0;
    0.2066+0.4591i  0 1.3294+1.3471i]/Zbase/5280;


Ycfg(:,:,4)=1j*(10^(-6)) *[4.6658 0 -0.8999;
    0 0 0;
    -0.8999 0  4.7097]/Ybase/5280;




% Configuration 605 only includes phase c
Zcfg(:,:,5)=[0 0 0; 
    0 0 0; 
    0 0 1.3292+1.3475i]/Zbase/5280;
Ycfg605(:,:,5)=1j*(10^(-6)) *[0 0 0; 0 0 0; 0 0 4.5193]/Ybase/5280;




Zcfg(:,:,6)=[0.7982+0.4463i,0.3192+0.0328i,0.2849-0.0143i;
    0.3192+0.0328i,0.7891+0.4041i,0.3192+0.0328i;
    0.2849-0.0143i,0.3192+0.0328i,0.7982+0.4463i]/Zbase/5280;
Ycfg(:,:,6)=1j*(10^(-6)) *[96.8897    0   0
    0 96.8897    0
    0 0      96.8897]/Ybase/5280;




%Configuration 607 only includes phase a
Zcfg(:,:,7)=[1.3425+0.5124i 0 0; 0 0 0; 0 0 0]/Zbase/5280;
Ycfg(:,:,7)=1j*(10^(-6)) *[88.9912 0 0; 0 0 0; 0 0 0]/Ybase/5280;



%% Setting up the list of nodes, giving them a unique order from 1:N, setting the substation to node N+1
sendingNodes=lineData.data.Sheet1(:,1);
receivingNodes=lineData.data.Sheet1(:,2);
lineLengths=lineData.data.Sheet1(:,3);
lineConfigs=lineData.data.Sheet1(:,4)-600;
lineType=zeros(length(sendingNodes),1);  % type 0 is regular line





lineType(3)=2; % transformer is type 2
lineConfigs(3)=1; % transformer type is irrelevant





lineConfigs(10)=1; % switch assumed of configuration one 
lineLengths(10)=1;



allNodesActualLabels=unique([sendingNodes;receivingNodes]);
allNodesActualLabels=[allNodesActualLabels(allNodesActualLabels~=650);650];  % placing the substation at the very end
N=length(allNodesActualLabels)-1;
nodeSet=1:N+1;   % now we just have to replace the previous labels with these new ones

sNodes=sendingNodes;
rNodes=receivingNodes;

for i=1:length(sNodes)
    sNodes(i)=find(allNodesActualLabels==sNodes(i));
    rNodes(i)=find(allNodesActualLabels==rNodes(i));
   
end


   % fixing the regulator lines
lineType(and(sNodes==find(allNodesActualLabels==650), rNodes==find(allNodesActualLabels==632)))=31;  % type 31 for regulator ID 1


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
         

            tapA=10;
            tapB=8;
            tapC=11;
            AR=eye(3);
            AR(1,1)=1-0.00625*tapA;
            AR(2,2)=1-0.00625*tapB;
            AR(3,3)=1-0.00625*tapC;
            Av1001=AR;
            lineLength=lineLengths(i);
            configNumber=lineConfigs(i);
            Zconfig=Zcfg(:,:,configNumber);
            YsConfig=Ycfg(:,:,configNumber);
%              YsConfig=zeros(3,3);
            availablePhases=find(any(Zconfig));
            
            YtildeNMn=zeros(3,3);
                YtildeNMn(availablePhases, availablePhases)=inv(AR)*(0.5*YsConfig(availablePhases,availablePhases)...
                    .*lineLength+inv(Zconfig(availablePhases,availablePhases).*lineLength))*inv(AR);
            
            YtildeNMm=zeros(3,3);
            YtildeNMm(availablePhases, availablePhases)=inv(AR) *inv(Zconfig(availablePhases,availablePhases).*lineLength);
            
            YtildeMNm=zeros(3,3);
            YtildeMNm(availablePhases,availablePhases)=0.5*YsConfig(availablePhases,availablePhases)...
                .*lineLength+inv(Zconfig(availablePhases,availablePhases).*lineLength);
            
            YtildeMNn=zeros(3,3);
            YtildeMNn(availablePhases,availablePhases)=inv(Zconfig(availablePhases,availablePhases).*lineLength)*inv(AR);
                Ytilde(nIdx, nIdx)= Ytilde(nIdx,nIdx)+convertToSinglePhase(YtildeNMn);
            Ytilde(nIdx,mIdx)=-convertToSinglePhase(YtildeNMm);
            Ytilde(mIdx,mIdx)=Ytilde(mIdx,mIdx)+convertToSinglePhase(YtildeMNm);
            Ytilde(mIdx,nIdx)=-convertToSinglePhase(YtildeMNn);
%             
%             
            

            
        case 2
            
            Zt=0.01*(1.1+2i)*eye(3)*(Sbase./(500000));
            YtildeNMn=inv(Zt);
            YtildeNMm=YtildeNMn;
            YtildeMNm=inv(Zt);
            YtildeMNn=YtildeMNm;
            
        Ytilde(nIdx, nIdx)= Ytilde(nIdx,nIdx)+convertToSinglePhase(YtildeNMn);
            Ytilde(nIdx,mIdx)=-convertToSinglePhase(YtildeNMm);
            Ytilde(mIdx,mIdx)=Ytilde(mIdx,mIdx)+convertToSinglePhase(YtildeMNm);
            Ytilde(mIdx,nIdx)=-convertToSinglePhase(YtildeMNn);
            
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


%% Adding shunt capacitors:
capOriginalNodes=capData.data.Sheet1(~isnan(capData.data.Sheet1(:,1)));

for i=1:size(capOriginalNodes,1)
    nIdx=find(allNodesActualLabels==capOriginalNodes(i));
    availablePhases=find(~isnan(capData.data.Sheet1(i,[2,3,4])));
    Ycap=zeros(3,3);
    Ycap(availablePhases,availablePhases)=diag(capData.data.Sheet1(i,1+availablePhases)*1j)*1000/Sbase;
    Ytilde(nIdx, nIdx)=Ytilde(nIdx,nIdx)+convertToSinglePhase(Ycap);
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

if exist('SinglePhaseMatFiles')~=7
    mkdir 'SinglePhaseMatFiles'
end
cd('SinglePhaseMatFiles'); 
save('IEEE13SinglePhase');
cd('..');


