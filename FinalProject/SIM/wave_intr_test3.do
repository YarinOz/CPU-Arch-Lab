onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /mcuint2_tb/clk
add wave -noupdate -radix hexadecimal /mcuint2_tb/rst
add wave -noupdate -radix hexadecimal /mcuint2_tb/ena
add wave -noupdate -radix hexadecimal /mcuint2_tb/HEX0
add wave -noupdate -radix hexadecimal /mcuint2_tb/HEX1
add wave -noupdate -radix hexadecimal /mcuint2_tb/HEX2
add wave -noupdate -radix hexadecimal /mcuint2_tb/HEX3
add wave -noupdate -radix hexadecimal /mcuint2_tb/HEX4
add wave -noupdate -radix hexadecimal /mcuint2_tb/HEX5
add wave -noupdate -radix hexadecimal /mcuint2_tb/LEDs
add wave -noupdate -radix hexadecimal /mcuint2_tb/KEY3
add wave -noupdate -radix hexadecimal /mcuint2_tb/BTOUT
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/rst
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/clk
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/MemWrite
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/MemRead
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/addressbus
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/databus
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/set_divifg
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/divisor
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/dividend
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/quotient
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/residue
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/databusout
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/divisor_ready
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/DIV/divifg
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/clk
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/rst
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/MemReadBus
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/MemWriteBus
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/AddressBus
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/DataBus
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IntSRC
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IRQOut
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/GIE
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/ClrIRQ
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IntActive
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IntReq
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IntAck
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IRQ
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IRQ_CLR
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IE
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/IFG
add wave -noupdate -color Gold -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/TypeREG
add wave -noupdate -radix hexadecimal /mcuint2_tb/uut/Interrupt_Controller/holdTYPE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {866254 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 298
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
WaveRestoreZoom {0 ps} {929792 ps}
