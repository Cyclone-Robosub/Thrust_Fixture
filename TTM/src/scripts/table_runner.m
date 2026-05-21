%% table_runner
% This script loads the thruster look up tables because matlab doesn't like
% it when i try to do that in a function. Pre set your polarity....

if polarity == "cw"
    load("cw_force.mat");
    thrusts = t200_updatedS2;
    %names = fields(t200_updatedS2);
    load("cw_pwm.mat");
    pwm_vals = t200_updatedS2;
elseif polarity == "ccw"
    load("ccw_force.mat");
    thrusts = t200_updatedS3;
    load("ccw_pwm.mat");
    pwm_vals = t200_updatedS3;
else
    warning("invalid thruster polarity entry")
end
names = ["x10","x12","x14","x16","x18","x20"];
thrusts = renamevars(thrusts,1:width(thrusts),names);