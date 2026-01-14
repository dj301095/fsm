* FSM Post-Layout Simulation
.title fsm simulation
.model sg13g2_lv_nmos psp103va (type=1)
.model sg13g2_lv_pmos psp103va (type=-1)
* 1. Transistor Models
.lib "/home/doc/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib" mos_tt
* or sometimes more explicit:
*.include "/home/doc/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/cornerMOSlv.lib"
*.include "/home/doc/IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/models/sg13g2_moslv_mod.lib"   ; often needed
* 2. The Flattened Layout (No nested X-calls)
.include "fsm_flat_final.spice"

* 3. Power and Signals
Vdd VDD 0 DC 1.2
Vss VSS 0 DC 0
Vclk clk 0 PULSE(0 1.2 1n 100p 100p 5n 10n)
Vrst reset 0 PULSE(1.2 0 0 100p 100p 20n 1000n)

* 4. Instantiate the flat FSM
* (Make sure the pin order matches the .subckt in fsm_flat_final.spice)
X1 Timer_en adc_en clk_gating_en power_on sc_en timer_done tx_start 
+ uart_busy uart_done uart_en adc_done adc_start clk reset wake_up_sg 
+ VDD VSS fsm_flat

.tran 0.1n 100n
.control
  run
  plot v(clk) v(reset)+2 v(adc_start)+4
.endc
.end