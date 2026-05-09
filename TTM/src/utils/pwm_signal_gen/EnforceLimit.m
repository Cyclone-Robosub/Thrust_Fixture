function [within_limit] = EnforceLimit(pwm,PWM_min,PWM_max)
%ENFORCELIMIT Summary of this function goes here
%   Detailed explanation goes here
limit(1) = (max(pwm)<=PWM_max);
limit(2) = (min(pwm)>=PWM_min);
within_limit = logical(sum(limit)==2);
end