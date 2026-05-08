function [pwm_square,pwm_square_int] = SquareGenerator(high_pwm,low_pwm,cycle_length,cycles_per_run,sample_rate,gap_length)
pwm_square = zeros(cycle_length*cycles_per_run*sample_rate,1);
pwm_square_int = zeros(cycle_length*cycles_per_run*sample_rate,1);
time = zeros(size(pwm_square));
for t = 0:cycle_length*cycles_per_run*sample_rate
    [pwm_square(t+1),pwm_square_int(t+1)] = pwmSquareWaveGenerator(mod(t/sample_rate,cycle_length),high_pwm,low_pwm,cycle_length/2);
    time(t+1) = t;
end
[pwm_square,pwm_square_int] = gapAdd(gap_length,sample_rate,pwm_square);
end

function [pwm, pwm_int] = pwmSquareWaveGenerator(t, start,stop, Tmax)
if(t<= Tmax)
    pwm = start;
    pwm_int = int32(pwm);
else
    pwm = stop;
    pwm_int = int32(pwm);
end
end