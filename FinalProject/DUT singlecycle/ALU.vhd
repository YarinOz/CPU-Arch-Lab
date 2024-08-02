library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_unsigned.all;
-- use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.aux_package.all;

entity ALU is
    generic (Dwidth : integer := 32);
    port (
        A, B : in std_logic_vector(Dwidth-1 downto 0);
        ALUop : in std_logic_vector(5 downto 0);
        Result : out std_logic_vector(Dwidth-1 downto 0)
    );
end ALU;
architecture Behavioral of ALU is
    begin
        process(A, B, ALUop)
        variable mul_result : std_logic_vector(Dwidth*2-1 downto 0);
        variable A_int, B_int : signed(Dwidth-1 downto 0);
        variable A_uint, B_uint : unsigned(Dwidth-1 downto 0);
        variable Result_int : signed(Dwidth-1 downto 0);
        variable Result_uint : unsigned(Dwidth-1 downto 0);
        begin
            A_int := signed(A);
            B_int := signed(B);
            A_uint := unsigned(A);
            B_uint := unsigned(B);
            
            case ALUop is
                when "100000" =>  -- add
                    Result_int := A_int + B_int;
                    Result <= std_logic_vector(Result_int);
                when "101011" => -- sw
                    Result_int := A_int + B_int;
                    Result <= std_logic_vector(Result_int);
                when "100011" => -- lw
                    Result_int := A_int + B_int;
                    Result <= std_logic_vector(Result_int);
                when "100001" =>  -- addu
                    Result_uint := A_uint + B_uint;
                    Result <= std_logic_vector(Result_uint);
                when "001000" =>  -- addi
                    Result_int := A_int + B_int;
                    Result <= std_logic_vector(Result_int);
                when "100010" =>  -- sub
                    Result_int := A_int - B_int;
                    Result <= std_logic_vector(Result_int);
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
                    Result_uint := B_uint srl to_integer(unsigned(A(4 downto 0)));
                    Result <= std_logic_vector(Result_uint);
                when "000000" =>  -- sll
                    Result_uint := B_uint sll to_integer(unsigned(A(4 downto 0)));
                    Result <= std_logic_vector(Result_uint);
                when "101010" =>  -- slt
                    if A_int < B_int then
                        Result <= (others => '0');
                        Result(Dwidth-1) <= '1';
                    else
                        Result <= (others => '0');
                    end if;
                when "011100" =>  -- mul
                    mul_result := std_logic_vector(signed(A) * signed(B));
                    Result <= mul_result(Dwidth-1 downto 0);
                when others =>
                    Result <= (others => '0');
            end case;
    end process;
end Behavioral;