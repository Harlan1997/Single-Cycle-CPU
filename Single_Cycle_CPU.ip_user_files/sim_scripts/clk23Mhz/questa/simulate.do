onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib clk23Mhz_opt

do {wave.do}

view wave
view structure
view signals

do {clk23Mhz.udo}

run -all

quit -force
