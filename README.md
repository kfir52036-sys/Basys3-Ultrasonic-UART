# FPGA Ultrasonic Distance Sensor with UART Output
![System Block Design](block_design.png)

This project implements a real-time ultrasonic distance measurement system on the **Digilent Basys 3 (Artix-7 FPGA)** development board.

## Hardware Architecture
* **MicroBlaze Soft Processor Core**: Orchestrates system operation and handles data processing.
* **Custom Ultrasonic Controller (HDL)**: Measures the precise duration of the echo pulse from an HC-SR04 sensor.
* **AXI GPIO**: Interfaces between the hardware counter and the MicroBlaze processor.
* **AXI UARTLite**: Streams the calculated distance to a PC at a stable **9600 Baud Rate**.

## Software Logic
The C firmware running on the MicroBlaze utilizes low-level register access via `xuartlite_l.h` to optimize BRAM memory consumption. It converts the raw echo time into centimeters using the standard sound velocity constant and outputs it continuously to the terminal.
