library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ALU_tb is
end ALU_tb;

architecture Behavioral of ALU_tb is
    constant Dwidth : integer := 32;
    
    signal A, B : std_logic_vector(Dwidth-1 downto 0);
    signal ALUop : std_logic_vector(5 downto 0);
    signal Result : std_logic_vector(Dwidth-1 downto 0);
    signal Zero : std_logic;

begin
    -- Instantiate the ALU
    uut: entity work.ALU
        generic map (Dwidth => Dwidth)
        port map (
            A => A,
            B => B,
            ALUop => ALUop,
            Result => Result,
            Zero => Zero
        );

    -- Test process
    stim_proc: process
    begin
        -- Test addition
        A <= "00000000000000000000000000000011"; -- 3
        B <= "00000000000000000000000000000100"; -- 4
        ALUop <= "100000"; -- add
        wait for 10 ns;
        
        -- Test subtraction
        A <= "00000000000000000000000000000100"; -- 4
        B <= "00000000000000000000000000000011"; -- 3
        ALUop <= "100010"; -- sub
        wait for 10 ns;
        
        -- Test AND
        A <= "00000000000000000000000000001111"; -- 15
        B <= "00000000000000000000000000000101"; -- 5
        ALUop <= "100100"; -- and
        wait for 10 ns;
        
        -- Test OR
        A <= "00000000000000000000000000001111"; -- 15
        B <= "00000000000000000000000000000101"; -- 5
        ALUop <= "100101"; -- or
        wait for 10 ns;
        
        -- Test XOR
        A <= "00000000000000000000000000001111"; -- 15
        B <= "00000000000000000000000000000101"; -- 5
        ALUop <= "100110"; -- xor
        wait for 10 ns;
        
        -- Test shift right logical (srl)
        A <= "00000000000000000000000000000010"; -- 2 (shift amount)
        B <= "00000000000000000000000000001111"; -- 15
        ALUop <= "000010"; -- srl
        wait for 10 ns;
        
        -- Test shift left logical (sll)
        A <= "00000000000000000000000000000010"; -- 2 (shift amount)
        B <= "00000000000000000000000000001111"; -- 15
        ALUop <= "000000"; -- sll
        wait for 10 ns;
        
        -- Test set less than (slt)
        A <= "00000000000000000000000000000011"; -- 3
        B <= "00000000000000000000000000000100"; -- 4
        ALUop <= "101010"; -- slt
        wait for 10 ns;
        
        -- Test multiplication
        A <= "00000000000000000000000000000011"; -- 3
        B <= "00000000000000000000000000000100"; -- 4
        ALUop <= "011100"; -- mul
        wait for 10 ns;

        -- Test for Zero output
        A <= "00000000000000000000000000000000"; -- 0
        B <= "00000000000000000000000000000000"; -- 0
        ALUop <= "100000"; -- add
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
