%% setup
%clear,clc

%% initial conditions
w0 = 0;
Qhyd0 = 0;

%% Param Guesses
run("coeffs.m");

%% sim run
%set step input
tspan = 100; %[s]
dt = .01; %[s]

    PWM = 1700e-6; %[s]
    inputStructure.time = [0:dt:tspan]';
    inputSignal1 = PWM.*ones(size(inputStructure.time));
    inputStructure.signals(1).values = inputSignal1;

    results = sim("thruster_model");

%% 
figure(1)
subplot 311
plot(results.T.Time,results.T.Data)
xlabel("Time(s)")
ylabel("Thrust(N)")
subplot 312
plot(results.w.Time,results.w.Data)
xlabel("Time(s)")
ylabel("\omega (rad/s)")
subplot 313
plot(results.PWM.Time,results.PWM.Data)
xlabel("Time(s)")
ylabel("PWM (\mus)")
ylim([1000e-6,2000e-6])


%%
%[TF, SS] = sysId(results)