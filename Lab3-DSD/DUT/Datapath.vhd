library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;

entity Datapath is
generic(
    Dwidth: integer := 16;
    Awidth: integer := 6;
    dept: integer := 64
);
port(
    clk, rst: in std_logic;
    -- control signals
    Mem_wr,Mem_out,Men_in,Cout,Cin,Ain,RFin,RFout,IRin,PCin,Imm1_in,Imm2_in :in std_logic;
    PCsel, Rfaddr: in std_logic_vector(1 downto 0);
    OPC: in std_logic_vector(3 downto 0);
    -- status signals
    st, ld, mov, done, add, sub, jmp, jc, jnc, andf,
    orf, xorf, Cflag, Zflag, Nflag, un1, un2, un3, un4: out std_logic;
    -- program memory signals
    -- test bench signals
    -- progMemEn: in std_logic;
    -- progdataIn: in std_logic_vector(Dwidth-1 downto 0);
    -- progwriteAddr: in std_logic_vector(Awidth-1 downto 0);
    -- --synthesis signals
    -- progreadAddr: in std_logic_vector(Awidth-1 downto 0);
    -- progdataOut: out std_logic_vector(Dwidth-1 downto 0);
    -- -- data memory signals
    -- -- test bench signals
    -- dataMemEn: in std_logic;
    -- datadataIn: in std_logic_vector(Dwidth-1 downto 0);
    -- datawriteAddr: in std_logic_vector(Awidth-1 downto 0);
    -- --synthesis signals
    -- datareadAddr: out std_logic_vector(Awidth-1 downto 0);
    -- datadataOut: in std_logic_vector(Dwidth-1 downto 0);

);
end Datapath;
 
architecture behav of Datapath is
    -- Program counter
    signal PCin, PCout: std_logic_vector(Awidth-1 downto 0);

    -- IR register
    signal IR: std_logic_vector(Dwidth-1 downto 0);

    -- RF signals
    signal RWAddr: std_logic_vector(3 downto 0);           -- RF write address
    signal RFRData, RFWData: std_logic_vector(Dwidth-1 downto 0); -- RF read and write data

    -- ALU signals  
    signal REGA, REGC, Bin, C: std_logic_vector(Dwidth-1 downto 0);

    -- Bi directional bus
    signal fabric, Immediate: std_logic_vector(Dwidth-1 downto 0);

begin 
-------------------- port mapping ---------------------------------------------------------------
U1: ProgMem generic map (Dwidth, Awidth, dept) port map (clk, progMemEn, progdataIn, progwriteAddr, PCout, progdataOut);
U2: DataMem generic map (Dwidth, Awidth, dept) port map (clk, dataMemEn, datadataIn, datawriteAddr, datareadAddr, datadataOut);
U3: RF generic map (Dwidth, Awidth) port map (clk, rst, RFin, RFWData, RWAddr, RWAddr, RFRData);
U4: ALU generic map (Dwidth) port map (REGA, Bin, OPC, C, Nflag, Cflag, Zflag); -- B-A, B+A
-----------------------------------------------------------------------------------------------

------------------- Bi-directional bus ---------------------------------------------------------
DatamemOut: BidirPin generic map (Dwidth) port map (datadataOut, Mem_out, datareadAddr, fabric);
ALUout: BidirPin generic map (Dwidth) port map (REGC, Cout, Bin, fabric);
RFout: BidirPin generic map (Dwidth) port map (RFRData, RFout, RFWData, fabric);
IMM1out: BidirPin generic map (Dwidth) port map (Immediate, Imm1_in, RFWData, fabric);
IMM2out: BidirPin generic map (Dwidth) port map (Immediate, Imm2_in, RFWData, fabric);

Immediate <= "00000000" & IR(7 downto 0) when Imm1_in = '1' else
             "000000000000" & IR(3 downto 0) when Imm2_in = '1' else
             (others => 'Z');
-----------------------------------------------------------------------------------------------

    -- Process to read data from prog_memory_file and write to program memory
    process(clk)
    begin
        if rising_edge(clk) then
            if not endfile(prog_memory_file) then
                readline(prog_memory_file, file_line);
                read(file_line, read_addr);
                read(file_line, read_data);

                progwriteAddr <= std_logic_vector(to_unsigned(read_addr, Awidth));
                progdataIn <= read_data;
                progMemEn <= '1';
            else
                progMemEn <= '0';
            end if;
        end if;
    end process;

    -- offset address in J-Type instructions
    variable offset_addr: std_logic_vector(7 downto 0);
        begin
            offset_addr := IR(7 downto 0);
        end;
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

    -- IR register process
    process(clk)
    variable ra, rb, rc: std_logic_vector(3 downto 0);
    ra := IR(11 downto 8);
    rb := IR(7 downto 4);
    rc := IR(3 downto 0);

    begin
        if rising_edge(clk) then
            IR <= progdataOut when IRin = '1';
        end if;
        RFWAddr <= rc when RFaddr = "00" else
                   rb when RFaddr = "01" else
                   ra when RFaddr = "10" else
                   (others => '0');
        RFRData <= rc when RFaddr = "00" else
                   rb when RFaddr = "01" else
                   ra when RFaddr = "10" else
                   (others => '0');
    end process;

    -- OPC decoder process
    process(clk)
    begin
        -- asynchronous reset
        if rst = '1' then
            add <= '0';
            sub <= '0';
            andf <= '0';
            orf <= '0';
            xorf <= '0';
            un1 <= '0';
            un2 <= '0';
            jmp <= '0';
            jc <= '0';
            jnc <= '0';
            un3 <= '0';
            un4 <= '0';
            mov <= '0';
            ld <= '0';
            st <= '0';
            done <= '0';
        end if;
        -- synchronous decoding
        if rising_edge(clk) then
            case IR(Dwidth-1 downto Dwidth-4) is
                when "0000" =>
                    add <= '1';
                when "0001" =>
                    sub <= '1';
                when "0010" =>
                    andf <= '1';
                when "0011" =>
                    orf <= '1';
                when "0100" =>
                    xorf <= '1';
                when "0101" =>
                    un1 <= '1';
                when "0110" =>
                    un2 <= '1';
                when "0111" =>
                    jmp <= '1';
                when "1000" =>
                    jc <= '1';
                when "1001" =>
                    jnc <= '1';
                when "1010" =>
                    un3 <= '1';
                when "1011" =>
                    un4 <= '1';
                when "1100" =>
                    mov <= '1';
                when "1101" =>
                    ld <= '1';
                when "1110" =>
                    st <= '1';
                when "1111" =>
                    done <= '1';
            end case;
        end if;
    end process;

    -- ALU process 
    process(clk)
    begin
        if rising_edge(clk) then
            if Ain = '1' then
                REGA <= fabric;
            end if;
            if Cin = '1' then
                REGC <= C;
            end if;
        end if;
        --concurrent statement
        -- Cflag <= Cf;
        -- Zflag <= Zf;
        -- Nflag <= Nf;
    end process;
    

end behav;
