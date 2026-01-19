* FSM Testbench translated from VHDL
.include "fsm_flat_final.spice"
.lib "/home/dj/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib" mos_tt

* --- Power Supplies ---
Vdd VDD 0 DC 1.2
Vss VSS 0 DC 0

* --- Clock Definition (100MHz) ---
Vclk clk 0 PULSE(0 1.2 1n 100p 100p 5n 10n)

* --- Stimulus Signals (Translated from VHDL stim_proc) ---
** --- Robust Stimulus ---

* 1. Reset: Active High (1.2V)
* Hold High for 50ns to fully reset the chip, then drop to 0 to Run.
Vrst reset 0 DC 0
*Vrst reset 0 PWL(0 0 20n 0 20.1n 1.2)
* 2. Wake Up: Wait until 100ns (50ns after reset is released)
* Pulse High for 40ns (4 clock cycles) to guarantee capture.
*Vwake wake_up_sg 0 PWL(0 0 100n 0 100.1n 1.2 180n 1.2 180.1n 0)
Vwake wake_up_sg 0 DC 1.2
* 3. Timer Done: Trigger later (e.g., at 200ns)
Vtdone timer_done 0 PWL(0 0 200n 0 200.1n 1.2 210n 1.2 210.1n 0)

* 4. Adc Done: Trigger after Timer (e.g., at 250ns)
Vadone adc_done 0 PWL(0 0 250n 0 250.1n 1.2 260n 1.2 260.1n 0)

* 5. UART signals: Shift later to match new timeline
Vubusy uart_busy 0 PWL(0 0 300n 0 300.1n 1.2 310n 1.2 310.1n 0)
Vudone uart_done 0 PWL(0 0 350n 0 350.1n 1.2 370n 1.2 370.1n 0)

* Power_on: Keep High
Vpon power_on 0 DC 1.2

* --- Simulation Settings ---
* Extend simulation to 400ns to see all new events
.tran 0.1n 400n
* --- Instantiate the FSM ---
X1 Timer_en adc_en clk_gating_en power_on sc_en timer_done tx_start
+ uart_busy uart_done uart_en adc_done adc_start clk reset wake_up_sg
+ VDD VSS fsm_flat

* --- Simulation Settings ---
.options gmin=1e-12 rshunt=1e12
.tran 0.1n 220n

.control
  run
  * Plotting with vertical offsets to visualize the logic analyzer style
  plot v(clk) (v(reset)+1.5) (v(wake_up_sg)+3) (v(clk_gating_en)+4.5) (v(sc_en)+6) (v(adc_en)+7.5) (v(uart_en)+9) (v(timer_en)+10.5) (v(timer_done)+12) (v(adc_start)+13.5) (v(adc_done)+15) (v(uart_busy)+16.5) (v(tx_start)+18) (v(uart_done)+19.5) 
.endc

.end