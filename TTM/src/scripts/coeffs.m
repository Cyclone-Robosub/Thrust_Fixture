%% coeffs

%non estimated parameters
voltage = 15;
polarity = "ccw";
a_g = .2; %amplifier gain
calib_const = 211*a_g;

%estimated parameters
%appears in the hydro block
kf1 = 0.005913;%[Nms/rad]
kf0 = .7278; %[Nm]
kv = 0.5392/1500;%[Nm/V]

%appears in the motor block
Imech = 0.014804; %[kgm^2/rad]
bs = .0001; %less than notheing, I'm just making stuff up
kT0 = 300; %Bachmayer gave me nothing
kT = 0.07676; %bachmayer gave me nothign
