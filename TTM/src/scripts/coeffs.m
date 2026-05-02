%% coeffs
%   coefficient guesses from a paper that get pulled into the sim

%appears in the hydro block
kf1 = 0.005913;%[Nms/rad]
kf0 = 0.07278; %[Nm]
kv = 0.5392/10000;%[Nm/V]

%appears in the motor block
Imech = 0.0014804; %[kgm^2/rad]
bs = 0.1234251; %less than notheing, I'm just making stuff up
kT0 = 0.8643; %Bachmayer gave me nothing
kT = 0.000654556; %bachmayer gave me nothign