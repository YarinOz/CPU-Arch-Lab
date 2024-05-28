LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

--------------------------------------------------------------
entity top is
    generic (
        n : positive := 8;
        m : positive := 7;
        k : positive := 3  -- where k=log2(m+1)
    );
    port(
        rst, ena, clk : in std_logic;
        x : in std_logic_vector(n-1 downto 0);
        DetectionCode : in integer range 0 to 3;
        detector : out std_logic
    );
end top;

------------- complete the top Architecture code --------------
architecture arc_sys of top is
    -- signals x[j-1], x[j-2], diff
    signal x_j1, x_j2, x_j2_not : std_logic_vector(n-1 downto 0) := (others => '0');
    signal diff : std_logic_vector(n-1 downto 0) := (others => '0');
    signal diff_cout : std_logic;
    signal cin : std_logic := '1'; -- For two's complement subtraction
    signal counter : integer := 0; -- Counter for the number of consecutive detections

begin

    process(clk, rst)
    begin
        -- asynchronous reset
        if rst = '1' then
            x_j1 <= (others => '0');
            x_j2 <= (others => '0');
            counter <= 0;
            detector <= '0';
        -- synchronous logic  
        elsif rising_edge(clk) then
            if ena = '1' then
                x_j2 <= x_j1;
                x_j1 <= x;

                -- Compute diff = x_j1 - x_j2
                x_j2_not <= not x_j2;
				Adder_inst: Adder
				generic map (length => n)
				port map (
					a => x_j1,
					b => x_j2_not, -- Two's complement: invert x_j2
					cin => cin, -- Carry in for two's complement subtraction
					s => diff,
					cout => diff_cout
				);

                -- Check detection condition
                case DetectionCode is
                    when 0 => -- DetectionCode 0: x[j-1] - x[j-2] = 1
                        if diff = "00000001" then
                            counter <= counter + 1;
                        else 
                            counter <= 0;
                        end if;
                    when 1 => -- DetectionCode 1: x[j-1] - x[j-2] = 2
                        if diff = "00000010" then
                            counter <= counter + 1;
                        else 
                            counter <= 0;
                        end if;
                    when 2 => -- DetectionCode 2: x[j-1] - x[j-2] = 3
                        if diff = "00000011" then
                            counter <= counter + 1;
                        else 
                            counter <= 0;
                        end if;
                    when 3 => -- DetectionCode 3: x[j-1] - x[j-2] = 4
                        if diff = "00000100" then
                            counter <= counter + 1;
                        else 
                            counter <= 0;
                        end if;
                    when others =>
                        null; -- NOP
                end case;

                -- If counter reaches m, set detector to 1
                if counter >= m then
                    detector <= '1';
                else
                    detector <= '0';
                end if;
            end if;
        end if;
    end process;

end arc_sys;
