function [pwm,pwm_int] = gapAdd(gap_length, sample_rate, pwm)
%enter gap_length in s
gap_length = 1500.*ones(gap_length*sample_rate,1); %convert to ms
pwm = vertcat(gap_length,pwm);
pwm_int = int32(pwm);
end