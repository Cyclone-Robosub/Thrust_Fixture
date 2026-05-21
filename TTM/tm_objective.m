function values = tm_objective(v, Simulator, Exp)
%MSD_OBJECTIVE 
%   This function compares the simulated data to the experimental data.

%signal tracking requirement
r = sdo.requirements.SignalTracking;
r.Type = '==';
r.Method = 'Residuals';
r.Normalize =  'off';

%update experiment with estimated parameter values;
Exp = setEstimatedValues(Exp,v);

%running simulator to comapare with experimental data.
Error = [];
for ct=1:numel(Exp)
    
    Simulator = createSimulator(Exp(ct),Simulator);
    Simulator = sim(Simulator);

    SimLog  = find(Simulator.LoggedData,get_param('thruster_model','SignalLoggingName'));
    Thrust = find(SimLog,'T');

    ThrustError = evalRequirement(r,Thrust.Values,Exp(ct).OutputData(1).Values);
    
    Error = [ThrustError(:)];
end
values.F = Error(:);
end