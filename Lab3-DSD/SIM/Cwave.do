onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /controlunit_tb/clk_tb
add wave -noupdate /controlunit_tb/rst_tb
add wave -noupdate /controlunit_tb/st_tb
add wave -noupdate /controlunit_tb/ld_tb
add wave -noupdate /controlunit_tb/mov_tb
add wave -noupdate /controlunit_tb/add_tb
add wave -noupdate /controlunit_tb/sub_tb
add wave -noupdate /controlunit_tb/jmp_tb
add wave -noupdate /controlunit_tb/jc_tb
add wave -noupdate /controlunit_tb/jnc_tb
add wave -noupdate /controlunit_tb/andf_tb
add wave -noupdate /controlunit_tb/orf_tb
add wave -noupdate /controlunit_tb/xorf_tb
add wave -noupdate /controlunit_tb/Cflag_tb
add wave -noupdate /controlunit_tb/Zflag_tb
add wave -noupdate /controlunit_tb/Nflag_tb
add wave -noupdate /controlunit_tb/Mem_wr_tb
add wave -noupdate /controlunit_tb/Mem_out_tb
add wave -noupdate /controlunit_tb/Mem_in_tb
add wave -noupdate /controlunit_tb/Cout_tb
add wave -noupdate /controlunit_tb/Cin_tb
add wave -noupdate /controlunit_tb/Ain_tb
add wave -noupdate /controlunit_tb/RFin_tb
add wave -noupdate /controlunit_tb/RFout_tb
add wave -noupdate /controlunit_tb/IRin_tb
add wave -noupdate /controlunit_tb/PCin_tb
add wave -noupdate /controlunit_tb/Imm1_in_tb
add wave -noupdate /controlunit_tb/Imm2_in_tb
add wave -noupdate /controlunit_tb/PCsel_tb
add wave -noupdate /controlunit_tb/Rfaddr_tb
add wave -noupdate /controlunit_tb/OPC_tb
add wave -noupdate /controlunit_tb/ena_tb
add wave -noupdate /controlunit_tb/done_tb
add wave -noupdate /controlunit_tb/done_FSM_tb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {708182 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 186
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {678361 ps}
