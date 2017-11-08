function [ C1,C2,C3,C4 ] = printconditions( lambdaMaty, lamdaMatDELTA, wy,wDELTA ...
    cyPQ, cyI, cDELTAPQ, cDELTAI,....
    dyPQ, dyI, dDELTAPQ, dDELTAI,filename)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



C1= ['R- ', num2str(min(diag(WY./lambdaMaty)))]; 
C2= ['R- ',num2str(min(diag(WDELTA./2/lambdaMatDELTA)))]; 
C3=[num2str(double(cyPQ)),'+',...
    num2str(double(cDELTAPQ)),'+',...
    num2str(double(cyI)), '+', num2str(cDELTAI)];
C4=[num2str(double(dyPQ)), '+',...
    num2str(double(dDELTAPQ)), '+',...
    num2str(double(dyI)),...
    '+', num2str(dDELTAI)];

if exist('Text results')~=7
    mkdir 'Text results';
end

cd('Text results'); 
filename=[filename,'.txt'];
fileID=fopen(filename,'w');
fprintf(fileID,[C1,'\n', C2, '\n', C3, '\n', C4, '\n']); 
fclose(fileID); 
cd('..'); 

end

