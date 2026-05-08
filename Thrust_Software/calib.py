from hx711 import HX711
from init import hx_1, hx_2

# tare the load cells
hx_1.tare()
hx_2.tare()

# calibrate the load cells
ratio = 1
hx_1.set_reference_unit(ratio)
hx_2.set_reference_unit(ratio)
