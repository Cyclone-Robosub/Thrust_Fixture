import os
from time import sleep
from machine import Pin
from hx711 import *

# initialize both amplifiers
# initalize the hx711 with pin 21 as clock pin, pin 20 as data pin
hx_1 = hx711(Pin(21), Pin(20))
hx_2 = hx711(Pin(), Pin()) # unsure of these pins rn

# Power on Amplifiers
hx_1.set_power(hx711.power.pwr_up)
hx_2.set_power(hx711.power.pwr_up)

# Set Gain --> 128 rn
hx_1.set_gain(hx711.gain.gain_128)
hx_1.set_power(hx711.power.pwr_down)
hx711.wait_power_down() # note: this command is just "timer" command like sleep
hx_1.set_power(hx711.power.pwr_up)
hx711.wait_settle(hx711.rate.rate_10) # note: this command is just "timer" command like sleep

hx_2.set_gain(hx711.gain.gain_128)
hx_2.set_power(hx711.power.pwr_down)
hx711.wait_power_down()
hx_2.set_power(hx711.power.pwr_up)
hx711.wait_settle(hx711.rate.rate_10)