%% Read data and plotter
% This script both loads in the data selected in init, plots it, then run
% resampling in order to make it possible to run system identificaiton
% tools.

% note that emp_resutls is a copy of unprocessed data, then exp_results are
% the resutls that get processed and used in parameter etimation and system
% identification.
figure
save_folder = "C:\Users\rubystanton\Documents\GitHub\Thrust_Fixture\TTM\data\";
ramps = dir(fullfile(save_folder,"ramp/"));
squares = dir(fullfile(save_folder,"square/"));
sines = dir(fullfile(save_folder,"sine/"));
Gramps = dir(fullfile(save_folder,"Guard/ramp/"));
Gsquares = dir(fullfile(save_folder,"Guard/square/"));
Gsines = dir(fullfile(save_folder,"Guard/sine"));
Free_Cell =  {[ramps],  [sines],  [squares]};
Gaurd_Cell = {[Gramps], [Gsines], [Gsquares]};
tot_Cell = {Free_Cell,Gaurd_Cell};

%{
read_file = Free_Cell{type_index}(file_index).name;
gaurd_file = Gaurd_Cell{type_index}(file_index).name;
%preset_file = 
%}

read_file = tot_Cell{guard_index}{type_index}(file_index).name;

M = readmatrix(read_file);
time = M(:,1); %[ms]

%% formatting Load Cell Data
LS_1_read = -M(:,2); %Lower
LS_1_force = voltToThrust(LS_1_read,calib_const);
LS_1 = timeseries(LS_1_force,time./1000);

LS_2_read = M(:,3);
LS_2_force = voltToThrust(LS_2_read,calib_const);
LS_2 = timeseries(LS_2_force,time./1000);

pwm = M(:,4);

emp_results = Simulink.SimulationOutput;
emp_results.tout = time./1000; %convert to s
emp_results.LS_1 = LS_1;
emp_results.LS_2 = LS_2;
emp_results.T = timeseries(LS_1_force,time./1000);
emp_results.PWM = timeseries(pwm.*10^-6,time./1000);

%setting up ideal thrust
%voltage = 15;
%polarity = "ccw";
run("table_runner")
ideal_thrust = thruster_lookup(voltage,thrusts,pwm_vals,pwm);
%% Plotting
if vld_plt
plot(emp_results.LS_1.Time,emp_results.LS_1.Data)
hold
plot(emp_results.LS_2.Time,emp_results.LS_2.Data)
title(read_file)
plot(time./1000,ideal_thrust)

%legend("LS_1_emp","LS_1_exp","LS_2_emp","LS_2_exp","Ideal Thrust")
legend("LS_1 (N)","LS_2 (N)", "Ideal Thrust")

%{
%% ploting preset data
preset_file = "C:\Users\rubystanton\Documents\GitHub\Thrust_Fixture\TTM\test_signals\squares\square_1200-1500(us)_test_10(Hz).csv";
set_pwms =readmatrix(preset_file);
plot(set_pwms(:,1),thruster_lookup(voltage,thrusts,pwm_vals,set_pwms(:,2)))
%}
end
%% reformatting colllected data as a simulink output object
exp_results = Simulink.SimulationOutput;
exp_results.tout = time./1000;
exp_results.T = timeseries(LS_1_force,time./1000);
exp_results.PWM = timeseries(pwm.*10^-6,time./1000);

run("resampling");
%run("preprocess"); %still needs work...