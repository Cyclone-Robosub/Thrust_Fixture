import numpy as np
from pathlib import Path
import matplotlib.pyplot as plt

def moving_average(data, window):
    kernel = np.ones(window) / window
    # (input signal, kernel, mode for length of output)
    # I say mode = same since I want a filtered signal of the same length as the input
    out = np.convolve(data, kernel, mode='same')
    return out

# other users must hardcode their own file path
out_folder = Path(r"C:\Users\tisda\OneDrive\Documents\GitHub\CRS - Controls\Thrust_Fixture")
print(out_folder)
print(list(out_folder.glob("*.csv")))

# construct an array of data csvs
outs = {file.name: np.genfromtxt(file, delimiter=',') for file in out_folder.glob("*.csv")}

file_list = list(outs.keys())
for i, name in enumerate(file_list):
    print(f"[{i}] {name}")
try: 
    selection = int(input("\nEnter the index of signal you would like to filter: "))
    if 0 <= selection < len(file_list):
        signal_name = file_list[selection]
        data = outs[signal_name]
        data = outs[signal_name][:, 1]  # change 1 to whichever column has your signal
        print(f"Selected: {signal_name}")
    else:
        print("Enter a proper index.")
        exit()

except ValueError:
    print("Enter a valid number")
    exit()

filtered_data = moving_average(data, window=3)
# window is subject to change depending on filter output
# too low of a window value may not kill noise while too high may cause lag

fig, ax = plt.subplots(2, 1)

ax[0].plot(data)
ax[0].set_title("Unfiltered Signal")

ax[1].plot(filtered_data)
ax[1].set_title("Filtered Data")

plt.tight_layout()
plt.show()