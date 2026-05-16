function [pwm,pwm_int] = gapAdd(gap_length, sample_rate, pwm)
%enter gap_length in s
%sample rate should be in hz
dead_zone = 1500.*ones(gap_length*sample_rate,1); %convert to ms
pwm = vertcat(zeros(gap_length*sample_rate/2,1),dead_zone,pwm);
pwm_int = int32(pwm);
end