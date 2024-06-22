LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
--------------------------------------------------------
ENTITY AdderSub IS
    GENERIC (Dwidth : INTEGER := 16);
	PORT (x, y: IN std_logic_vector(Dwidth-1 DOWNTO 0);
            sub_c : IN std_logic;
            s: OUT std_logic_vector(Dwidth-1 DOWNTO 0);
            cout: OUT std_logic);
END AdderSub;
--------------------------------------------------------
ARCHITECTURE AdderSubt OF AdderSub IS
    SIGNAL x_temp : std_logic_vector(Dwidth-1 DOWNTO 0);
    SIGNAL c: std_logic_vector(Dwidth-1 DOWNTO 0);
BEGIN
    -- x_temp <= x XOR sub_c;
    x_loop: FOR i IN 0 TO Dwidth-1 GENERATE
        x_temp(i) <= (x(i) XOR sub_c);
    END GENERATE;
    -- x_temp <= (x XOR (Dwidth => sub_c));

    first: FA PORT MAP(
                xi=>x_temp(0),
                yi=>y(0),
                cin=>sub_c,
                s=>s(0),
                cout=>c(0));

    rest: FOR i IN 1 TO Dwidth-1 GENERATE
            FA_i: FA PORT MAP(
                xi => x_temp(i),
                yi => y(i), 
                cin => c(i-1), 
                s => s(i), 
                cout => c(i));
    END GENERATE;
    cout <= c(Dwidth-1);
END AdderSubt;
