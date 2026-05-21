function ideal_thrust = thruster_lookup(voltage,thrusts,pwm_vals,pwm)
%% PWM to force calculator
if mod(voltage,2) ~= 0
    low_volt = voltage - 1;
    low_volt = sprintf("x%i",low_volt);
    high_volt = voltage + 1;
    high_volt = sprintf("x%i",high_volt);
    low_thrust = thrusts.(low_volt);
    high_thrust = thrusts.(high_volt);
    new_thrust = (high_thrust-low_thrust)./2+low_thrust;
else
    volt = sprint("x%i",voltage);
    new_thrust = thrusts.(volt);
end

%% Calculate idealized thrust
ideal_thrust = zeros(size(pwm));
for i=1:length(pwm)
    if pwm(i) > 1000
        for j = 1:length(pwm_vals.Var1)
            if pwm(i) >= pwm_vals.Var1(j)
                high_pwm_val = pwm_vals.Var1(j,:);
                low_pwm_val = pwm_vals.Var1(j+1,:);
                slope = (pwm(i)-low_pwm_val)/(high_pwm_val-low_pwm_val);
                ideal_thrust(i) = new_thrust(j+1) + slope*(new_thrust(j)-new_thrust(j+1));
                break
            end

        end
    else
        ideal_thrust(i) = 0;
    end
end
end