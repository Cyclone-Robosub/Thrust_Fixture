function thrust = voltToThrust(volt,calib)
% voltToThrust converts the recorded voltage reading to a thrust value
    volt = volt - mean(volt(1:10));
    thrust = volt/calib/1000*9.81;
end