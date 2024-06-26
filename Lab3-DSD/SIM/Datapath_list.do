onerror {resume}
add list -width 11 /ourtb/st
add list /ourtb/ld
add list /ourtb/mov
add list /ourtb/done
add list /ourtb/add
add list /ourtb/sub
add list /ourtb/jmp
add list /ourtb/jc
add list /ourtb/jnc
add list /ourtb/Cflag
add list /ourtb/Zflag
add list /ourtb/Nflag
add list /ourtb/andf
add list /ourtb/orf
add list /ourtb/xorf
add list /ourtb/un1
add list /ourtb/un2
add list /ourtb/un3
add list /ourtb/un4
add list /ourtb/IRin
add list /ourtb/Imm1_in
add list /ourtb/Imm2_in
add list /ourtb/RFin
add list /ourtb/RFout
add list /ourtb/PCin
add list /ourtb/Ain
add list /ourtb/Cin
add list /ourtb/Cout
add list /ourtb/Mem_wr
add list /ourtb/Mem_out
add list /ourtb/Mem_in
add list /ourtb/OPC
add list /ourtb/done_FSM
add list /ourtb/PCsel
add list /ourtb/RFaddr
add list /ourtb/TBactive
add list /ourtb/clk
add list /ourtb/rst
add list /ourtb/progMemEn
add list /ourtb/dataMemEn
add list /ourtb/dataDataIn
add list /ourtb/progDataIn
add list /ourtb/progWriteAddr
add list /ourtb/dataWriteAddr
add list /ourtb/dataReadAddr
add list /ourtb/dataDataOut
add list /ourtb/donePmemIn
add list /ourtb/doneDmemIn
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
