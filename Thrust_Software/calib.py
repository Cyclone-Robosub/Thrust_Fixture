from init import hx_1, hx_2

# Tare function --> takes samples, averages, calls that 0
def tare(hx, samples=10):
    total = 0
    for _ in range(samples):
        total += hx.get_value()
    return total // samples

offset_1 = tare(hx_1)
offset_2 = tare(hx_2)

# calibration ratio ... needs to be experimentally determined
ratio = 1