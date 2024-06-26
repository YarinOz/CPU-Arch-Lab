onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ourtb/st
add wave -noupdate /ourtb/ld
add wave -noupdate /ourtb/mov
add wave -noupdate /ourtb/done
add wave -noupdate /ourtb/add
add wave -noupdate /ourtb/sub
add wave -noupdate /ourtb/jmp
add wave -noupdate /ourtb/jc
add wave -noupdate /ourtb/jnc
add wave -noupdate /ourtb/Cflag
add wave -noupdate /ourtb/Zflag
add wave -noupdate /ourtb/Nflag
add wave -noupdate /ourtb/andf
add wave -noupdate /ourtb/orf
add wave -noupdate /ourtb/xorf
add wave -noupdate /ourtb/un1
add wave -noupdate /ourtb/un2
add wave -noupdate /ourtb/un3
add wave -noupdate /ourtb/un4
add wave -noupdate /ourtb/IRin
add wave -noupdate /ourtb/Imm1_in
add wave -noupdate /ourtb/Imm2_in
add wave -noupdate /ourtb/RFin
add wave -noupdate /ourtb/RFout
add wave -noupdate /ourtb/PCin
add wave -noupdate /ourtb/Ain
add wave -noupdate /ourtb/Cin
add wave -noupdate /ourtb/Cout
add wave -noupdate /ourtb/Mem_wr
add wave -noupdate /ourtb/Mem_out
add wave -noupdate /ourtb/Mem_in
add wave -noupdate /ourtb/OPC
add wave -noupdate /ourtb/done_FSM
add wave -noupdate /ourtb/PCsel
add wave -noupdate /ourtb/RFaddr
add wave -noupdate /ourtb/TBactive
add wave -noupdate /ourtb/clk
add wave -noupdate /ourtb/progMemEn
add wave -noupdate /ourtb/dataMemEn
add wave -noupdate /ourtb/dataDataIn
add wave -noupdate /ourtb/progDataIn
add wave -noupdate /ourtb/progWriteAddr
add wave -noupdate /ourtb/dataWriteAddr
add wave -noupdate /ourtb/dataReadAddr
add wave -noupdate /ourtb/dataDataOut
add wave -noupdate /ourtb/donePmemIn
add wave -noupdate /ourtb/doneDmemIn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6834145 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {7937371 ps}
