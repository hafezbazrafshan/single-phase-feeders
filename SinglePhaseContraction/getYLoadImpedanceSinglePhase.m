function [ yLoadImpedance ] =getYLoadImpedanceSinglePhase( yL_load )
%GETYLOADIMPEDANCE obtains the load impedance matrix to be incorporated
%into the Z-BUS method.



yLoadImpedance=diag(yL_load);
end

