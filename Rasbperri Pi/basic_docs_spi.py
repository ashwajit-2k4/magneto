from machine import SPI, Pin
import utime
import network
import socket
import time

spi = machine.SPI(0, baudrate=40000000, polarity=1, phase=1, sck=machine.Pin(2), mosi=machine.Pin(3), miso=machine.Pin(4))
                                        # Depending on the use case, extra parameters may be required
                                        # to select the bus characteristics and/or pins to use.
cs = Pin(5, mode=Pin.OUT, value=1)      # Create chip-select on pin 4.
txdata = b"12345678"
iter = 500
start_time = utime.ticks_us()  # Get current time in microseconds
for _ in range(iter):
    try:
        cs(0)                               # Select peripheral.
        spi.write(txdata)              # Write 8 bytes, and don't care about received data.
    finally:
        cs(1)                               # Deselect peripheral.

    try:
        cs(0)                               # Select peripheral.
        rxdata = spi.read(8)          # Read 8 bytes while writing 0x42 for each byte.
    finally:
        cs(1)                               # Deselect peripheral.

end_time = utime.ticks_us()  # Get final time
elapsed_time = utime.ticks_diff(end_time, start_time)  # Compute elapsed time
print("Sent data:", txdata)
print("Received data:", rxdata)
print(f"Total Time: {elapsed_time} microseconds")
print(f"Time per Transaction: {elapsed_time / iter:.2f} microseconds")
print(f"Approx. Transactions per Second: {1_000_000 / (elapsed_time / iter):.2f}")
