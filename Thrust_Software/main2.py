import os
import time
from machine import PWM, Pin
from calib import hx_1, hx_2, offset_1, offset_2, ratio

# 65535 corresponds to the 16 bits of the Pico, the 12500 corresponds to the freqeuncy
def set_throttle(pulse_us, frequency):
    div = 10**6 / frequency
    duty = int(pulse_us * 65535 / div)
    ESC.duty_u16(duty)

def arm_esc():
    print("Arming ESC ... ")
    set_throttle(1000, frequency)
    time.sleep(2)
    print("ESC armed.")

# Available PWM signal files --> these will need to be routed to computer's files?
PWMs = ['square_1800-1500(us)_test_80(Hz)', 'sine_50(us)_test_80(Hz)', 'ramp_1900-1200(us)_test_80(Hz)']

# correct GPIO
ESC = PWM(Pin(5))

frequency = 80
ESC.freq(frequency)

# Arm the ESC
arm_esc()

# Display available signals
print("Available Signals: ")
for i, name in enumerate(PWMs):
    print(f"  {i}: {name}")

# Select signal
try:
    selection = int(input("\nEnter the index of PWM signal you choose: "))
    if 0 <= selection < len(PWMs):
        signal_name = PWMs[selection]
        print(f"Selected {signal_name}")
    else:
        print("Enter a valid index: ")
        raise SystemExit
except ValueError:
    print("Enter a valid number")
    raise SystemExit

t = time.localtime()
timestamp = '{}-{:02d}-{:02d}-{:02d}-{:02d}-{:02d}'.format(t[0], t[1], t[2], t[3], t[4], t[5])
filename = f'{signal_name}-{timestamp}.csv'

# Write Header
with open(filename, 'w') as f_out:
    f_out.write('time_ms,loadcell_1,loadcell_2,pwm\n')

# Pre-allocate the PWM signal
with open(signal_name + '.csv', 'r') as f_in:
    val = []
    for line in f_in:
        col = line.strip().split(',')
        if len(col) < 2:
            continue
        val.append((float(col[0]), int(col[1])))

scale = 1.0/ratio
count = 0

# Main data collection loop
try:
    print("Starting Run \n")
    with open(filename, 'a') as f_out:
        for times, pwm in val:
            set_throttle(pwm, frequency)

            # take calibrated readings
            reading_1 = (hx_1.get_value() - offset_1) * scale
            reading_2 = (hx_2.get_value() - offset_2) * scale
        
            f_out.write(f'{times}, {reading_1}, {reading_2}, {pwm}\n')

            # increment the count by 1
            count += 1
            if count % 100 == 0:
                f_out.flush()
            
    f_out.flush()
    
except KeyboardInterrupt:
    print("\nStopped by user.")

finally: 
    set_throttle(1000, frequency)
    time.sleep(2)
    ESC.deinit()
    print(f'Data saved to {filename}')