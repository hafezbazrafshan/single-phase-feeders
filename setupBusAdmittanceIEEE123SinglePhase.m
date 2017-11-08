clear all;
clc;

%% Step 1: Loading the feeder documents
cd('IEEE-123 feeder data');
lineData=importdata('line data.xls');
transformerData=importdata('Transformer Data.xls');
regulartorData=importdata('Regulator Data.xls');
spotloadData=importdata('spot loads data.xls');
capData=importdata('cap data.xls');
cd('..');



%% Step 2: Setting up the base values from the feeder documents
Sbase=5000*1000;
Vbase=4160/sqrt(3);
Zbase=(Vbase^2)./Sbase;
Ybase=1/Zbase;

%% Step 3: Setting up the  Impedances in Ohm per mile for all the line configurations
% (12 configurations)
Zcfg(:,:,1)= [0.4576+1.0780i   0.1560+0.5017i   0.1535+0.3849i;
    0.1560+0.5017i     0.4666+1.0482i   0.1580+0.4236i;
    0.1535+0.3849i       0.1580+0.4236i    0.4615+1.0651i]/Zbase/5280;
Ycfg(:,:,1)=1j*(10^(-6))*[5.6765   -1.8319   -0.6982;
    -1.8319        5.9809   -1.1645;
    -0.6982         -1.1645      5.3971]/Ybase/5280;


Zcfg(:,:,2)= [0.4666+1.0482i   0.1580+0.4236i   0.1560+0.5017i;
    0.1580+0.4236i 0.4615+1.0651i   0.1535+0.3849i;
    0.1560+0.5017i      0.1535+0.3849i        0.4576+1.0780i]/Zbase/5280;

Ycfg(:,:,2)=1j*(10^(-6))* [5.9809   -1.1645   -1.8319;
    -1.1645       5.3971   -0.6982;
    -1.8319 -0.6982 5.6765]/Ybase/5280;

Zcfg(:,:,3)=[0.4615+1.0651i   0.1535+0.3849i   0.1580+0.4236i;
    0.1535+0.3849i  0.4576+1.0780i   0.1560+0.5017i;
    0.1580+0.4236i    0.1560+0.5017i  0.4666+1.0482i]/Zbase/5280;
Ycfg(:,:,3)=1j*(10^(-6))*[5.3971   -0.6982   -1.1645;
    -0.6982   5.6765   -1.8319;
    -1.1645   -1.8319    5.9809]/Ybase/5280;


Zcfg(:,:,4)=[0.4615+1.0651i   0.1580+0.4236i   0.1535+0.3849i;
    0.1580+0.4236i 0.4666+1.0482i   0.1560+0.5017i;
    0.1535+0.3849i        0.1560+0.5017i      0.4576+1.0780i]/Zbase/5280;
Ycfg(:,:,4)=1j*(10^(-6))*[5.3971   -1.1645   -0.6982;
    -1.1645    5.9809   -1.8319;
    -0.6982  -1.8319         5.6765]/Ybase/5280;


Zcfg(:,:,5)=[0.4666+1.0482i   0.1560+0.5017i   0.1580+0.4236i;
    0.1560+0.5017i  0.4576+1.0780i   0.1535+0.3849i;
    0.1580+0.4236i         0.1535+0.3849i         0.4615+1.0651i]/Zbase/5280;
Ycfg(:,:,5)=1j*(10^(-6))*[5.9809   -1.8319   -1.1645
    -1.8319      5.6765   -0.6982
    -1.1645      -0.6982          5.3971]/Ybase/5280;


Zcfg(:,:,6)=[ 0.4576+1.0780i   0.1535+0.3849i   0.1560+0.5017i
    0.1535+0.3849i 0.4615+1.0651i   0.1580+0.4236i
    0.1560+0.5017i       0.1580+0.4236i       0.4666+1.0482i]/Zbase/5280;
Ycfg(:,:,6)=1j*(10^(-6))*[5.6765   -0.6982   -1.8319
    -0.6982    5.3971   -1.1645
    -1.8319     -1.1645       5.9809]/Ybase/5280;



