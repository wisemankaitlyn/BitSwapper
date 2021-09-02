vlib work
vmap work

vcom ../../Source/BitSwapper.vhd
vcom ../Source/BitSwapper_tb.vhd

#vsim BitSwapper_tb

#add wave -group {UUT} BitSwapper_tb/Uut/*

#run -all