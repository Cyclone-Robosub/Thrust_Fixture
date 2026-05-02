%% makePWMs.m
% this where we make the PWM csvs
% a few things to note, we want a cyle legnth of at least 3 seconds
% prefereably. I need to quardinate to see what the time step needs to be.
Voltage = 15; %[V]
PWM_min = 1100; %[us]
PWM_max = 1900; %[us]
cycle_length = 6e6;%[us]
cycles_per_run = 5; %a fully arbitrary descision...



%% Ramp Generation
start_pwm = 1200;
stop_pwm = 1800;
pwm_ramp = zeros(cycle_length*cycles_per_run,1);
pwm_ramp_int = zeros(cycle_length*cycles_per_run,1);
for t = 0:cycle_length*cycles_per_run
    [pwm_ramp(t+1),pwm_ramp_int(t+1)] = pwmRampGenerator(mod(t,cycle_length),PWM_min,PWM_max,cycle_length/2);
end
figure
plot(1:length(pwm_ramp),pwm_ramp)
   




%% Square Wave Generation
set_pwm = 1700;
pwm_square = zeros(cycle_length*cycles_per_run,1);
pwm_square_int = zeros(cycle_length*cycles_per_run,1);
for t = 0:cycle_length*cycles_per_run
    [pwm_square(t+1),pwm_square_int(t+1)] = pwmSquareWaveGenerator(mod(t,cycle_length),set_pwm,1500,cycle_length/2);
end
hold
plot(1:length(pwm_square),pwm_square);

%% Functions
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

function [pwm, pwm_int] = pwmSquareWaveGenerator(t, start,stop, Tmax)
if(t<= Tmax)
    pwm = start;
    pwm_int = int32(pwm);
else
    pwm = stop;
    pwm_int = int32(pwm);
end
end

