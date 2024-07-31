library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity ALU is
    generic (Dwidth : integer := 32);
    port (
        A, B : in std_logic_vector(Dwidth-1 downto 0);
        ALUop : in std_logic_vector(5 downto 0);
        Result : out std_logic_vector(Dwidth-1 downto 0);
        Zero : out std_logic
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(A, B, ALUop)
    variable mul_result : std_logic_vector(Dwidth*2-1 downto 0);
    begin
        case ALUop is
            when "100000" =>  -- add
                Result <= A + B;
            when "100001" =>  -- addu
                Result <= A + B;
            when "001000" =>  -- addi
                Result <= A + B;
            when "100010" =>  -- sub
                Result <= A - B;
            when "100100" =>  -- and
                Result <= A and B;
            when "001100" => -- andi
                Result <= A and B;
            when "100101" =>  -- or
                Result <= A or B;
            when "001101" =>  -- ori
                Result <= A or B;
            when "100110" =>  -- xor
                Result <= A xor B;
            when "001110" =>  -- xori
                Result <= A xor B;
            when "000010" =>  -- srl
                Result <= B srl conv_integer(A(4 downto 0));
            when "000000" =>  -- sll
                Result <= B sll conv_integer(A(4 downto 0));
            when "101010" =>  -- slt
                if (A < B) then
                    Result <= "00000000000000000000000000000001";
                else
                    Result <= (others => '0');
                end if;
            when "011100" =>  -- mul
                mul_result := A * B;
                Result <= mul_result(Dwidth-1 downto 0);
            when others =>
                Result <= (others => '0');
        end case;
        Zero <= '1' when (Result = 0) else '0';
    end process;
end Behavioral;
