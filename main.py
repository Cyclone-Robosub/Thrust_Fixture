# imports
import numpy as np
import scipy as sp
import pandas as pd
import datetime
import pigpio
import time
from pandas import read_csv
#from init import hx_1, hx_2
from calib import hx_1
#, hx_2

# possibility of needing to time the PWM signal using time.sleep(...)
# insert .csv's here
PWMs = ['step.csv', 'ramp.csv']
pi = pigpio.pi()

ESC = 13 # pin of pi connected to ESC

# Arm ESC
pi.set_servo_pulsewidth(ESC, 1500)
time.sleep(2)

print("Available Signals: ")
for i, name in enumerate(PWMs):
    print(f"  {i}: {name}")

# Get .csv file with PWM signals and Select signal of choice
signal_name = input("Enter PWM Signal Name: ")

if signal_name in PWMs: 
    index = PWMs.index(signal_name)
    print(f"Selected: {signal_name}")
    signal = pd.read_csv(PWMs[index])
else:
    print(f"Signal {signal_name} not found.")
    exit()

# initialize data arrays
data_1 = []
#data_2 = []
pwm_log = []

for i, row in signal.iterrows():
    # output commands from "signal" to thrusters
    pwm_value = int(row['pwm']) # or what else is set by Ruby
    pi.set_servo_pulsewidth(ESC, pwm_value)
    time.sleep(0.1)

    # read thruster data from load cell and then append to the results vector
    # data collection is sorted by amplifier since each amplifier corresponds to a separate load cell
    # will need to discuss a better naming convention?
    
    reading_1 = hx_1.get_weight_mean(30)    # read from load cell
    #reading_2 = hx_2.get_weight_mean(30)

    # append readings into their own columns
    data_1.append(reading_1)
    #data_2.append(reading_2)
    pwm_log.append(pwm_value)

# stop thruster
pi.set_servo_pulsewidth(ESC, 1500)
pi.set_servo_pulsewidth(ESC, 0)
pi.stop()

# convert results into .csv form
timestamp = datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
file = f'{signal_name}_{timestamp}.csv'

# creates two separate columns in the .csv containing each load cell
out = pd.DataFrame({
    'load_cell_1' : data_1 ,
    
    'pwm' : pwm_log
})
#'load_cell_2' : data_2 ,
out.to_csv(file, index=False)