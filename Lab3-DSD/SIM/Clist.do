onerror {resume}
add list -width 24 /controlunit_tb/clk_tb
add list /controlunit_tb/rst_tb
add list /controlunit_tb/st_tb
add list /controlunit_tb/ld_tb
add list /controlunit_tb/mov_tb
add list /controlunit_tb/done_tb
add list /controlunit_tb/add_tb
add list /controlunit_tb/sub_tb
add list /controlunit_tb/jmp_tb
add list /controlunit_tb/jc_tb
add list /controlunit_tb/jnc_tb
add list /controlunit_tb/andf_tb
add list /controlunit_tb/orf_tb
add list /controlunit_tb/xorf_tb
add list /controlunit_tb/Cflag_tb
add list /controlunit_tb/Zflag_tb
add list /controlunit_tb/Nflag_tb
add list /controlunit_tb/ena_tb
add list /controlunit_tb/Mem_wr_tb
add list /controlunit_tb/Mem_out_tb
add list /controlunit_tb/Mem_in_tb
add list /controlunit_tb/Cout_tb
add list /controlunit_tb/Cin_tb
add list /controlunit_tb/Ain_tb
add list /controlunit_tb/RFin_tb
add list /controlunit_tb/RFout_tb
add list /controlunit_tb/IRin_tb
add list /controlunit_tb/PCin_tb
add list /controlunit_tb/Imm1_in_tb
add list /controlunit_tb/Imm2_in_tb
add list /controlunit_tb/PCsel_tb
add list /controlunit_tb/Rfaddr_tb
add list /controlunit_tb/OPC_tb
add list /controlunit_tb/done_FSM_tb
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