Zcfg(:,:,7)=[0.4576+1.0780i      0                   0.1535+0.3849i;
    0                             0                   0;
    0.1535+0.3849i       0         0.4615+1.0651i]/Zbase/5280;

Ycfg(:,:,7)=1j*(10^(-6))*[5.1154    0   -1.0549;
    0    0 0;
    -1.0549 0         5.1704]/Ybase/5280;

Zcfg(:,:,8)=[ 0.4576+1.0780i   0.1535+0.3849i   0.0000;
    0.1535+0.3849i 0.4615+1.0651i     0.0000 ;
    0.0000             0.0000  0.0000]/Zbase/5280;
Ycfg(:,:,8)=1j*(10^(-6))*[5.1154   -1.0549    0.0000
    -1.0549   5.1704    0.0000
    0.0000          0.0000  0.0000]/Ybase/5280;

Zcfg(:,:,9)=[1.3292+1.3475i   0   0;
    0 0 0;
    0 0 0] /Zbase/5280;
Ycfg(:,:,9)=1j*(10^(-6))*[4.5193    0.0000    0.0000
    0  0.0000    0.0000
    0      0      0.0000]/Ybase/5280;


Zcfg(:,:,10)=[0 0 0;
    0 1.3292+1.3475i    0;
    0  0 0]/Zbase/5280;
Ycfg(:,:,10)=1j*(10^(-6))*[0 0 0;
    0 4.5193 0;
    0 0 0]/Ybase/5280;



Zcfg(:,:,11)=[ 0   0   0;
    0  0   0;
    0 0   1.3292+1.3475i]/Zbase/5280;
Ycfg(:,:,11)=1j*(10^(-6))*[ 0  0   0;
    0   0   0;
    0    0  4.5193]/Ybase/5280;

Zcfg(:,:,12)=[ 1.5209+0.7521i   0.5198+0.2775i   0.4924+0.2157i;
    0.5198+0.2775i 1.5329+0.7162i   0.5198+0.2775i;
    0.4924+0.2157i        0.5198+0.2775i         1.5209+0.7521i]/Zbase/5280;
Ycfg(:,:,12)=1j*(10^(-6))*[67.2242  0    0;
    0 67.2242    0;
    0       0    67.2242]/Ybase/5280;




%% Step 4: Setting up the list of nodes, giving them a unique order from 1:N, setting the substation to node N+1
transformerNode=610; % secondary of transformer node label (its primary does not have a label and hence given the label 1005)
sendingNodes=lineData.data.Sheet1(:,1);
receivingNodes=lineData.data.Sheet1(:,2);
lineLengths=lineData.data.Sheet1(:,3);
lineConfigs=lineData.data.Sheet1(:,4);
lineType=zeros(length(sendingNodes),1);  % A regular transmission line is given type 0

% adding the switches to the sendingNodes, receivingNodes, lineLengths as well as  lineConfigs
sendingSwitchNodes=[13;18;60;61;97;150];
receivingSwitchNodes=[152;135;160;610;197;149];
sendingNodes=[sendingNodes; sendingSwitchNodes];
receivingNodes=[receivingNodes; receivingSwitchNodes];
lineLengths=[lineLengths;10*ones(length(sendingSwitchNodes),1)];  % all switches will be assumed to be a line with 10 ft lengths
lineConfigs=[lineConfigs; ones(length(sendingSwitchNodes),1)];  % of configuration one
lineType=[lineType; ones(length(sendingSwitchNodes),1)];  % type 1 is switch

% adding the transformer
sendingTransformerNodes=[610];
receivingTransformerNodes=[1005];  % dummy node for XFM-1 (primary)
sendingNodes=[sendingNodes; sendingTransformerNodes];
receivingNodes=[receivingNodes; receivingTransformerNodes];
lineLengths=[lineLengths; 0*ones(length(sendingTransformerNodes),1)];  % all transformers lengths will be irrelevant
lineConfigs=[lineConfigs; ones(length(sendingTransformerNodes),1)]; % all transformer configs will be irrelevant
lineType=[lineType; 1+ones(length(sendingTransformerNodes),1)];  % type 2 is transformer


