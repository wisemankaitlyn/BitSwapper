vlib work
vmap work

vcom -work work ../../Source/BitSwapper.vhd
vcom -work work ../Source/BitSwapper_tb.vhd

vsim work.BitSwapper_tb

add wave -group {TB}  BitSwapper_tb/*
add wave -group {UUT} BitSwapper_tb/Uut/*

run -all
echo "done!"