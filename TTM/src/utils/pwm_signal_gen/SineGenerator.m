function [pwm_sine,pwm_sine_int] = SineGenerator(Amplitude,cycle_length,cycles_per_run,sample_rate,gap_length)
frequency = 1/cycle_length; %[Hz]
pwm_sine = zeros(cycle_length*cycles_per_run*sample_rate,1);
pwm_sine_int = zeros(cycle_length*cycles_per_run*sample_rate,1);
time = zeros(size(pwm_sine));
for t = 0:cycle_length*cycles_per_run*sample_rate
    [pwm_sine(t+1),pwm_sine_int(t+1)] = pwmSineWaveGenerator(t/sample_rate,frequency,Amplitude);
    time(t+1) = t;
end
[pwm_sine,pwm_sine_int] = gapAdd(gap_length,sample_rate,pwm_sine);
end

function [pwm, pwm_int] = pwmSineWaveGenerator(t,frequency, Amp)
pwm = Amp*sin(frequency*2*pi*t)+1500;
pwm_int = int32(pwm);
end