allNodesActualLabels=unique([sendingNodes;receivingNodes]);
allNodesActualLabels=[allNodesActualLabels(allNodesActualLabels~=150);150];  % placing the substation at the very end
N=length(allNodesActualLabels)-1;
nodeSet=1:N+1;   % now we just have to replace the previous labels with these new ones

sNodes=sendingNodes;
rNodes=receivingNodes;

for i=1:length(sNodes)
    sNodes(i)=find(allNodesActualLabels==sNodes(i));
    rNodes(i)=find(allNodesActualLabels==rNodes(i));
   
end

% (the n' of the regulators are given the label 1000+ID#) 
% (see the modeling paper)
   % fixing the regulator lines
lineType(and(sNodes==find(allNodesActualLabels==150), rNodes==find(allNodesActualLabels==149)))=31;  % type 31 for regulator ID 1
lineType(and(sNodes==find(allNodesActualLabels==9), rNodes==find(allNodesActualLabels==14)))=32;  % type 32 for regulator ID 2
lineType(and(sNodes==find(allNodesActualLabels==25), rNodes==find(allNodesActualLabels==26)))=33;  % type 33 for regulator ID 3
lineType(and(sNodes==find(allNodesActualLabels==160), rNodes==find(allNodesActualLabels==67)))=34;  % type 34 for regulator ID 4

% Now we have the network data:
% networkData=[sNodes, rNodes, lineLengthts, lineConfigs, lineType];
networkData=[sNodes, rNodes, lineLengths, lineConfigs, lineType];

%% Step 5: Setting up the network admittance matrix
phaseNodes=repmat([1,2,3],N+1,1);  % creates a hypothetical three phase for all nodes (N+1)*3 matrix (a is 1, b is 2, c is 3)
phaseNodesLin=reshape(phaseNodes.',3*(N+1),1);   % stacks them all up

Ytilde=zeros(N+1);

for i=1:length(sNodes)
    nIdx=sNodes(i);
    mIdx=rNodes(i);
    
    switch lineType(i)
        
        case 31
         %   gang operated
            tapPos=7;
            tapA=tapPos;
            tapB=tapPos;
            tapC=tapPos;
            AR=eye(3)-0.00625*tapPos*eye(3);
            Av1001=AR;
            lineLength=lineLengths(i);
            configNumber=lineConfigs(i);
            Zconfig=Zcfg(:,:,configNumber);
            YsConfig=Ycfg(:,:,configNumber);

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
        case 32
            tapA=-1;
            AR=eye(1);
            AR(1,1)=1-0.00625*tapA;
            Av1002=AR;
            lineLength=lineLengths(i);
            configNumber=lineConfigs(i);
            Zconfig=Zcfg(:,:,configNumber);
            YsConfig=Ycfg(:,:,configNumber);

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
          
        case 33
             
            tapA=0;
            tapC=-1;
            AR=eye(2);
            AR(1,1)=1-0.00625*tapA;
            AR(2,2)=1-0.00625*tapC;
            Av1003=AR;
                lineLength=lineLengths(i);
            configNumber=lineConfigs(i);
            Zconfig=Zcfg(:,:,configNumber);
            YsConfig=Ycfg(:,:,configNumber);
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
       
        
        case 34
%             
%             
            tapA=8;
            tapB=1;
            tapC=5;
            AR=eye(3);
            AR(1,1)=1-0.00625*tapA;
            AR(2,2)=1-0.00625*tapB;
            AR(3,3)=1-0.00625*tapC;
            Av1004=AR;
               lineLength=lineLengths(i);
            configNumber=lineConfigs(i);
            Zconfig=Zcfg(:,:,configNumber);
            YsConfig=Ycfg(:,:,configNumber);
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
            
            
        case 2


            zt=0.01*(1.27+2.72i)* Sbase/(150000);

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


cd('Constructed-Mat-Files/')
save('IEEE123SinglePhaseNetwork',  'Sbase', 'Vbase','N', 'allNodesActualLabels', 'Av1001', 'Av1002','Av1003','Av1004','Ytilde','spotloadData');
cd('..'); 
