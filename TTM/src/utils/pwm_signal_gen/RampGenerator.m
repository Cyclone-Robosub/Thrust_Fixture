function [pwm_ramp,pwm_ramp_int] = RampGenerator(start,stop,cycle_length,cycles_per_run,sample_rate,gap_length)

pwm_ramp = zeros(cycle_length*cycles_per_run*sample_rate,1);
pwm_ramp_int = zeros(cycle_length*cycles_per_run*sample_rate,1);
for t = 0:cycle_length*cycles_per_run*sample_rate
    [pwm_ramp(t+1),pwm_ramp_int(t+1)] = pwmRampGenerator(mod(t/sample_rate,cycle_length),start,stop,cycle_length/2);
end
[pwm_ramp,pwm_ramp_int] = gapAdd(gap_length,sample_rate,pwm_ramp);
end

function [pwm,pwm_int] = pwmRampGenerator(t, start, stop, Tmax)
    % pwmRampGenerator adapted from Kory's code in the initarchive
if(t <= Tmax)
    pwm = round((stop-start)/Tmax*t + start);  
    pwm_int = int32(pwm);
else
    pwm = 1500;
    pwm_int = int32(pwm);
end
end
