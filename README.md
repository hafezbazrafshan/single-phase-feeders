# single-phase-feeders
This repository creates single-phase versions of  IEEE 13-bus, IEEE 37-bus, and IEEE 123-bus distribution networks. The load-flow solution using the Z-Bus method. Further, it is demonstrated that the Z-Bus iterations are contracting.



1) M. Bazrafshan and N. Gatsis, "Convergence of the Z-Bus Method for Three-Phase Distribution Load-Flow with ZIP Loads," in *IEEE Trans.  Power Syst.*, to be published. doi:10.1109/TPWRS.2017.2703835. See the [arXiv version](https://arxiv.org/pdf/1605.08511.pdf).


2) M. Bazrafshan and N. Gatsis ``Convergence of the Z-Bus method and existence of unique solution in single-phase distribution
load-flow," in *Proc. Global Conf. Signal \& Information Proc.*, Washington, DC, Dec. 2016.  See the [Presentation slides](https://sigport.org/sites/default/files/docs/globalsip.pdf).


## Code description 

The following IEEE networks are modeled: 
* The IEEE 13-bus 
* The IEEE 37-bus
* The IEEE 123-bus

The required data to model the above  networks are downloaded from 
https://ewh.ieee.org/soc/pes/dsacom/testfeeders/ 
and are included in the corresponding data folders. 

For each network, the scripts `setupBusAdmittance<NetworkName>.m` and `solve<NetworkName>.m` are provided and are explained next.


### `setupBusAdmittance<NetworkName>.m`
 This script creates a MatFile named `<NetworkName>SinglePhase.mat` in the
 directory [SinglePhaseMatFiles/](https://github.com/hafezbazrafshan/single-phase-feeders/tree/FeederConstruction/SinglePhaseMatFiles).   The MatFile contains the following
 
 #### Output fields
 1. `Sbase`
 2. `Vbase`
 3. `N` (Number of buses without the Slack bus)
 4. `allNodesActualLabels` (Bus labels as given by the IEEE feeders)
 5. `Av1001` (The voltage gains of the step-voltage regulator)
 6. `Ytilde` (the bus admittance matrix)
 7. `sL_load`  (Vector of `nominal power' of constant-power loads)
 8. `iL_load` (Vector of `nominal current' of constant-current loads)
 9. `yL_load` (Vector of `nominal admittance' of constant-impedance loads)
 10. `gMat` (An N*3 binary matrix determining load-type per node.  
 For example, `gMat(i,:)=[1 0 0]` determines constant-power load only, 
 `gMat(i,:)=[1,0,1]` determines constant-power and constant-impedance loads)
 11. `Y` (the bus admittance matrix removing the slack bus)
 12. `Y_NS` (the portion of Ytilde corresponding to the interface of network
 and slack bus)
 13. `yImpedance` (the matrix YL corresponding to constant-impedance loads)
14. `Ycheck` ( Y+YImpedance)
 15. `w` (the no-load voltage profile)
 16. `Z` (inverse of Ycheck)

The MatFile created here is input to the `solve<NetworkName>SinglePhase.m`

 #### Some comments: 
* The conversion from  multi-phase lines to single-phase is as follows:
  1. Three-by-three Nodal admittances YNMn, YMNn, YNMm, YMNm 
          are created first by assuming zero's in their rows and columns corresponding to 
          columns.  
  2. The average of non-zero diagonal entires and the non-zero
          off diagonal entries is computed, denoted respectively by yd and
         yo. 
  3. A symmetrical 3*3 matrix is then constructed
          `YSymmetric=[yd, yo, yo; yo, yd, yo; yo, yo, yd]`;
  4.  A symmetrical component transformation is then applied
          yielding  a diagonal matrix `Ydiagonal=diag([y0; y1; y2])`.
  5. The representative admittance of the corresponding line is
           then chosen as `y1`.  
* The conversion from multi-phase loads to single-phase: the sum of
  loads per bus is divided by three.  Of course, this is  heuristical
  since single-phase representation is for balanced networks only.
 
 ### `solve<NetworkName>.m`
  This script takes in a MatFile named `<NetworkName>SinglePhase.mat` from the
 directory [SinglePhaseMatFiles/](https://github.com/hafezbazrafshan/single-phase-feeders/tree/FeederConstruction/SinglePhaseMatFiles) and computes the Z-Bus method 
