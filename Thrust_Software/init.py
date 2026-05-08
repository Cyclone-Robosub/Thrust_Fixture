from hx711 import *

# initialize both amplifiers
# initalize the hx711 with pin 21 as clock pin, pin 20 as data pin
hx_1 = hx711(Pin(21), Pin(20))
hx_2 = hx711(Pin(), Pin())