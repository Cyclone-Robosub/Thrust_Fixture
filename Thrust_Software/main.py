import numpy as np
import scipy as sp
import pandas as pd
import datetime
import os
import pigpio
import time
from calib import hx_1, hx_2

# Available PWM signal files
PWMs = ['Thrust_Software/square_wave_1700us_test.csv']

pi = pigpio.pi()
ESC = 13

pi.set_servo_pulsewidth(ESC, 1500)
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
    signal = pd.read_csv(PWMs[index], header=None, names=['index', 'pwm'])
else:
    print(f"Signal {signal_name} not found.")
    exit()

# Initialize data arrays
data_1 = []
data_2 = []
pwm_log = []

# Main data collection loop
try:
    for i, row in signal.iterrows():
        pwm_value = int(row['pwm'])
        pi.set_servo_pulsewidth(ESC, pwm_value)
        reading_1 = hx_1.get_value(3)
        reading_2 = hx_2.get_value(3)
        data_1.append(reading_1)
        data_2.append(reading_2)
        pwm_log.append(pwm_value)
        time.sleep(0.1)

except KeyboardInterrupt:
    print("\nStopped by user.")

finally:
    # Save results to CSV
    # add column with times --> force over time plot
    pi.set_servo_pulsewidth(ESC, 1500)
    pi.set_servo_pulsewidth(ESC, 0)
    pi.stop()

    timestamp = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    file = f'{os.path.basename(signal_name)}_{timestamp}.csv'
    out = pd.DataFrame({
        'load_cell_1': data_1,
        'load_cell_2': data_2,
        'pwm': pwm_log
    })
    out.to_csv(file, index=False)
    print(f"Data saved to {file}")