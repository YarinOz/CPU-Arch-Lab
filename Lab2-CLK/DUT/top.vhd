LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	-- signals x[j-1], x[j-2], diff
	signal x_j1, x_j2, x_j2_not : std_logic_vector(n-1 downto 0) := (others => '0');
    signal diff : std_logic_vector(n-1 downto 0) := (others => '0'); -- need to see if n downto 0 if OF
	signal diff_cout : std_logic;
    signal cin : std_logic := '1'; -- For two's complement subtraction

begin
	
	process1: process(clk, rst)
	begin
		-- asynchronous reset
		if rst = '1' then
			x_j1 <= (others => '0');
			x_j2 <= (others => '0');
		-- synchronous logic	
		elsif rising_edge(clk) then
			if ena = '1' then
				x_j2 <= x_j1;
				x_j1 <= x;
			end if;
		end if;
	end process process1;

	-- Create the two's complement of x_j2
    process2: process(x_j2)
    begin
        x_j2_not <= not x_j2;
    end process process2;

	-- Use the Adder to compute diff = x_j1 - x_j2
	Adder_inst: Adder -- X + not(Y) + 1 = X - Y
	generic map (length => n)
	port map (
		a => x_j1,
		b => x_j2_not, -- Two's complement: invert x_j2
		cin => cin, -- Carry in for two's complement subtraction
		s => diff,
		cout => diff_cout
	);

	process3: process(diff, DetectionCode)
	begin
        case DetectionCode is
            when 0 => -- DetectionCode 0: x[j-1] - x[j-2] = 1
                if diff = "000000001" then
                    detector <= '1';
                else
                    detector <= '0';
                end if;
            when 1 => -- DetectionCode 1: x[j-1] - x[j-2] = 2
                if diff = "000000010" then
                    detector <= '1';
                else
                    detector <= '0';
                end if;
            when 2 => -- DetectionCode 2: x[j-1] - x[j-2] = 3
                if diff = "000000011" then
                    detector <= '1';
                else
                    detector <= '0';
                end if;
            when 3 => -- DetectionCode 3: x[j-1] - x[j-2] = 4
                if diff = "000000100" then
                    detector <= '1';
                else
                    detector <= '0';
                end if;
            when others =>
                detector <= '0';
        end case;
	end process process3;
				
end arc_sys;







