onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/done_FSM
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/ena
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/TBactive
add wave -noupdate /top_tb/dataMemEn
add wave -noupdate /top_tb/progMemEn
add wave -noupdate /top_tb/progDataIn
add wave -noupdate /top_tb/dataDataIn
add wave -noupdate /top_tb/dataDataOut
add wave -noupdate /top_tb/progWriteAddr
add wave -noupdate /top_tb/dataWriteAddr
add wave -noupdate /top_tb/dataReadAddr
add wave -noupdate /top_tb/donePmemIn
add wave -noupdate /top_tb/doneDmemIn
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/clk
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/rst
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/st
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/ld
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/mov
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/done
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/add
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/sub
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/jmp
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/jc
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/jnc
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/andf
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/orf
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/xorf
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Cflag
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Zflag
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Nflag
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Mem_wr
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Mem_out
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Mem_in
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Cout
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Cin
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Ain
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/RFin
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/RFout
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/IRin
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/PCin
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Imm1_in
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Imm2_in
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/PCsel
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/Rfaddr
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/OPC
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/ena
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/done_FSM
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/current_state
add wave -noupdate /top_tb/TopUnit/CONTROLUNITEN/next_state
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/TBactive
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/clk
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/rst
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Mem_wr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Mem_out
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Mem_in
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Cout
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Cin
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Ain
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/RFin
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/RFout
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/IRin
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/PCin
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Imm1_in
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Imm2_in
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/PCsel
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Rfaddr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/OPC
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/st
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/ld
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/mov
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/done
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/add
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/sub
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/jmp
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/jc
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/jnc
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/andf
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/orf
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/xorf
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Cflag
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Zflag
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Nflag
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/un1
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/un2
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/un3
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/un4
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/progMemEn
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/progDataIn
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/progWriteAddr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/dataMemEn
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/dataDataIn
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/dataWriteAddr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/dataReadAddr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/dataDataOut
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/CurrPC
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/NextPC
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/PCout
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/IR
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/RWAddr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/RFRData
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/RFWData
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/REGA
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/REGC
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/Bin
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/C
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/fabric
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/offset_addr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/progDataOut
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/DataIn
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/DataOut
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/WAddr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/RAddr
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/RMUX
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/WMUX
add wave -noupdate /top_tb/TopUnit/DATAPATHUNIT/EnData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8598248 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 256
configure wave -valuecolwidth 64
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
WaveRestoreZoom {0 ps} {8836773 ps}
