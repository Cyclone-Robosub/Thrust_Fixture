#clone this library from github: https://github.com/endail/hx711-pico-mpy/blob/main/README.md
import os
from time import sleep
from machine import Pin
from hx711 import *

# 1. initalise the hx711 with pin 21 as clock pin, pin
# 20 as data pin
hx = hx711(Pin(21), Pin(20))

# 2. power up
hx.set_power(hx711.power.pwr_up)

# 3. [OPTIONAL] set gain and save it to the hx711
# chip by powering down then back up
hx.set_gain(hx711.gain.gain_128)
hx.set_power(hx711.power.pwr_down)
hx711.wait_power_down()
hx.set_power(hx711.power.pwr_up)

# 4. wait for readings to settle
hx711.wait_settle(hx711.rate.rate_10)

# 5. read values -  skip past calibration

#for calibration only, run this loop forever:
'''while True:
    sleep(0.5)'''
    
    
# wait (block) until a value is read
    val = hx.get_value()
    `
# or use a timeout
    if val := hx.get_value_timeout(250000):
    # value was obtained within the timeout period
    # in this case, within 250 milliseconds
        print(val)

# or see if there's a value, but don't block if not
    if val := hx.get_value_noblock():
        print(val)

# 6. stop communication with HX711
hx.close()


