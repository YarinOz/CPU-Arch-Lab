LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY AdderSub IS
    GENERIC (n: INTEGER := 8);
	PORT (sub_c, cin: IN std_logic;
            x, y: IN std_logic_vector(n-1 DOWNTO 0);
            s: OUT std_logic_vector(n-1 DOWNTO 0);
            cout: OUT std_logic);
END AdderSub;
--------------------------------------------------------
ARCHITECTURE AdderSubt OF AdderSub IS
    COMPONENT FA IS
        PORT (xi, yi, cin: IN std_logic;
              s, cout: OUT std_logic);
    END COMPONENT;
    SIGNAL c: std_logic_vector(n-1 DOWNTO 0);
BEGIN
	first: FA PORT MAP (
            xi => x(0) XOR sub_c,
            yi => yi(0), 
            cin => sub_c, 
            s => s(0), 
            cout => c(0));
    rest: FOR i IN 1 TO n-1 GENERATE
        FA_i: FA PORT MAP (
            xi => x(i) XOR sub_c,
            yi => yi(i), 
            cin => c(i-1), 
            s => s(i), 
            cout => c(i));
    END GENERATE;
    cout <= c(n-1);
END AdderSubt;