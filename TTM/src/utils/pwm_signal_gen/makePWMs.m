%% makePWMs
% this where we make the PWM csvs
% currently, the sample_rate is 80 Hz
Voltage = 15; %[V]
PWM_min = 1100; %[us]
PWM_max = 1900; %[us]
%factors to change
cycle_length = 3;%[s]
sample_rate = 80; %[Hz]
cycles_per_run = 6; %a fully arbitrary descision...
gap_length = 2; %amount of seconds stopped before PWM chages from 1500us

%% Ramp Generation
start_pwm = 1200;
stop_pwm = 1800;
[pwm_ramp,pwm_ramp_int] = RampGenerator(start_pwm,stop_pwm,cycle_length,cycles_per_run,sample_rate,gap_length);
figure


%% Square Wave Generation
high_pwm = 1700;
low_pwm = 1500;
[pwm_square,pwm_square_int] = SquareGenerator(high_pwm,low_pwm,cycle_length,cycles_per_run,sample_rate,gap_length);
file_name = sprintf("./test_signals/squares/square_wave_%d(us)_test.csv",high_pwm);
writematrix([(0:(length(pwm_square_int)-1))'/sample_rate,pwm_square],file_name);

%% Sine Wave Generation
Amplitude = 1700 - 1500; %[us]
[pwm_sine,pwm_sine_int] = SineGenerator(Amplitude,cycle_length,cycles_per_run,sample_rate,gap_length);


%% Plotting
plot((0:(length(pwm_ramp)-1))/sample_rate,pwm_ramp)
hold
plot((0:(length(pwm_square)-1))/sample_rate,pwm_square);
plot((0:(length(pwm_sine)-1))/sample_rate,pwm_sine);
xlabel("time (s)")
ylabel("PWM (us)")

