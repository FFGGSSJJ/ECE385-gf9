transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/ECE385/lab4_proj/ece385sp16_lab4_adders {C:/ECE385/lab4_proj/ece385sp16_lab4_adders/HexDriver.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4_proj/ece385sp16_lab4_adders {C:/ECE385/lab4_proj/ece385sp16_lab4_adders/carry_select_adder.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4_proj/ece385sp16_lab4_adders {C:/ECE385/lab4_proj/ece385sp16_lab4_adders/lab4_adders_toplevel.sv}

vlog -sv -work work +incdir+C:/ECE385/lab4_proj/ece385sp16_lab4_adders {C:/ECE385/lab4_proj/ece385sp16_lab4_adders/testbench_adder.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
