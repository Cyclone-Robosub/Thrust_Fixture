function [tf,ss] = sysId(results, refResult)
%This function will generate a transfer function and state space model for
%provided expeimental results (of Simmulation Output class). When two sets
%of data are inputed, the models will be generated from the first set and
%compared to the second set for validation, otherwise, validation will only
%be performed using the first set of data.


%---------------------IMPORT DATA------------------------------------------
y = vertcat(results.T.Data);
u = vertcat(results.PWM.Data);
Ts = results.T.TimeInfo.Increment;
try
    mydata = iddata(y, u, Ts);
    gen_tf = 1;
catch
    mydata = iddata(y,u,[],'SamplingInstants',results.T.Time);
    tt = timetable(y,u,'RowTimes',seconds(results.T.Time));
    gen_tf = 0;
    warning("lowk try running resampling.m")
end

%---------------------TRANSFER FUNCTION MODEL------------------------------
%Transfer function estimation
if gen_tf
Options_tf = tfestOptions;
Options_tf.Display = 'on';
Options_tf.EnforceStability = true;
Options_tf.InitialCondition = 'zero';
Options_tf.SearchOptions.Tolerance = 1e-19;
Options_tf.SearchOptions.MaxIterations = 10000;

tf = tfest(mydata, 2, 0, Options_tf);
tf.Name = 'tfModel';



%TF Model Validation
if nargin == 2
    %Import Data for Transient reference Data
    %y = vertcat(zeros(50,1), refResult.T.Data);
    %u = vertcat(zeros(50,1),refResults.PWM.Data);
    y = refResult.T.Data;
    u = refResults.PWM.Data;
    transientref = iddata(y, u, Ts);

    figure
    Options_compare = compareOptions;
    Options_compare.InitialCondition = 'z';
    compare(transientref, tf, Options_compare, 1)
    set(findall(gca, 'Type', 'Line'), 'Linewidth', 4)
    grid On
elseif nargin == 1
    figure
    Options_compare = compareOptions;
    Options_compare.InitialCondition = 'z';
    compare(mydata, tf, Options_compare, 1)
    set(findall(gca, 'Type', 'Line'), 'Linewidth', 4)
    grid On
end
else
    tf = "narp";
end
%---------------------STATE SPACE MODEL------------------------------------

%State space estimation
Options_ss = n4sidOptions;
Options_ss.Display = 'on';
Options_ss.InitialState = 'zero';

if gen_tf
ss = n4sid(mydata, 2, 'Form', 'free', 'Ts', Ts, Options_ss);
else
ss = n4sid(mydata, 2, 'Form', 'free', Options_ss);
end

%SS Model Validation
figure

compare(mydata, ss, 1)
set(findall(gca, 'Type', 'Line'), 'Linewidth', 4)
grid On

end