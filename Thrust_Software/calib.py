from hx711 import HX711
from init import hx_1, hx_2

# tare the load cells
hx_1.zero(30)
hx_2.zero(30)

# calibrate the load cells
# ratio = ...
hx_1.set_scale_ratio(ratio)
hx_2.set_scale_ratio(ratio)