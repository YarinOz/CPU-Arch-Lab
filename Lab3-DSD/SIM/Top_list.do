onerror {resume}
add list -width 18 /top_tb/done_FSM
add list /top_tb/rst
add list /top_tb/ena
add list /top_tb/clk
add list /top_tb/TBactive
add list /top_tb/dataMemEn
add list /top_tb/progMemEn
add list /top_tb/progDataIn
add list /top_tb/dataDataIn
add list /top_tb/dataDataOut
add list /top_tb/progWriteAddr
add list /top_tb/dataWriteAddr
add list /top_tb/dataReadAddr
add list /top_tb/donePmemIn
add list /top_tb/doneDmemIn
add list /top_tb/TopUnit/DATAPATHUNIT/TBactive
add list /top_tb/TopUnit/DATAPATHUNIT/clk
add list /top_tb/TopUnit/DATAPATHUNIT/rst
add list /top_tb/TopUnit/DATAPATHUNIT/Mem_wr
add list /top_tb/TopUnit/DATAPATHUNIT/Mem_out
add list /top_tb/TopUnit/DATAPATHUNIT/Mem_in
add list /top_tb/TopUnit/DATAPATHUNIT/Cout
add list /top_tb/TopUnit/DATAPATHUNIT/Cin
add list /top_tb/TopUnit/DATAPATHUNIT/Ain
add list /top_tb/TopUnit/DATAPATHUNIT/RFin
add list /top_tb/TopUnit/DATAPATHUNIT/RFout
add list /top_tb/TopUnit/DATAPATHUNIT/IRin
add list /top_tb/TopUnit/DATAPATHUNIT/PCin
add list /top_tb/TopUnit/DATAPATHUNIT/Imm1_in
add list /top_tb/TopUnit/DATAPATHUNIT/Imm2_in
add list /top_tb/TopUnit/DATAPATHUNIT/PCsel
add list /top_tb/TopUnit/DATAPATHUNIT/Rfaddr
add list /top_tb/TopUnit/DATAPATHUNIT/OPC
add list /top_tb/TopUnit/DATAPATHUNIT/st
add list /top_tb/TopUnit/DATAPATHUNIT/ld
add list /top_tb/TopUnit/DATAPATHUNIT/mov
add list /top_tb/TopUnit/DATAPATHUNIT/done
add list /top_tb/TopUnit/DATAPATHUNIT/add
add list /top_tb/TopUnit/DATAPATHUNIT/sub
add list /top_tb/TopUnit/DATAPATHUNIT/jmp
add list /top_tb/TopUnit/DATAPATHUNIT/jc
add list /top_tb/TopUnit/DATAPATHUNIT/jnc
add list /top_tb/TopUnit/DATAPATHUNIT/andf
add list /top_tb/TopUnit/DATAPATHUNIT/orf
add list /top_tb/TopUnit/DATAPATHUNIT/xorf
add list /top_tb/TopUnit/DATAPATHUNIT/Cflag
add list /top_tb/TopUnit/DATAPATHUNIT/Zflag
add list /top_tb/TopUnit/DATAPATHUNIT/Nflag
add list /top_tb/TopUnit/DATAPATHUNIT/progMemEn
add list /top_tb/TopUnit/DATAPATHUNIT/progDataIn
add list /top_tb/TopUnit/DATAPATHUNIT/progWriteAddr
add list /top_tb/TopUnit/DATAPATHUNIT/dataMemEn
add list /top_tb/TopUnit/DATAPATHUNIT/dataDataIn
add list /top_tb/TopUnit/DATAPATHUNIT/dataWriteAddr
add list /top_tb/TopUnit/DATAPATHUNIT/dataReadAddr
add list /top_tb/TopUnit/DATAPATHUNIT/dataDataOut
add list /top_tb/TopUnit/DATAPATHUNIT/CurrPC
add list /top_tb/TopUnit/DATAPATHUNIT/NextPC
add list /top_tb/TopUnit/DATAPATHUNIT/PCout
add list /top_tb/TopUnit/DATAPATHUNIT/IR
add list /top_tb/TopUnit/DATAPATHUNIT/RWAddr
add list /top_tb/TopUnit/DATAPATHUNIT/RFRData
add list /top_tb/TopUnit/DATAPATHUNIT/RFWData
add list /top_tb/TopUnit/DATAPATHUNIT/REGA
add list /top_tb/TopUnit/DATAPATHUNIT/REGC
add list /top_tb/TopUnit/DATAPATHUNIT/Bin
add list /top_tb/TopUnit/DATAPATHUNIT/C
add list /top_tb/TopUnit/DATAPATHUNIT/fabric
add list /top_tb/TopUnit/DATAPATHUNIT/offset_addr
add list /top_tb/TopUnit/DATAPATHUNIT/progDataOut
add list /top_tb/TopUnit/DATAPATHUNIT/DataIn
add list /top_tb/TopUnit/DATAPATHUNIT/DataOut
add list /top_tb/TopUnit/DATAPATHUNIT/WAddr
add list /top_tb/TopUnit/DATAPATHUNIT/RAddr
add list /top_tb/TopUnit/DATAPATHUNIT/RMUX
add list /top_tb/TopUnit/DATAPATHUNIT/WMUX
add list /top_tb/TopUnit/DATAPATHUNIT/EnData
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
