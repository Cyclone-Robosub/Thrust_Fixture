%% setup
clear,clc,close

%% Use validation plots
vld_plt = 0;

% just a fun comparison of the guarded vs unguarded data

%% Initial Conditions
w0 = 0;
Qhyd0 = 0;

%% Initial Parameters
run("coeffs.m");

%% Read data
% still need to implement validation data retreival...
% chose data
type_index = 1; %1= ramps, 2 = sines, 3 = squares
file_index = 6; %must be larger than 2
guard_index = 2; %1=free, 2=gaurd

% just a fun comparison of the guarded vs unguarded data
run("guard_compare.m"); %right now, this is loading in everything...
run("read_and_plot.m");

exp_results1 = exp_results;


%% Read data
% still need to implement validation data retreival...
% chose data
type_index = 1; %1= ramps, 2 = sines, 3 = squares
file_index = 4; %must be larger than 2
guard_index = 2; %1=free, 2=gaurd

% just a fun comparison of the guarded vs unguarded data
run("guard_compare.m"); %right now, this is loading in everything...
run("read_and_plot.m");

%% Sim Run
tspan = exp_results.tout(end); %[s]
dt = exp_results.T.TimeInfo.Increment;
    
inputStructure.time = exp_results.PWM.Time; %[s]
inputStructure.signals(1).values = exp_results.PWM.Data;
    
results = sim("thruster_model");

%% Plot Results
figure
subplot 211
xlabel("Time(s)")
ylabel("Thrust(N)")
hold
plot(Gtime.*10^-3,G_LS_1.Data)
plot(Gtime.*10^-3,G_LS_2.Data)
plot(exp_results.T.Time,exp_results.T.Data)
plot(time.*10^-3,ideal_thrust)
plot(results.T.Time,results.T.Data)
legend("LS_2","LS_1","Thrust","ideal_thrust","sim_thrust")


subplot 212
xlabel("Time(s)")
ylabel("PWM (\mus)")
plot(results.PWM.Time,results.PWM.Data)
ylim([0,2000e-6])
hold
plot(emp_results.PWM.Time-emp_results.PWM.Time(1),emp_results.PWM.Data)


%% System Identification
[TF, SS] = sysId(exp_results, exp_results1)

%% Parameter Estimation
%run("param_est.m")