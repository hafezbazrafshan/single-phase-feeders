# single-phase-feeders
This repository runs the single-phase Z-Bus on three IEEE distribution test networks. (It also creates single-phase bus admittances from the three-phase bus admittances --- that's why it differs from the repository single-phase-feeders). 

The folder ``Constructed-Mat-Files" includes the bus admittance matrix of the three networks.  A typical test run is given by the "test_run" script. If you are interested in using this material in your research, we kindly request you to cite the following publications:

1) M. Bazrafshan and N. Gatsis, ``Convergence of the Z-Bus method for three-phase distribution load-flow with ZIP loads," IEEE Trans. on Power Systems, submitted, Available online at https://arxiv.org/abs/1605.08511. 

2) M. Bazrafshan and N. Gatsis, ``On the solution of the three-phase load-flow in distribution networks," in Proc. Asilomar Conference on Signals, Systems, and Computers,  Nov. 2016.

3) M. Bazrafshan and N. Gatsis ``Convergence of the Z-Bus method and existence of unique solution in single-phase distribution
load-flow," in Proc. Global Conference on Signal and Information Processing, Dec. 2016.  Available online at https://sigport.org/sites/default/files/docs/globalsip.pdf


Description


-- setupBusAdmittance
% This script creates a MatFile named ``[NetworkName]SinglePhase.mat" in the
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
% The MatFile created here is input to the solve[NetworkName]SinglePhase
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

--solve