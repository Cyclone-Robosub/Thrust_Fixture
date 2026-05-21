%% gaurd compare
run("table_runner.m")
%{
% chose data
type_index = 3; %1= ramps, 2 = sines, 3 = squares
file_index = 3; %must be larger than 2
%}
save_folder = "C:\Users\rubystanton\Documents\GitHub\Thrust_Fixture\TTM\data\";
ramps = dir(fullfile(save_folder,"ramp/"));
squares = dir(fullfile(save_folder,"square/"));
sines = dir(fullfile(save_folder,"sine/"));
Gramps = dir(fullfile(save_folder,"Guard/ramp/"));
Gsquares = dir(fullfile(save_folder,"Guard/square/"));
Gsines = dir(fullfile(save_folder,"Guard/sine"));
Free_Cell =  {[ramps],  [sines],  [squares]};
Gaurd_Cell = {[Gramps], [Gsines], [Gsquares]};

read_file = Free_Cell{type_index}(file_index).name;
gaurd_file = Gaurd_Cell{type_index}(file_index).name;
GM = readmatrix(gaurd_file);
M = readmatrix(read_file);

Gtime = GM(:,1); %[ms]
time = M(:,1);
a_g = .2; %amplifier gain
%calib_const = 211;

%% formatting Load Cell Data
G_LS_1_read = -GM(:,2); %Lower
LS_1_read = -M(:,2); %Lower

G_LS_2_read = GM(:,3);
LS_2_read= M(:,3);

%% Plot results
if vld_plt
figure
hold
title("Thrust output for guarded and free thrusters")
plot(Gtime./1000,voltToThrust(G_LS_1_read,calib_const))
plot(time./1000,voltToThrust(LS_1_read,calib_const))
plot(Gtime./1000,voltToThrust(G_LS_2_read,calib_const))
plot(time./1000,voltToThrust(LS_2_read,calib_const))
ylabel("Thrust (N)")
xlabel("Time (s)")
legend("LS1_{guard}","LS1_{free}","LS2_{guard}","LS2_{free}")
end