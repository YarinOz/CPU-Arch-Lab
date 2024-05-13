LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
--------------------------------------------------------
ENTITY AdderSub IS
    GENERIC (n: INTEGER := 8);
	PORT (x, y: IN std_logic_vector(n-1 DOWNTO 0);
            sub_c: IN std_logic;
            s: OUT std_logic_vector(n-1 DOWNTO 0);
            cout: OUT std_logic);
END AdderSub;
--------------------------------------------------------
ARCHITECTURE AdderSubt OF AdderSub IS
    SIGNAL c: std_logic_vector(n-1 DOWNTO 0);
BEGIN
	first: FA PORT MAP (
            xi => (x(0) XOR sub_c),
            yi => y(0), 
            cin => sub_c, 
            s => s(0), 
            cout => c(0));

    rest: FOR i IN 1 TO n-1 GENERATE
        FA_i: FA PORT MAP (
            xi => (x(i) XOR sub_c),
            yi => y(i), 
            cin => c(i-1), 
            s => s(i), 
            cout => c(i));
    END GENERATE;
    cout <= c(n-1);
END AdderSubt;