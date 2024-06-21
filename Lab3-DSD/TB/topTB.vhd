library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
use std.textio.all;
use IEEE.STD_LOGIC_TEXTIO.all;

entity top_tb is
    constant Dwidth : integer := 16;
    constant m      : integer := 16;
    constant Awidth : integer := 6;     
    constant RegSize: integer := 4;
    constant dept   : integer := 64;

    constant dataMemResult:      string(1 to 78) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/Lab3-DSD/program/DTCMcontent.txt";
    constant dataMemLocation:    string(1 to 75) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/Lab3-DSD/program/DTCMinit.txt";
    constant progMemLocation:    string(1 to 75) := "/home/oziely/BGU/semester F/CPU & HW Lab/LABS/Lab3-DSD/program/ITCMinit.txt";
end top_tb;

architecture rtb of top_tb is
    SIGNAL done_FSM:             STD_LOGIC := '0';
    SIGNAL rst, ena, clk, TBactive, dataMemEn, progMemEn: STD_LOGIC;    
    SIGNAL progDataIn, dataDataIn, dataDataOut: STD_LOGIC_VECTOR (Dwidth-1 downto 0);
    SIGNAL progWriteAddr, dataWriteAddr, dataReadAddr: STD_LOGIC_VECTOR (Awidth-1 DOWNTO 0);
    SIGNAL donePmemIn, doneDmemIn: BOOLEAN;

begin
    TopUnit: entity work.top
        generic map (Dwidth => Dwidth, Awidth => Awidth, dept => dept)
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            done_FSM => done_FSM,
            progMemEn => progMemEn,
            progDataIn => progDataIn,
            progWriteAddr => progWriteAddr,
            dataMemEn => dataMemEn,
            TBactive => TBactive,
            dataDataIn => dataDataIn,
            dataWriteAddr => dataWriteAddr,
            dataReadAddr => dataReadAddr,
            dataDataOut => dataDataOut
        );

    --------- start of stimulus section ------------------    
    --------- Rst
    gen_rst : process
    begin
        rst <= '1', '0' after 100 ns;
        wait;
    end process;
    
    ------------ Clock
    gen_clk : process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= not clk;
        wait for 50 ns;
    end process;
    
    ---------  TB
    gen_TB : process
    begin
        TBactive <= '1';
        wait until donePmemIn and doneDmemIn;  
        TBactive <= '0';
        wait until done_FSM = '1';  
        TBactive <= '1';    
    end process;    

    --------- Reading from text file and initializing the data memory data --------
    LoadDataMem: process 
        file inDmemfile : text open read_mode is dataMemLocation;
        variable linetomem: std_logic_vector(Dwidth-1 downto 0);
        variable good: boolean;
        variable L: line;
        variable TempAddresses: std_logic_vector(Awidth-1 downto 0); 
    begin 
        doneDmemIn <= false;
        TempAddresses := (others => '0');
        while not endfile(inDmemfile) loop
            readline(inDmemfile, L);
            hread(L, linetomem, good);
            next when not good;
            dataMemEn <= '1';
            dataWriteAddr <= TempAddresses;
            dataDataIn <= linetomem;
            wait until rising_edge(clk);
            TempAddresses := TempAddresses + 1;
        end loop;
        dataMemEn <= '0';
        doneDmemIn <= true;
        file_close(inDmemfile);
        wait;
    end process;

    --------- Reading from text file and initializing the program memory instructions ------
    LoadProgramMem: process 
        file inPmemfile : text open read_mode is progMemLocation;
        variable linetomem: std_logic_vector(Dwidth-1 downto 0); 
        variable good: boolean;
        variable L: line;
        variable TempAddresses: std_logic_vector(Awidth-1 downto 0); 
    begin 
        donePmemIn <= false;
        TempAddresses := (others => '0');
        while not endfile(inPmemfile) loop
            readline(inPmemfile, L);
            hread(L, linetomem, good);
            next when not good;
            progMemEn <= '1';
            progWriteAddr <= TempAddresses;
            progDataIn <= linetomem;
            wait until rising_edge(clk);
            TempAddresses := TempAddresses + 1;
        end loop;
        progMemEn <= '0';
        donePmemIn <= true;
        file_close(inPmemfile);
        wait;
    end process;

    ena <= '1' when (doneDmemIn and donePmemIn) else '0';

    --------- Writing from Data memory to external text file, after the program ends (done_FSM = 1). -----
    WriteToDataMem: process 
        file outDmemfile : text open write_mode is dataMemResult;
        variable linetomem: std_logic_vector(Dwidth-1 downto 0);
        variable good: boolean;
        variable L: line;
        variable TempAddresses: std_logic_vector(Awidth-1 downto 0); 
        variable counter: integer;
    begin 
        wait until done_FSM = '1';  
        TempAddresses := (others => '0');
        counter := 1;
        while counter < 16 loop --15 lines in file
            dataReadAddr <= TempAddresses;
            wait until rising_edge(clk);
            wait until rising_edge(clk); -- added now 12/5/2023 14:48
            hwrite(L, dataDataOut);
            writeline(outDmemfile, L);
            TempAddresses := TempAddresses + 1;
            counter := counter + 1;
        end loop;
        file_close(outDmemfile);
        wait;
    end process;

end architecture rtb;