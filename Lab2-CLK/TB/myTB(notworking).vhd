library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity tb is
	constant n : integer := 8;
end tb;

architecture rtb of tb is
	SIGNAL rst, ena, clk : std_logic;
	SIGNAL x : std_logic_vector(n-1 downto 0);
	SIGNAL DetectionCode : integer range 0 to 3;
	SIGNAL detector : std_logic;
begin
	L0 : top generic map (8, 7, 3) port map (rst, ena, clk, x, DetectionCode, detector);

	------------ start of stimulus section --------------	
    gen_clk : process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= not clk;
        wait for 50 ns;
    end process;
	
    gen_x : process
    begin
        x <= (others => '0');
        wait for 100 ns;
        x <= "00000001"; -- diff = 1
        wait for 100 ns;
        x <= "00000010"; -- diff = 1
        wait for 100 ns;
        x <= "00000011"; -- diff = 1
        wait for 100 ns;
        x <= "00000100"; -- diff = 1
        wait for 100 ns;
        x <= "00000101"; -- diff = 1
        wait for 100 ns;
        x <= "00000110"; -- diff = 1
        wait for 100 ns;
        x <= "00000111"; -- diff = 1
        wait for 100 ns;
        x <= "00001000"; -- diff = 1
        wait for 100 ns;
        x <= "00001001"; -- diff = 1
        wait for 100 ns;
        x <= "00001010"; -- diff = 1
        wait for 100 ns;
        x <= "00001011"; -- diff = 1
        wait for 2.5 us;
        x <= "00011111"; -- diff = 3
        wait for 100 ns;
        x <= "00011100"; -- diff = 3
        wait for 100 ns;
        x <= "00011001"; -- diff = 3
        wait for 100 ns;
        x <= "00010110"; -- diff = 3
        wait for 100 ns;
        x <= "00010011"; -- diff = 3
        wait for 100 ns;
        x <= "00010000"; -- diff = 3
        wait for 100 ns;
        x <= "00001101"; -- diff = 3
        wait for 100 ns;
        x <= "00001010"; -- diff = 3
        wait for 100 ns;
        x <= "00000111"; -- diff = 3
        wait for 100 ns;
        x <= "00000100"; -- diff = 3
        wait;
    end process;
	  
    gen_rst : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process; 
	
    gen_ena : process
    begin
        ena <= '0';
        wait for 200 ns;
        ena <= '1';
        wait;
    end process;

    -- Testing detection codes with successful events
    gen_detection_code : process
    begin
        -- Start with DetectionCode 0
        DetectionCode <= 0;
        wait for 1.2 us; -- Wait long enough to check detection for code 0

        -- Change to DetectionCode 1
        DetectionCode <= 1;
        wait for 1.2 us; -- Wait long enough to check detection for code 1

        -- Change to DetectionCode 2
        DetectionCode <= 2;
        wait for 1.2 us; -- Wait long enough to check detection for code 2

        -- Change to DetectionCode 3
        DetectionCode <= 3;
        wait for 1.2 us; -- Wait long enough to check detection for code 3

        wait;
    end process;

end architecture rtb;
