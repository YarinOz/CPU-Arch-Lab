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
    SIGNAL x_temp, y_temp: std_logic_vector(n-1 DOWNTO 0);
    SIGNAL c: std_logic_vector(n-1 DOWNTO 0);
BEGIN
    x_temp <= x;
    y_temp <= y;
    x_loop: FOR i IN 0 TO n-1 GENERATE
        x_temp(i) <= (x(i) XOR sub_c);
    END GENERATE;
    y_loop: FOR i IN 0 TO n-1 GENERATE
        y_temp(i) <= y(i);
    END GENERATE;

    first: FA PORT MAP(
                xi=>x_temp(0),
                yi=>y_temp(0),
                cin=>sub_c,
                s=>s(0),
                cout=>c(0));

    rest: FOR i IN 1 TO n-1 GENERATE
            FA_i: FA PORT MAP(
                xi => x_temp(i),
                yi => y_temp(i), 
                cin => c(i-1), 
                s => s(i), 
                cout => c(i));
    END GENERATE;
    cout <= c(n-1);
END AdderSubt;
