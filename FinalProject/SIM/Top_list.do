onerror {resume}
add list -width 13 /tb_top/Y_i
add list /tb_top/X_i
add list /tb_top/ALUFN_i
add list /tb_top/ALUout_o
add list /tb_top/Nflag_o
add list /tb_top/Cflag_o
add list /tb_top/Zflag_o
add list /tb_top/OF_flag_o
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
