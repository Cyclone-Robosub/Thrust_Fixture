%% makePWMs
% this where we make the PWM csvs
% currently, the sample_rate is 80 Hz
Voltage = 15; %[V]
PWM_min = 1100; %[us]
PWM_max = 1900; %[us]
%factors to change
cycle_length = 3;%[s]
sample_rate = 10; %[Hz]
cycles_per_run = 6; %a fully arbitrary descision...
gap_length = 2; %amount of seconds stopped before PWM chages from 1500us

%{
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
%}


%% csv creation
    %Ramp Tests
    figure
    hold
    starts = [1200,1300,1400,1600,1700,1900];
    stops = [1800,1700,1600,1400,1300,1200];
    cycle_length = max(cycle_length).*ones(size(starts));
    cycles_per_run = max(cycles_per_run).*ones(size(starts));
    sample_rate = sample_rate;
    ramps = cell(length(starts)); ramp_ints = cell(length(starts));
    for i=1:length(starts)
        [ramps{i},ramp_ints{i}] = RampGenerator(starts(i),stops(i),cycle_length(i),cycles_per_run(i),sample_rate,gap_length);
        plot((0:(length(ramps{i})-1))/sample_rate,ramps{i})
        if(~EnforceLimit(ramps{i},PWM_min,PWM_max))
            file_name = sprintf("./test_signals/ramps/ramp_%d-%d(us)_test_%d(Hz).csv",starts(i),stops(i),sample_rate);
            writematrix([(0:(length(ramps{i})-1))'/sample_rate.*1000,ramp_ints{i}],file_name);
        else
            warning("Ramp signal between %d and %d has exceeded PWM limits.",starts(i),stops(i));
        end
    end

    %Square Tests
    figure
    hold
    starts = [1200,1300,1400,1600,1700,1800];
    stops = 1500.*ones(size(starts));
    cycle_length = max(cycle_length).*ones(size(starts));
    cycles_per_run = max(cycles_per_run).*ones(size(starts));
    sample_rate = sample_rate;
    squares = cell(length(starts)); square_ints = cell(length(starts));
    plot((0:(length(squares{i})-1))/sample_rate,squares{i})

    for i=1:length(starts)
        [squares{i},square_ints{i}] = SquareGenerator(starts(i),stops(i),cycle_length(i),cycles_per_run(i),sample_rate,gap_length);
        plot((0:(length(squares{i})-1))/sample_rate,squares{i});
        if(~EnforceLimit(squares{i},PWM_min,PWM_max))
            file_name = sprintf("./test_signals/squares/square_%d-%d(us)_test_%d(Hz).csv",starts(i),stops(i),sample_rate);
            writematrix([(0:(length(squares{i})-1))'/sample_rate.*1000,square_ints{i}],file_name);
        else
            warning("Square wave between %d and %d has exceded PWM limits.",starts(i),stops(i));
        end
    end

    %Sine Tests
    figure
    hold
    Amplitude = [50,100,150,200,250];
    offset = 1500*ones(size(Amplitude));
    cycle_length = max(cycle_length).*ones(size(Amplitude));
    cycles_per_run = max(cycles_per_run).*ones(size(Amplitude));
    sample_rate = sample_rate;
    sines = cell(length(Amplitude)); sine_ints = cell(length(Amplitude));
    for i=1:length(Amplitude)
        [sines{i},sine_ints{i}] = SineGenerator(Amplitude(i),offset(i),cycle_length(i),cycles_per_run(i),sample_rate,gap_length);
        plot((0:(length(sines{i})-1))/sample_rate,sines{i})
        if(~ EnforceLimit(sines{i},PWM_min,PWM_max))
            file_name = sprintf("./test_signals/sines/sine_%d(us)_test_%d(Hz).csv",Amplitude(i),sample_rate);
            writematrix([(0:(length(sines{i})-1))'/sample_rate.*1000,sine_ints{i}],file_name);
        else
            warning("Sine wave with %d Amplitude and %d offset has exceeded PWM limits.",Amplitude(i),offset(i))
        end
    end
