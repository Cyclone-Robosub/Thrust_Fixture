%% setup
clear,clc,close

%% Use validation plots
vld_plt = 1;

% just a fun comparison of the guarded vs unguarded data

%% Initial Conditions
w0 = 0;
Qhyd0 = 0;

%% Initial Parameters
run("coeffs.m");

%% Read data
% still need to implement validation data retreival...
% chose data
type_index = 3; %1= ramps, 2 = sines, 3 = squares
file_index = 3; %must be larger than 2
guard_index = 2; %1=free, 2=gaurd

% just a fun comparison of the guarded vs unguarded data
if vld_plt
    run("guard_compare.m");
end

run("read_and_plot.m");

%% Sim Run
tspan = time(end)./1000; %[s]
dt = mean(exp_results.tout(2:end)-exp_results.tout(1:(end-1)));
    
inputStructure.time = time./1000; %[s]
inputStructure.signals(1).values = pwm.*10^(-6);
    
results = sim("thruster_model");

%% Plot Results
figure
subplot 211
xlabel("Time(s)")
ylabel("Thrust(N)")
hold
plot(time.*10^-3,LS_2_force)
plot(time.*10^-3,LS_1_force)
plot(exp_results.T.Time,exp_results.T.Data)
plot(time.*10^-3,ideal_thrust)
plot(results.T.Time,results.T.Data)
legend("LS_2","LS_1","Thrust","ideal_thrust","sim_thrust")


subplot 212
xlabel("Time(s)")
ylabel("PWM (\mus)")
plot(results.PWM.Time,results.PWM.Data)
ylim([0,2000e-6])
plot(time.*10^-3,pwm.*10^-6)


%% System Identification
[TF, SS] = sysId(exp_results)

%% Parameter Estimation
% run("param_est.m")