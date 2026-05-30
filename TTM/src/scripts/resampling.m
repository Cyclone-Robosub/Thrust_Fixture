%% Resampling
desired_fs = 10;
irregTx = emp_results.tout - emp_results.tout(1);
x = emp_results.T.Data;
[y,Ty] = resample(x,irregTx,desired_fs);

[pwm_resamp,~] = resample(exp_results.PWM.Data.*10^6,irregTx,desired_fs,"linear");

%% Validation:
if vld_plt
figure
plot(emp_results.tout,emp_results.T.Data)
hold
plot(Ty,y)
title("resampling validation")
xlabel("time")
ylabel("Thrust")
legend("original","resampled")
end

%% Reassignment
exp_results.T = timeseries;
exp_results.T.Data = y;
exp_results.T.Time = Ty;
exp_results.T.TimeInfo.Increment = Ty(2)-Ty(1);
exp_results.PWM = timeseries;
if(type_index == 3)
    exp_results.PWM.Data = round(pwm_resamp*10^-6,4);
else
    exp_results.PWM.Data = round(pwm_resamp,0)*10^-6;
end
exp_results.PWM.Time = Ty;
exp_results.PWM.TimeInfo.Increment = Ty(2)-Ty(1);
exp_results.tout = Ty;



%% Reassignment Validation:
if vld_plt
figure
subplot 211
title("resample")
plot(exp_results.T.Time,exp_results.T.Data)
subplot 212
plot(Ty,y)
title("reassignment")
xlabel("time")
ylabel("Thrust")
%legend("reassigned","resampled")
end