%% Parameter Estimation Script
% script which sets up and runs parameter estimation for thruster model

%% setup sim experiment


open_system("thruster_model") %model needs to be open for sdo
%experiment set up
Exp = sdo.Experiment('thruster_model');
Exp.Description = ['Simmulated respresentation of the ' ...
    'thruster based on literature review and brain rot.'];
%signal set up
    T = Simulink.SimulationData.Signal;
    T.Name = 'T';
    T.BlockPath = "thruster_model/Thruster";
    T.PortType = 'outport';
    T.PortIndex = 1;
    T.Values = exp_results.T;

Exp.OutputData = T;
Exp.InputData = exp_results.PWM;
Exp.InitialStates = sdo.getStateFromModel('thruster_model');
%Exp.InitialStates.Minimum = [0,0];
%Exp.InitialStates.Free = true;

%% create simulator
Simulator = createSimulator(Exp);
Simulator = sim(Simulator);
SimLog = find(Simulator.LoggedData,get_param('thruster_model','SignalLoggingName'));
TSignal = find(SimLog,'T');

%% parameter estimation
p = sdo.getParameterFromModel('thruster_model',{'kf1','kf0','kv','Imech','bs','kT0','kT'});
    p(1).Minimum = -inf;
    p(1).Maximum = inf;
    p(2).Minimum = -inf;
    p(2).Maximum = inf;
    p(3).Minimum = -inf;
    p(3).Maximum = inf;
    p(4).Minimum = -inf;
    p(4).Maximum = inf;
    p(5).Minimum = -inf;
    p(5).Maximum = inf;
    p(6).Minimum = -inf;
    p(6).Maximum = inf;
    p(7).Minimum = -inf;
    p(7).Maximum = inf;

s = getValuesToEstimate(Exp);
v = [p;s];

%estimation objective
estFcn = @(v) tm_objective(v,Simulator,Exp);

opt = sdo.OptimizeOptions;
opt.Method = 'lsqnonlin'; %least sqaures non linear method

%estimate the parameters
try
vOpt = sdo.optimize(estFcn,v,opt)
catch
    disp("optimization failed")
end
kf1   = vOpt(1,1).Value;
kf0   = vOpt(2,1).Value;
kv    = vOpt(3,1).Value;
Imech = vOpt(4,1).Value;
bs    = vOpt(5,1).Value;
kT0   = vOpt(6,1).Value;
kT    = vOpt(7,1).Value;

%% Validation
figure
subplot 211
%plot(results.T.Time,results.T.Data)
xlabel("Time(s)")
ylabel("Thrust(N)")
hold
plot(exp_results.T.Time,exp_results.T.Data)
plot(Gtime.*10^-3,ideal_thrust)
Simulator = createSimulator(Exp);
SimLog = sim(Simulator);
SimLog = find(SimLog.LoggedData,get_param('thruster_model','SignalLoggingName'));
sim_thrust = find(SimLog,"T");
plot(sim_thrust.Values.Time,sim_thrust.Values.Data)
legend("Thrust","ideal_thrust","sim_thrust")


subplot 212
plot(results.PWM.Time,results.PWM.Data)
xlabel("Time(s)")
ylabel("PWM (\mus)")
ylim([0,2000e-6])