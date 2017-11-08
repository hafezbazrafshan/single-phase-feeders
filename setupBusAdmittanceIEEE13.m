% Saves a mat file named YBUSdata

% The YBUSdata includes the following important matrices:
% Ybus=  the bus admittance matrix without the slack bus
% YbusS, the bus admittance matrix witht the slack bus
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
cd('Constructed-Mat-Files/')
save('IEEE13SinglePhaseNetwork',  'Sbase', 'Vbase','N', 'allNodesActualLabels', 'Av1001','Ytilde','spotloadData');
cd('..'); 