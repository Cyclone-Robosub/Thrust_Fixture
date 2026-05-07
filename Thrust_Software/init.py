import RPi.GPIO as GPIO                # import GPIO
from hx711 import HX711                # import the class HX711
  
GPIO.setmode(GPIO.BCM)                 # set GPIO pin mode to BCM numbering

# initialize both amplifiers
hx_1 = HX711(23, 24)
hx_2 = HX711(27, 22)