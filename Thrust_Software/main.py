import os
import time
from machine import PWM, Pin
from calib import hx_1, hx_2, offset_1, offset_2, ratio

# when reading the .csv ignore the first column
# set the sampling rate of the force values to 2 x frequency? Nyquist
# add a PWM log?
# Available PWM signal files --> these will need to be routed to computer's files?
PWMs = ['square_wave_1700us_test.csv']

# correct GPIO?
ESC = PWM(Pin(13))

# ESC frequency matches sampling rate
ESC.freq(80)

# 65535 corresponds to the 16 bits of the Pico, the 12500 corresponds to the freqeuncy
def set_throttle(pulse_us):
    duty = int(pulse_us * 65535 / 12500)
    ESC.duty_u16(duty)

# Arm the ESC
set_throttle(1000)
time.sleep(2)

# Display available signals
print("Available Signals: ")
for i, name in enumerate(PWMs):
    print(f"  {i}: {name}")

# Select signal
signal_name = input("Enter PWM Signal Name: ")

if signal_name in PWMs:
    index = PWMs.index(signal_name)
    print(f"Selected: {signal_name}")
else:
    print(f"Signal {signal_name} not found.")
    exit()

# Initialize data arrays
data_1 = []
data_2 = []
pwm_log = []
timestamps = []

start_time = time.ticks_ms()

# Main data collection loop
try:
    with open(signal_name, 'r') as f:
        for line in f:
            col = line.strip().split(',')
            if len(col) < 2:
                continue
            time_val = col[0]
            pwm_val = col[1]

            times = float(time_val)
            pwm = int(pwm_val)

            set_throttle(pwm)

            # take calibrated readings
            reading_1 = (hx_1.get_value() - offset_1) / ratio
            reading_2 = (hx_2.get_value() - offset_2) / ratio
            
            pwm_log.append(pwm) 
            timestamps.append(times)
            data_1.append(reading_1)
            data_2.append(reading_2)

            time.sleep_ms(5)

except KeyboardInterrupt:
    print("\nStopped by user.")

finally: 
    set_throttle(1000)
    time.sleep(2)
    ESC.deinit()
    t = time.localtime()
    timestamp = '{}-{:02d}-{:02d}-{:02d}-{:02d}-{:02d}'.format(t[0], t[1], t[2], t[3], t[4], t[5])
    filename = f'{signal_name}.csv'

    with open(filename, 'w') as f:
        f.write('time_ms,loadcell_1, loadcell_2, pwm\n')
        for i in range(len(pwm_log)):
            f.write(f'{timestamps[i]}, {data_1[i]}, {data_2[i]}, {pwm_log[i]}\n')
    print(f'Data saved to {filename}')