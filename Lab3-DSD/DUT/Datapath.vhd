library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Datapath is
generic(
    Dwidth: integer := 16;
    Awidth: integer := 6;
    dept: integer := 64
);
port(
    clk: in std_logic;
    -- control signals
    Mem_wr,Mem_out,Men_in,Cout,Cin,Ain,RFin,RFout,Rfaddr,IRin,PCin,Imm1_in,Imm2_in :in std_logic;
    PCsel: in std_logic_vector(1 downto 0);
    OPC : in std_logic_vector(3 downto 0);
    -- status signal
    Status: out std_logic_vector(Dwidth-1 downto 0);
    Cflag, Zflag, Nflag: out std_logic;
    -- data bus
    progMemEn: out std_logic;
    dataMemEn: out std_logic;
    progWmemAddr: out std_logic_vector(Awidth-1 downto 0);
    readAddr: out std_logic_vector(Awidth-1 downto 0);
    progRmemData: in std_logic_vector(Dwidth-1 downto 0);
    dataWmemData: out std_logic_vector(Dwidth-1 downto 0);
    dataRmemAddr: out std_logic_vector(Awidth-1 downto 0);
    dataRmemData: in std_logic_vector(Dwidth-1 downto 0)
);
end Datapath;
 
architecture behav of Datapath is

    -- ProgMem component
    component ProgMem
        generic(
            Dwidth: integer := 16;
            Awidth: integer := 6;
            dept: integer := 64
        );
        port(
            clk, memEn: in std_logic;
            WmemData: in std_logic_vector(Dwidth-1 downto 0);
            WmemAddr, RmemAddr: in std_logic_vector(Awidth-1 downto 0);
            RmemData: out std_logic_vector(Dwidth-1 downto 0)
        );
    end component;

    -- dataMem component
    component dataMem
        generic(
            Dwidth: integer := 16;
            Awidth: integer := 6;
            dept: integer := 64
        );
        port(
            clk, memEn: in std_logic;
            WmemData: in std_logic_vector(Dwidth-1 downto 0);
            WmemAddr, RmemAddr: in std_logic_vector(Awidth-1 downto 0);
            RmemData: out std_logic_vector(Dwidth-1 downto 0)
        );
    end component;

    -- ALU component
    component ALU
    generic (
      Dwidth: integer := 16;
      k : integer := 4;   -- k=log2(n)
      m : integer := 8    -- m=2^(k-1)
    );
    PORT (
      Y_i, X_i : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
      ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
      ALUout_o : OUT STD_LOGIC_VECTOR(n-1 downto 0);
      Nflag_o, Cflag_o, Zflag_o, OF_flag_o : OUT STD_LOGIC 
    ); -- Zflag, Cflag, Nflag, Vflag
    end component;

    -- Signals for connecting to ProgMem
    signal progMemEn_sig: std_logic := '0';
    signal progWmemAddr_sig, progRmemAddr_sig: std_logic_vector(Awidth-1 downto 0) := (others => '0');
    signal progWmemData_sig: std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal progRmemData_sig: std_logic_vector(Dwidth-1 downto 0);

    -- Signals for connecting to dataMem
    signal dataMemEn_sig: std_logic := '0';
    signal dataWmemAddr_sig, dataRmemAddr_sig: std_logic_vector(Awidth-1 downto 0) := (others => '0');
    signal dataWmemData_sig: std_logic_vector(Dwidth-1 downto 0) := (others => '0');
    signal dataRmemData_sig: std_logic_vector(Dwidth-1 downto 0);

    -- File reading process variables
    file prog_memory_file: text open read_mode is "./program/ITCMinit.txt";
    file data_memory_file: text open read_mode is "./program/DTCMinit.txt";
    variable file_line: line;
    variable read_addr: integer;
    variable read_data: std_logic_vector(Dwidth-1 downto 0);

    -- Program counter
    signal PCin, PCout: std_logic_vector(Awidth-1 downto 0);

    -- IR register
    signal IR: std_logic_vector(Dwidth-1 downto 0);

    -- Bi directional bus
    signal fabric: std_logic_vector(Dwidth-1 downto 0);

begin

    -- Instantiate ProgMem
    U1: ProgMem
        port map (
            clk => clk,
            memEn => progMemEn_sig,
            WmemData => progWmemData_sig,
            WmemAddr => progWmemAddr_sig,
            RmemAddr => PCout,
            RmemData => progRmemData_sig
        );

    -- Instantiate dataMem
    U2: dataMem
        port map (
            clk => clk,
            memEn => dataMemEn_sig,
            WmemData => dataWmemData_sig,
            WmemAddr => dataWmemAddr_sig,
            RmemAddr => dataRmemAddr_sig,
            RmemData => dataRmemData_sig
        );

    -- Process to read data from prog_memory_file and write to program memory
    process(clk)
    begin
        if rising_edge(clk) then
            if not endfile(prog_memory_file) then
                readline(prog_memory_file, file_line);
                read(file_line, read_addr);
                read(file_line, read_data);

                progWmemAddr_sig <= std_logic_vector(to_unsigned(read_addr, Awidth));
                progWmemData_sig <= read_data;
                progMemEn_sig <= '1';
            else
                progMemEn_sig <= '0';
            end if;
        end if;
    end process;

    -- Process to read data from data_memory_file and write to data memory
    process(clk)
    begin
        if rising_edge(clk) then
            if not endfile(data_memory_file) then
                readline(data_memory_file, file_line);
                read(file_line, read_addr);
                read(file_line, read_data);

                dataWmemAddr_sig <= std_logic_vector(to_unsigned(read_addr, Awidth));
                dataWmemData_sig <= read_data;
                dataMemEn_sig <= '1';
            else
                dataMemEn_sig <= '0';
            end if;
        end if;
    end process;

    -- Program counter process
    process(clk, PCin, PCsel)
    begin
        if rising_edge(clk) then
            if PCin = '1' then
                PCout <= PCin + 1 when PCsel = '00' else
                         PCin + 1 + offset_addr when PCsel = '01' else
                         (others => '0') when PCsel = '10';
            end if;
        end if;
    end process;

    -- OPCdecoder concurrent statement
    Status <= IR(Dwidth-1 downto Dwidth-4);

    -- IR register process
    process(clk)
    begin
        if rising_edge(clk) then
            IR <= RmemData when IRin = '1';
        end if;
    end process;

    -- RF register process WIP
    process(clk)
    begin
        if rising_edge(clk) then
            RFout <= RmemData when RFout = '1';
        end if;
    end process;

    -- ALU process 
    process(clk)
    signal REGA, REGC: std_logic_vector(Dwidth-1 downto 0);
    begin
        if rising_edge(clk) then
            if Ain = '1' then
                REGA <= fabric;
            end if;
            if Cin = '1' then
                REGC <= s;
            end if;
        end if;
        --concurrent statement
        ALUFN_i <= OPC;
        if Cout = '1' then
            fabric <= REGC;
        end if;
        Cflag <= Cf;
        Zflag <= Zf;
        Nflag <= Nf;
    end process;
    

end behav;
